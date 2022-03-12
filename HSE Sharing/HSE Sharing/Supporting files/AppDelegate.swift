//
//  AppDelegate.swift
//  HSE Sharing
//
//  Created by Екатерина on 23.02.2022.
//

import UIKit

@main
final class AppDelegate: UIResponder {
    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
}

extension AppDelegate: UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window?.rootViewController = RootTabBarViewController()
       
        
        window?.makeKeyAndVisible()
        
        return true
    }
}


