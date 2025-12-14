//
//  SceneDelegate.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        // Create the root view (HomeView as main screen)
        let rootView = RootNavigationView()
        let hostingController = UIHostingController(rootView: rootView)

        window?.rootViewController = hostingController
        window?.makeKeyAndVisible()
    }
}

