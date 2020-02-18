//
//  MonthlyBudget.swift
//  SpendingLogger
//
//  Created by Caroline on 3/2/19.
//  Copyright © 2019 Caroline. All rights reserved.
//

import Foundation
import RealmSwift

class MonthlyBudget: Object {
  @objc dynamic var monthlyBudget: Float = 0
  @objc dynamic var dailyBudget: Float = 0
  @objc dynamic var dateId: String = ""

  convenience init(date: Date) {
    self.init()
    dateId = DateFormatters.shortDateFormatter.string(from: date)
  }
  
  func getDate() -> Date? {
    return DateFormatters.shortDateFormatter.date(from: dateId)
  }
  
  override static func primaryKey() -> String? {
    return "dateId"
  }
}
