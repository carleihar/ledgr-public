//
//  AddLogWorker.swift
//  ledgr
//
//  Created by Caroline on 12/20/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import UIKit
import RealmSwift

class AddLogWorker {
  func saveSelectedCategories(log: Log, categories: [Category]?, displayCategories: [DisplayCategory]) {
    log.categories.removeAll()
    let selectedCategoryIds: [String] = displayCategories.filter {
        $0.selected
      }.map {
        $0.categoryId
    }
    if let cats = categories {
      Array(cats).forEach {
        if selectedCategoryIds.contains($0.objectId) {
          log.categories.append($0)
        }
      }
    }
  }
  
  func parseToAmount(text: String?) -> Float {
    return Parsers.parseToNumber(string: text)
  }
  
  func parseTitle(text: String?) -> String? {
    return text.isBlank ? nil : text?.trimmingCharacters(in: .whitespacesAndNewlines)
  }
  
  func parseExtraNotes(text: String?) -> String? {
    return text.isBlank ? nil : text
  }
}

class AddCategoryWorker {
  func parseName(text: String?) -> String? {
    guard text != nil else { return nil }
    return text.isBlank ? nil : text?.trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
