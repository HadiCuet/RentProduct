//
//  AppDelegate.swift
//  RentProduct
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let initDataManager = InitDataManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        initDataManager.setInitData()

        return true
    }
}

