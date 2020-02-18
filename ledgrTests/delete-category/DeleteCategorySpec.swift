//
//  DeleteCategorySpec.swift
//  ledgrTests
//
//  Created by Caroline on 2/15/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import ledgr

class DeleteCategorySpec: QuickSpec {
  override func spec() {
    describe("DeleteCategoryUseCase") {
      let presenter = MockDeleteCategoryPresenter()
      var useCase: DeleteCategoryUseCase!
      let worker = MockCategoryWorker()
      let displayCategory = DisplayCategory(categoryId: "add_new", title: "", hexColor: "FFFFFF", iconName: "plus", selected: false, alwaysDisplayBorder: true)
      
      beforeEach {
        worker.returnError = nil
        useCase = DeleteCategoryUseCase(presenter: presenter, worker: worker)
      }
      
      it("calls the presenter after deleting category with no error") {
        useCase.execute(displayCategory: displayCategory)
        expect(presenter.deleteCategoryCalled).to(beTrue())
        expect(presenter.deletedCategoryError).to(beNil())
      }
      
      it("calls the presenter after deleting category and sends error") {
        worker.returnError = DeleteLogError.generic
        
        useCase.execute(displayCategory: displayCategory)
        expect(presenter.deleteCategoryCalled).to(beTrue())
        expect(presenter.deletedCategoryError).toNot(beNil())
      }
    }
    
    describe("DeleteCategoryPresenter") {
      var presenter: DeleteCategoryPresenter!
      let delegate = MockDeleteCategoryPresenterDelegate()
      
      beforeEach {
        presenter = DeleteCategoryPresenter()
        presenter.delegate = delegate
      }
      
      it("calls the delegate if deletion was successful") {
        presenter.deletedCategory(error: nil)
        expect(delegate.succesfullyDeletedCategoryCalled).to(beTrue())
        expect(delegate.categoryDeletionErrorMessage).to(beNil())
      }
      
      it("calls the delegate with an error if deletion was unsuccessful") {
        presenter.deletedCategory(error: DeleteLogError.generic)
        expect(delegate.succesfullyDeletedCategoryCalled).to(beTrue())
        expect(delegate.categoryDeletionErrorMessage).to(equal(LedgrErrorHelper.createGenericErrorMessage()))
      }
    }
  }
}

class MockDeleteCategoryPresenter: DeleteCategoryPresenterProtocol {
  var deleteCategoryCalled = false
  var deletedCategoryError: Error? = nil
  
  func deletedCategory(error: Error?) {
    deleteCategoryCalled = true
    deletedCategoryError = error
  }
}

class MockDeleteCategoryPresenterDelegate: DeleteCategoryPresenterDelegate {
  var succesfullyDeletedCategoryCalled: Bool? = nil
  var categoryDeletionErrorMessage: String? = nil
  
  func succesfullyDeletedCategory() {
    succesfullyDeletedCategoryCalled = true
  }
  
  func categoryDeletion(errorMessage: String) {
    categoryDeletionErrorMessage = errorMessage
  }
}
