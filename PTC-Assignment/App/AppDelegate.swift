//
//  AppDelegate.swift
//  PTC-Assignment
//
//  Created by Thien Huynh on 3/19/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = ActivitiesListVC.initFromStoryboard()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.navigationBar.barTintColor = UIColor(named: "Background")
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

