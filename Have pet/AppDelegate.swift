//
//  AppDelegate.swift
//  Have pet

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let ownerTableViewController = OwnerTableViewController()
        let navController = UINavigationController(rootViewController: ownerTableViewController)
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        return true
    }

}
