//
//  RequestLogsUseCase.swift
//  ledgr
//
//  Created by Caroline on 11/14/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import RealmSwift

protocol RequestLogsUseCaseProtocol {
  func execute(date: Date, categoryId: String?)
}

class RequestLogsUseCase: RequestLogsUseCaseProtocol {
  var presenter: RequestLogsPresenterProtocol
  private var logs: [Log]?
  private var calendar = Calendar.current
  private var startDate: Date?
  private var categoryId: String? = nil
  
  init(presenter: RequestLogsPresenterProtocol) {
    self.presenter = presenter
  }
  
  func execute(date: Date, categoryId: String?) {
    startDate = date
    self.categoryId = categoryId
    refreshLogs()
  }
  
  private func refreshLogs() {
    let searchStartDate = calendar.date(byAdding: .day, value: -14, to: startDate ?? Date())!
    logs = LogWorker().fetchLogs(startDate: searchStartDate, endDate: Date(), padCount: true, categoryId: categoryId)
    presenter.presentLogsInDateOrder(logs: logs)
  }
}

