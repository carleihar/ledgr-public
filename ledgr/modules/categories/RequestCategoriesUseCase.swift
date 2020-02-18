//
//  RequestCategoriesUseCase.swift
//  ledgr
//
//  Created by Caroline on 12/8/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation

protocol RequestCategoriesUseCaseProtocol {
  func execute()
}

extension RequestCategoriesUseCaseProtocol {
  func execute(displayLog: DisplayLog? = nil) {
    execute()
  }
}

class RequestCategoriesUseCase: RequestCategoriesUseCaseProtocol {
  var presenter: RequestCategoriesPresenterProtocol
  private var displayLog: DisplayLog?
  
  init(presenter: RequestCategoriesPresenterProtocol, displayLog: DisplayLog?) {
    self.displayLog = displayLog
    self.presenter = presenter
  }
  
  func execute() {
    let categories = CategoryWorker().fetchCategories()
    let selectedCategoryIds = fetchSelectedCategoryIds(displayLog: displayLog)
    presenter.didFetch(categories: Array(categories), selectedCategoryIds: selectedCategoryIds)
  }
  
  private func fetchSelectedCategoryIds(displayLog: DisplayLog?) -> [String] {
    let log = LogWorker().fetchLogFor(displayLog: displayLog)
    return log?.categories.map({ (cat) -> String in
      return cat.objectId
    }) ?? []
  }
}
