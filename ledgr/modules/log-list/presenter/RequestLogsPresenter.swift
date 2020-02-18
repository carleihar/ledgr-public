//
//  RequestLogsPresenter.swift
//  ledgr
//
//  Created by Caroline on 11/14/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import RealmSwift
import FirebaseCrashlytics

struct DisplaySection {
  var sectionTitle: String
  var dateString: String
  var logs: [DisplayLog]
  var date: Date
}

class DisplayLog {
  var objectId: String
  var total: String
  var title: String?
  var expanded: Bool = false
  var extraNotes: String?
  var categoryColorHex: String?
  var categoryText: String?
  
  init(objectId: String, total: String, title: String?, expanded: Bool = false, extraNotes: String?, categoryColorHex: String?, categoryText: String?) {
    self.objectId = objectId
    self.total = total
    self.title = title
    self.expanded = expanded
    self.extraNotes = extraNotes
    self.categoryColorHex = categoryColorHex
    self.categoryText = categoryText
  }
}

protocol RequestLogsPresenterProtocol: class {
  func presentLogsInDateOrder(logs: [Log]?)}

protocol RequestLogsDelegate: class {
  func displayLogs(displayLogs: [DisplaySection])
  func displayLogs(errorMessage: String)
}

class RequestLogsPresenter: RequestLogsPresenterProtocol {
  weak var delegate: RequestLogsDelegate?
  
  func presentLogsInDateOrder(logs: [Log]?) {
    if let logs = logs {
      var sections: [DisplaySection] = []
      for i in 0..<logs.count {
        let log = logs[i]
        let display = DisplayLog(objectId: log.objectId, total: Formatters.currencyFormatter.string(from: NSNumber(value: log.total)) ?? "", title: log.title, expanded: false, extraNotes: log.extraNotes, categoryColorHex: log.categories.first?.hexColor, categoryText: log.categories.first?.name)
        if let last = sections.last, last.dateString == log.dateString {
          sections[sections.count - 1].logs.append(display)
        } else {
          sections.append(DisplaySection(sectionTitle: DateFormatters.prettyDateFormatter.string(from: log.date), dateString: log.dateString, logs: [display], date: log.date))
        }
      }
      delegate?.displayLogs(displayLogs: sections)
    } else {
      Crashlytics.crashlytics().record(error: NSError(domain: "ledgr.RequestLogsError", code: 1, userInfo: nil))
      delegate?.displayLogs(errorMessage: LedgrErrorHelper.createGenericErrorMessage())
    }
  }
}
