//
//  RealmWorker.swift
//  SpendingLogger
//
//  Created by Caroline on 2/28/19.
//  Copyright © 2019 Caroline. All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseCrashlytics

protocol RealmWorkerDelegate: class { }

class RealmWorker {
  var realm: Realm!
  var logNotificationToken: NotificationToken?
  var categoryNotificationToken: NotificationToken?
  var monthlyBudgetNotificationToken: NotificationToken?
  
  // MARK: Object lifecycle
  
  static let shared = RealmWorker()
  
  private init() {}
  
  deinit {
    logNotificationToken?.invalidate()
    monthlyBudgetNotificationToken?.invalidate()
  }
  
  // MARK: Setup
  
  func setupRealm() {
    configure()
//        clear()
    createInitialData()
//    createLogs()
    observeLogs()
    observeCategories()
  }
  
  // MARK: Private
  static private let currentSchema: UInt64 = 1
  private func configure() {
    var config = Realm.Configuration(
      schemaVersion: RealmWorker.currentSchema,
      migrationBlock: { migration, oldSchemaVersion in
        if oldSchemaVersion < RealmWorker.currentSchema {
          // Apply any necessary migration logic here.
        }
    })
    config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("ledgr.realm")
    realm = try! Realm(configuration: config)
  }
  
  
  private func clear() {
    try! realm.write {
      realm.deleteAll()
    }
  }

  private func createInitialData() {
    let key = "PopulatedInitialCategories"
    if !UserDefaults.standard.bool(forKey: key) {
      let gas = RealmCategory()
      gas.name = "Gas"
      gas.iconName = "gas"
      gas.hexColor = "#8e8c6d"
      let utilities = RealmCategory()
      utilities.name = "Utilities"
      utilities.iconName = "utilities"
      utilities.hexColor = "#7c9fb0"
      let medical = RealmCategory()
      medical.name = "Medical"
      medical.iconName = "doctor"
      medical.hexColor = "#f19670"
      let clothes = RealmCategory()
      clothes.name = "Clothing"
      clothes.iconName = "shirt"
      clothes.hexColor = "#5698c4"
      let takeout = RealmCategory()
      takeout.name = "Takeout"
      takeout.iconName = "hamburger"
      takeout.hexColor = "#9163b6"
      let groceries = RealmCategory()
      groceries.name = "Grocery"
      groceries.hexColor = "#74c493"
      groceries.iconName = "grocery"
      let housing = RealmCategory()
      housing.name = "Housing"
      housing.hexColor = "#e4bf80"
      housing.iconName = "house"
      let debt = RealmCategory()
      debt.name = "Debt"
      debt.hexColor = "#c94a53"
      debt.iconName = "debt"
      try! realm.write {
        realm.add(housing)
        realm.add(groceries)
        realm.add(utilities)
        realm.add(medical)
        realm.add(gas)
        realm.add(debt)
        realm.add(takeout)
        realm.add(clothes)
      }
      UserDefaults.standard.set(true, forKey: key)
    }
  }
  
  private func createLogs() {
    let l = RealmLog()
    l.title = "HEB"
    try! realm.write {
      realm.add(l)
    }
  }
  
  private func observeLogs() {
    let results = realm.objects(RealmLog.self)
    logNotificationToken = results.observe { (changes: RealmCollectionChange) in
      switch changes {
      case .initial: break
      case .update(_, let deletions, let insertions, let modifications):
        if deletions.count > 0 {
          DataObserver.shared.logDeleted()
        }
        if insertions.count > 0 {
          DataObserver.shared.logAdded()
        }
        if modifications.count > 0 {
          DataObserver.shared.logsHaveUpdated()
        }
      case .error(_):
        Crashlytics.crashlytics().record(error: NSError(domain: "ledgr.observeLog", code: 1, userInfo: nil))
      }
    }
  }
  
  private func observeCategories() {
    let results = realm.objects(RealmCategory.self).sorted(byKeyPath: "createdDate", ascending: false)
    categoryNotificationToken = results.observe { (changes: RealmCollectionChange) in
      switch changes {
      case .initial: break
      case .update(_, let deletions, let insertions, let modifications):
        if deletions.count > 0 {
          DataObserver.shared.categoryDeleted()
        }
        if insertions.count > 0 {
          let addition = self.realm.objects(RealmCategory.self).sorted(byKeyPath: "createdDate", ascending: true).last
          DataObserver.shared.categoryAdded(realmCategory: addition)
        }
        if modifications.count > 0 {
          DataObserver.shared.categoryUpdated()
        }
      case .error(_):
        Crashlytics.crashlytics().record(error: NSError(domain: "ledgr.ObserveCategory", code: 1, userInfo: nil))
      }
    }
  }
}
