//
//  DeleteCategoryPresenter.swift
//  ledgr
//
//  Created by Caroline on 2/15/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

protocol DeleteCategoryPresenterProtocol {
  func deletedCategory(error: Error?)
}

protocol DeleteCategoryPresenterDelegate: class {
  func succesfullyDeletedCategory()
  func categoryDeletion(errorMessage: String)
}

class DeleteCategoryPresenter: DeleteCategoryPresenterProtocol {
  weak var delegate: DeleteCategoryPresenterDelegate?
  
  func deletedCategory(error: Error?) {
    if error == nil {
      delegate?.succesfullyDeletedCategory()
    } else {
      Crashlytics.crashlytics().record(error: NSError(domain: "ledgr.DeleteCategory", code: 1, userInfo: nil))
      delegate?.categoryDeletion(errorMessage: LedgrErrorHelper.createGenericErrorMessage())
    }
  }
}
