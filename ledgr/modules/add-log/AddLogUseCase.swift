//
//  AddLogUseCase.swift
//  ledgr
//
//  Created by Caroline on 12/8/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation

class DisplayCategory {
  var categoryId: String = ""
  var title: String = ""
  var hexColor: String = ""
  var iconName: String = ""
  var selected: Bool = false
  var alwaysDisplayBorder: Bool = false
  
  init(categoryId: String, title: String, hexColor: String, iconName: String, selected: Bool, alwaysDisplayBorder: Bool = false) {
    self.categoryId = categoryId
    self.title = title
    self.hexColor = hexColor
    self.iconName = iconName
    self.selected = selected
    self.alwaysDisplayBorder = alwaysDisplayBorder
  }
}

class AddLogRequest {
  var amount: String? = nil
  var categoryId: String? = nil
  var title: String? = nil
  var extraNotes: String? = nil
  
  init(amount: String?, title: String?, categoryId: String?, extraNotes: String?) {
    self.amount = amount
    self.categoryId = categoryId
    self.title = title
    self.categoryId = categoryId
    self.extraNotes = extraNotes
  }
}

struct RequestCategoriesViewModel {
  var categories: [DisplayCategory]
  var categoryLabelTitle: String
}

protocol AddLogUseCaseProtocol {
  var editingLog: DisplayLog? { get set }
  func execute(request: AddLogRequest)
}

class AddLogUseCase: AddLogUseCaseProtocol {
  var editingLog: DisplayLog?
  private var date: Date
  private var presenter: AddLogPresenterProtocol
  
  init(presenter: AddLogPresenterProtocol, date: Date = Date(), editingLog: DisplayLog? = nil) {
    self.presenter = presenter
    self.date = date
    self.editingLog = editingLog
  }
  
  func execute(request: AddLogRequest) {
    upsertLog(request: request)
  }
  
  private func upsertLog(request: AddLogRequest) {
    guard request.amount != nil else {
      presenter.createdNewLog(error: AddLogError.noAmount)
      return
    }
    let worker = AddLogWorker()
    let log = LogWorker().fetchLogFor(displayLog: editingLog) ?? Log()
    log.total = worker.parseToAmount(text: request.amount)
    log.title = worker.parseTitle(text: request.title)
    log.extraNotes = worker.parseExtraNotes(text: request.extraNotes)
    log.dateString = DateFormatters.shortDateFormatter.string(from: date)
    if editingLog == nil {
      log.date = DateFormatters.shortDateFormatter.date(from: log.dateString) ?? Date()
    }
    
    var selectedCategory: Category? = nil
    if let categoryId = request.categoryId {
      selectedCategory = CategoryWorker().categoryFor(categoryId: categoryId)
      if let cat = selectedCategory {
        log.categories = [cat]
      }
    }
    
    LogWorker().saveLog(log: log) { (err) in
      var error: AddLogError? = nil
      if err != nil {
        error = AddLogError.noSave
      }
      self.presenter.createdNewLog(error: error)
    }
  }
}

enum AddLogError: Error {
  case noAmount
  case noSave
}
