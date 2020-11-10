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
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithTransparentBackground()
        navAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        navAppearance.backgroundColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        navAppearance.backgroundImage = UIImage()
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        tabBarAppearance.backgroundColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        tabBarAppearance.backgroundImage = UIImage()
        let barAppearance = UIBarAppearance()
        barAppearance.configureWithTransparentBackground()
        barAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        barAppearance.backgroundColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        barAppearance.backgroundImage = UIImage()
        let toolBarAppearance = UIToolbarAppearance()
        toolBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        toolBarAppearance.configureWithTransparentBackground()
        toolBarAppearance.backgroundColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        toolBarAppearance.backgroundImage = UIImage()
        let searchBarAppearance = UISearchBar.appearance()
        searchBarAppearance.barTintColor = UIColor.backgroundColor?.withAlphaComponent(0.4)
        searchBarAppearance.backgroundImage = UIImage()
        searchBarAppearance.searchBarStyle = .minimal
        searchBarAppearance.backgroundColor = .clear
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

