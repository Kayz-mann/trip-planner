//
//  AppDelegate.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import UIKit
import CoreHaptics

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Validate API base URL early to avoid silent DNS errors later.
        let base = APIConfiguration.baseURL
        if let url = URL(string: base), url.scheme == "https", url.host?.hasSuffix(".beeceptor.com") == true {
            // OK
        } else {
            assertionFailure("APIConfiguration.baseURL is invalid: \(base). It must be an https Beeceptor URL like https://my-endpoint.beeceptor.com/api/trips")
        }
        
        // Optional: Silence Simulator haptics noise by checking support before any haptic usage.
        // Your app doesn’t explicitly use haptics, but system UI in Simulator logs missing pattern files.
        let supportsHaptics = CHHapticEngine.capabilitiesForHardware().supportsHaptics
        if !supportsHaptics {
            // No-op: This just documents the environment; avoid adding any haptic triggers on unsupported hardware.
            // You can also add a debug log if desired.
            // print("Haptics not supported on this device (likely Simulator).")
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}

