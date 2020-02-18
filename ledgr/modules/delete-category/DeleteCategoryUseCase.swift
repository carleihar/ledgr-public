//
//  DeleteCategoryUseCase.swift
//  ledgr
//
//  Created by Caroline on 1/25/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

protocol DeleteCategoryUseCaseProtocol {
  func execute(displayCategory: DisplayCategory)
}

class DeleteCategoryUseCase: DeleteCategoryUseCaseProtocol {
  var presenter: DeleteCategoryPresenterProtocol
  private var categoryWorker: CategoryWorkerProtocol
  
  init(presenter: DeleteCategoryPresenterProtocol, worker: CategoryWorkerProtocol = CategoryWorker()) {
    self.presenter = presenter
    self.categoryWorker = worker
  }
  
  func execute(displayCategory: DisplayCategory) {
    categoryWorker.delete(displayCategory: displayCategory) { (error) in
      self.presenter.deletedCategory(error: error)
    }
  }
}

enum DeleteCategoryError: Error {
  case generic
}
