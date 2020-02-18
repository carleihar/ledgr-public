//
//  CalculateTotalUseCase.swift
//  ledgr
//
//  Created by Caroline on 12/30/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation

enum BudgetTimeRangeMenu: String, CaseIterable {
   case day = "day"
   case week = "week"
   case month = "month"
   case year = "year"
 }

protocol CalculateTotalUseCaseProtocol {
  func execute(selection: BudgetTimeRangeMenu?)
}

class CalculateTotalUseCase: CalculateTotalUseCaseProtocol {
  var selection: BudgetTimeRangeMenu = .month
  var presenter: CalculateTotalPresenterProtocol
  
  init(presenter: CalculateTotalPresenterProtocol) {
    self.presenter = presenter
  }
  
  func execute(selection: BudgetTimeRangeMenu?) {
    var startDate = Date().dateFor(.startOfDay, calendar: Calendar.current)
    self.selection = selection ?? self.selection
    switch self.selection {
    case .day: break
    case .week:
      startDate = Date().dateFor(.startOfWeek, calendar: Calendar.current)
    case .month:
      startDate = Date().dateFor(.startOfMonth, calendar: Calendar.current)
    case .year:
      startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from:  Date().dateFor(.startOfDay, calendar: Calendar.current))) ?? Date()
    }
    let categories = CategoryWorker().fetchCategories()
    let logs = LogWorker().fetchLogs(startDate: startDate, endDate: Date())
    let calc = TotalCalculator()
    var totals: [(Category, Float)] = []
    for cat in categories {
      totals.append((cat, calc.calculate(category: cat, logs: logs)))
    }
    let uncategorized = calc.calculateUncategorized(logs: logs)
    presenter.calculated(totals: totals, uncategorized: uncategorized, segmentTotal: calc.calculate(category: nil, logs: logs))
  }
}
