//
//  CachedAsyncImage.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 13/12/2025.
//

import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let contentMode: ContentMode
    let content: (Image) -> Content
    let placeholder: () -> Placeholder
    
    @State private var image: UIImage?
    @State private var isLoading = false
    @State private var hasError = false
    @State private var loadTask: Task<Void, Never>?
    
    init(
        url: URL?,
        contentMode: ContentMode = .fill,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.contentMode = contentMode
        self.content = content
        self.placeholder = placeholder
    }
    
    var body: some View {
        Group {
            if let image = image {
                content(Image(uiImage: image))
            } else if hasError {
                placeholder()
            } else {
                ZStack {
                    placeholder()
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    }
                }
            }
        }
        .onAppear {
            loadImage()
        }
        .onDisappear {
            // Cancel task when view disappears to prevent memory leaks
            loadTask?.cancel()
            loadTask = nil
        }
        .onChange(of: url) { _ in
            // Cancel previous task when URL changes
            loadTask?.cancel()
            loadImage()
        }
    }
    
    private func loadImage() {
        guard let url = url else {
            image = nil
            isLoading = false
            hasError = false
            return
        }
        
        // Cancel any existing task
        loadTask?.cancel()
        
        isLoading = true
        hasError = false
        
        // Create new task with structured concurrency
        loadTask = Task { @MainActor in
            // Check if task was cancelled before starting
            guard !Task.isCancelled else { return }
            
            // Check cache first
            if let cachedImage = await ImageCache.shared.get(for: url) {
                guard !Task.isCancelled else { return }
                self.image = cachedImage
                self.isLoading = false
                return
            }
            
            do {
                // Fetch image with cancellation support
                // URLSession.data(from:) automatically respects task cancellation
                let (data, _) = try await URLSession.shared.data(from: url)
                guard !Task.isCancelled else { return }
                
                if let uiImage = UIImage(data: data) {
                    await ImageCache.shared.set(uiImage, for: url)
                    guard !Task.isCancelled else { return }
                    self.image = uiImage
                    self.isLoading = false
                } else {
                    guard !Task.isCancelled else { return }
                    self.hasError = true
                    self.isLoading = false
                }
            } catch {
                // Don't set error if task was cancelled (URLSession throws cancellation error)
                guard !Task.isCancelled, !(error is CancellationError) else { return }
                self.hasError = true
                self.isLoading = false
            }
        }
    }
}

// Thread-safe in-memory cache using actor
actor ImageCache {
    static let shared = ImageCache()
    private var cache: [URL: UIImage] = [:]
    private let maxCacheSize = 50 // Limit cache size
    
    private init() {}
    
    func get(for url: URL) -> UIImage? {
        return cache[url]
    }
    
    func set(_ image: UIImage, for url: URL) {
        // Simple LRU: remove oldest if cache is full
        if cache.count >= maxCacheSize {
            if let firstKey = cache.keys.first {
                cache.removeValue(forKey: firstKey)
            }
        }
        cache[url] = image
    }
    
    func clear() {
        cache.removeAll()
    }
    
    // Get cache size for monitoring
    func size() -> Int {
        return cache.count
    }
}

// Convenience initializer for simple use cases
extension CachedAsyncImage where Content == Image, Placeholder == Color {
    init(url: URL?, contentMode: ContentMode = .fill) {
        self.init(
            url: url,
            contentMode: contentMode,
            content: { $0 },
            placeholder: { Color.gray.opacity(0.2) }
        )
    }
}
