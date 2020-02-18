//
//  AppDelegate.swift
//  ledgr
//
//  Created by Caroline on 11/12/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import UIKit
import Firebase

//https://freeicons.io/style/Outline

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    Analytics.setAnalyticsCollectionEnabled(false)
    setupDefaultAppearance()
    RealmWorker.shared.setupRealm()
    return true
  }
  
  private func setupDefaultAppearance() {
    UIApplication.shared.windows.forEach { window in
      window.overrideUserInterfaceStyle = .light
    }
    UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
    UINavigationBar.appearance().shadowImage = UIImage()
    UINavigationBar.appearance().backgroundColor = .clear
    UINavigationBar.appearance().isTranslucent = true
    UINavigationBar.appearance().tintColor = .black
    UIBarButtonItem.appearance().setTitleTextAttributes(
      [NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
  }
}
