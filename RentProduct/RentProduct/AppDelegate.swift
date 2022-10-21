//
//  AppDelegate.swift
//  RentProduct
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let initDataManager = InitDataManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        initDataManager.setInitData()
        return true
    }
}

