//
//  LogWorker.swift
//  ledgr
//
//  Created by Caroline on 12/24/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import Realm

class LogWorker {
  static let padCountNumber = 30
  // If the number of logs between the dates are less than
  // padCountNumber, it will try return at least padCountNumber, ignoring
  // the end date
  func fetchLogs(startDate: Date, endDate: Date, padCount: Bool = false, categoryId: String? = nil) -> [Log] {
    var logs = RealmWorker.shared.realm.objects(RealmLog.self)
      .filter("date <= %@", endDate)
      .filter("date >= %@", startDate)
      .sorted(byKeyPath: "date", ascending: false)
    var shouldPadCount = false
    if logs.count < LogWorker.padCountNumber && padCount == true {
      logs = RealmWorker.shared.realm.objects(RealmLog.self)
        .filter("date <= %@", endDate)
        .sorted(byKeyPath: "date", ascending: false)
      shouldPadCount = true
    }
    if let catId = categoryId {
      if catId == "uncategorized" {
        logs = logs.filter("categories.@count == 0")
      } else {
        logs = logs.filter("ANY categories.objectId = %@", catId)
      }
    }
    if shouldPadCount {
      var dataArray: [RealmLog] = []
      for i in 0 ..< min(LogWorker.padCountNumber, logs.count) {
        dataArray.append(logs[i])
      }
      return dataArray.map { $0.toLog() }
    }
    return logs.map { $0.toLog() }
  }
    
  func fetchLogFor(displayLog: DisplayLog?) -> Log? {
    guard let dl = displayLog else {
      return nil
    }
    return RealmWorker.shared.realm.object(ofType: RealmLog.self, forPrimaryKey: dl.objectId)?.toLog()
  }
  
  func saveLog(log: Log, completion: @escaping (Error?) -> Void) {
    try? RealmWorker.shared.realm.write {
      RealmWorker.shared.realm.create(RealmLog.self, value: RealmLog.toRealmLog(log), update: .modified)
      completion(nil)
    }
  }
  
  func delete(displayLog: DisplayLog, completion: @escaping (Error?) -> Void) {
    let log = RealmWorker.shared.realm.object(ofType: RealmLog.self, forPrimaryKey: displayLog.objectId)
    if let l = log {
      try? RealmWorker.shared.realm.write {
        RealmWorker.shared.realm.delete(l)
        completion(nil)
      }
    } else {
      completion(DeleteLogError.generic)
    }
  }
}
