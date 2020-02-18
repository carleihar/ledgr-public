//
//  Log.swift
//  SpendingLogger
//
//  Created by Caroline on 2/28/19.
//  Copyright © 2019 Caroline. All rights reserved.
//

import Foundation
import RealmSwift

class Log: Observable {
  var total: Float = 0
  var title: String? = nil
  var extraNotes: String? = nil
  var objectId: String = UUID().uuidString
  var dateString: String = ""
  var date: Date = Date()
  var includeInTotals: Bool = true
  var categories: [Category] = []
  var createdDate = Date()
}

class RealmLog: Object {
  @objc dynamic var total: Float = 0
  @objc dynamic var title: String? = nil
  @objc dynamic var extraNotes: String? = nil
  @objc dynamic var objectId: String = UUID().uuidString
  @objc dynamic var dateString: String = ""
  @objc dynamic var date: Date = Date()
  @objc dynamic var includeInTotals: Bool = true
  var categories = List<RealmCategory>()
  dynamic var createdDate = Date()
  
  override static func primaryKey() -> String? {
    return "objectId"
  }
  
  func toLog() -> Log {
    let log = Log()
    log.total = total
    log.title = title
    log.extraNotes = extraNotes
    log.objectId = objectId
    log.dateString = dateString
    log.date = date
    log.includeInTotals = includeInTotals
    log.categories = categories.map { (cat) -> Category in
      return cat.toCategory()
    }
    log.createdDate = createdDate
    return log
  }
  
  static func toRealmLog(_ log: Log) -> RealmLog {
    let realmLog = RealmLog()
    realmLog.total = log.total
    realmLog.title = log.title
    realmLog.extraNotes = log.extraNotes
    realmLog.objectId = log.objectId
    realmLog.dateString = log.dateString
    realmLog.date = log.date
    realmLog.includeInTotals = log.includeInTotals
    let realmList = List<RealmCategory>()
    log.categories.forEach {
      realmList.append(RealmCategory.toRealmCategory($0))
    }
    realmLog.categories = realmList
    realmLog.createdDate = log.createdDate
    return realmLog
  }
}
