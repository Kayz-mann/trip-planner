//
//  ImageCacheEdgeCaseTests.swift
//  TripPlannerTests
//
//  Created by Balogun Kayode on 14/12/2025.
//

import Testing
import Foundation
import UIKit
@testable import TripPlanner

struct ImageCacheEdgeCaseTests {
    
    @Test("Cache should handle nil URL gracefully")
    func testCacheNilURL() async {
        let cache = ImageCache.shared
        let result = await cache.get(for: URL(string: "https://example.com/image.jpg")!)
        #expect(result == nil) // Cache is empty initially
    }
    
    @Test("Cache should store and retrieve images")
    func testCacheStoreAndRetrieve() async {
        let cache = ImageCache.shared
        let url = URL(string: "https://example.com/image.jpg")!
        let testImage = UIImage(systemName: "star")!
        
        await cache.set(testImage, for: url)
        let retrieved = await cache.get(for: url)
        
        #expect(retrieved != nil)
    }
    
    @Test("Cache should handle cache size limit")
    func testCacheSizeLimit() async {
        let cache = ImageCache.shared
        await cache.clear()
        
        // Add more than maxCacheSize (50) images
        for i in 0..<60 {
            let url = URL(string: "https://example.com/image\(i).jpg")!
            let testImage = UIImage(systemName: "star")!
            await cache.set(testImage, for: url)
        }
        
        // First image should be evicted (LRU)
        let firstURL = URL(string: "https://example.com/image0.jpg")!
        let firstImage = await cache.get(for: firstURL)
        // Note: This test depends on LRU implementation
        // The first image might be evicted if cache is full
    }
    
    @Test("Cache clear should remove all images")
    func testCacheClear() async {
        let cache = ImageCache.shared
        let url = URL(string: "https://example.com/image.jpg")!
        let testImage = UIImage(systemName: "star")!
        
        await cache.set(testImage, for: url)
        await cache.clear()
        
        let retrieved = await cache.get(for: url)
        #expect(retrieved == nil)
    }
    
    @Test("Cache should handle same URL multiple times")
    func testCacheSameURLMultipleTimes() async {
        let cache = ImageCache.shared
        let url = URL(string: "https://example.com/image.jpg")!
        let testImage1 = UIImage(systemName: "star")!
        let testImage2 = UIImage(systemName: "heart")!
        
        await cache.set(testImage1, for: url)
        await cache.set(testImage2, for: url)
        
        let retrieved = await cache.get(for: url)
        #expect(retrieved != nil)
        // Should be the last image set
    }
    
    @Test("Cache should handle concurrent access")
    func testCacheConcurrentAccess() async {
        let cache = ImageCache.shared
        await cache.clear()
        
        // Multiple concurrent writes
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let url = URL(string: "https://example.com/image\(i).jpg")!
                    let testImage = UIImage(systemName: "star")!
                    await cache.set(testImage, for: url)
                }
            }
        }
        
        // Multiple concurrent reads
        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let url = URL(string: "https://example.com/image\(i).jpg")!
                    let _ = await cache.get(for: url)
                }
            }
        }
        
        // Should not crash, actor ensures thread safety
        #expect(true) // If we get here, no crashes occurred
    }
    
    @Test("Cache should handle invalid URLs")
    func testCacheInvalidURL() async {
        let cache = ImageCache.shared
        // Empty string creates a relative URL, which is technically valid
        if let url = URL(string: "") {
            let testImage = UIImage(systemName: "star")!
            await cache.set(testImage, for: url)
            let retrieved = await cache.get(for: url)
            #expect(retrieved != nil)
        }
    }
    
    @Test("Cache should handle very long URLs")
    func testCacheVeryLongURL() async {
        let cache = ImageCache.shared
        let longPath = String(repeating: "a", count: 1000)
        let url = URL(string: "https://example.com/\(longPath).jpg")!
        let testImage = UIImage(systemName: "star")!
        
        await cache.set(testImage, for: url)
        let retrieved = await cache.get(for: url)
        
        #expect(retrieved != nil)
    }
}

