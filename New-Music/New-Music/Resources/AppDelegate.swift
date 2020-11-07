//
//  AppDelegate.swift
//  New-Music
//
//  Created by Michael McGrath on 10/3/20.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UINavigationBarAppearance().configureWithTransparentBackground()
        UINavigationBarAppearance().backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UINavigationBarAppearance().backgroundColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        UINavigationBarAppearance().backgroundImage = UIImage()
        UITabBarAppearance().configureWithTransparentBackground()
        UITabBarAppearance().backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UITabBarAppearance().backgroundColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        UITabBarAppearance().backgroundImage = UIImage()
        UIBarAppearance().configureWithTransparentBackground()
        UIBarAppearance().backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        UIBarAppearance().backgroundColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        UIBarAppearance().backgroundImage = UIImage()
        UISearchBar.appearance().barTintColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        UISearchBar.appearance().backgroundImage = UIImage()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

