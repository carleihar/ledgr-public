//
//  TotalCalculator.swift
//  ledgr
//
//  Created by Caroline on 12/30/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation

class TotalCalculator {
  func calculate(category: Category?, logs: [Log]) -> Float {
    return logs.reduce(0) {
    (accumulation: Float, nextValue: Log) -> Float in
      if nextValue.includeInTotals {
        if let cat = category {
          if nextValue.categories.contains(where: { (c) -> Bool in
            c.objectId == cat.objectId
          }) { return accumulation + nextValue.total }
        } else {
          return accumulation + nextValue.total
        }
      }
      return accumulation
    }
  }
  
  func calculateUncategorized(logs: [Log]) -> Float {
    return logs.reduce(0) {
    (accumulation: Float, nextValue: Log) -> Float in
      if nextValue.includeInTotals {
        if nextValue.categories.count == 0 {
          return accumulation + nextValue.total
        }
      }
      return accumulation
    }
  }
}
