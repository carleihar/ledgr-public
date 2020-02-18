//
//  AddLogPresenter.swift
//  ledgr
//
//  Created by Caroline on 12/20/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation

protocol AddLogPresenterDelegate: class {
  func errorCreatingLog(errorMessage: String)
  func finishedCreatingLog()
}

protocol AddLogPresenterProtocol {
  func createdNewLog(error: AddLogError?)
}

class AddLogPresenter: AddLogPresenterProtocol {
  weak var delegate: AddLogPresenterDelegate?
  
  func createdNewLog(error: AddLogError?) {
    if error == nil {
      delegate?.finishedCreatingLog()
    } else {
      var errorString = "Something went wrong but I couldn't tell you what. Try again?"
      switch error {
      case .noAmount:
          errorString = "You didn't put in an amount you silly!"
      default: break
      }
      delegate?.errorCreatingLog(errorMessage: errorString)
    }
  }
}
