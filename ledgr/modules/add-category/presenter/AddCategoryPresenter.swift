//
//  AddCategoryPresenter.swift
//  ledgr
//
//  Created by Caroline on 2/16/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

protocol AddCategoryPresenterDelegate: class {
  func errorCreatingCategory(errorMessage: String)
  func finishedCreatingCategory()
}

protocol AddCategoryPresenterProtocol {
  func createdNewCategory(error: AddCategoryError?)
}

class AddCategoryPresenter: AddCategoryPresenterProtocol {
  weak var delegate: AddCategoryPresenterDelegate?
  
  func createdNewCategory(error: AddCategoryError?) {
    if error == nil {
      delegate?.finishedCreatingCategory()
      return
    }
    
    var errorString = LedgrErrorHelper.createGenericErrorMessage()
    switch error {
    case .noTitle:
        errorString = "You didn't put in a category name you silly!"
    default: break
    }
    delegate?.errorCreatingCategory(errorMessage: errorString)
  }
}
