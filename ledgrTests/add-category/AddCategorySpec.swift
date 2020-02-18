//
//  AddCategorySpec.swift
//  ledgrTests
//
//  Created by Caroline on 2/16/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import ledgr

class AddCategorySpec: QuickSpec {
  override func spec() {
    describe("AddCategoryPresenter") {
      var presenter: AddCategoryPresenter!
      let delegate = MockAddCategoryPresenterDelegate()
      
      beforeEach {
        delegate.finishedCreatingCategoryCalled = nil
        delegate.errorMessage = nil
        presenter = AddCategoryPresenter()
        presenter.delegate = delegate
      }
      
      it("calls the delegate if the creation was successful") {
        presenter.createdNewCategory(error: nil)
        expect(delegate.finishedCreatingCategoryCalled).to(beTrue())
      }
      
      it("calls the delegate with a title error if the creation was unsuccessful") {
        presenter.createdNewCategory(error: AddCategoryError.noTitle)
        expect(delegate.errorMessage).to(equal("You didn't put in a category name you silly!"))
      }
    }
  }
}

class MockAddCategoryPresenterDelegate: AddCategoryPresenterDelegate {
  var errorMessage: String? = nil
  var finishedCreatingCategoryCalled: Bool? = nil
  
  func errorCreatingCategory(errorMessage: String) {
    self.errorMessage = errorMessage
  }
  
  func finishedCreatingCategory() {
    self.finishedCreatingCategoryCalled = true
  }
}
