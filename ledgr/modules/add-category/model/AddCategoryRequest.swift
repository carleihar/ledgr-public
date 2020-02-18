//
//  AddCategoryRequest.swift
//  ledgr
//
//  Created by Caroline on 2/16/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

struct AddCategoryRequest {
  var budget: String? = nil
  var budgetTimeRange: BudgetTimeRangeMenu = .month
  var name: String? = nil
  var iconName: String
  var hexColor: String
  
  init(budget: String? = nil, budgetTimeRange: BudgetTimeRangeMenu = .month, name: String?, iconName: String, hexColor: String) {
    self.budget = budget
    self.budgetTimeRange = budgetTimeRange
    self.name = name
    self.iconName = iconName
    self.hexColor = hexColor
  }
}
