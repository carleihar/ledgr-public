//
//  DeleteLogPresenter.swift
//  ledgr
//
//  Created by Caroline on 2/18/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

protocol DeleteLogPresenterProtocol {
  func deletedLog(indexPath: IndexPath?, error: Error?)
}

protocol DeleteLogPresenterDelegate: class {
  func deletedLogAt(indexPath: IndexPath)
  func errorDeletingLog(message: String)
}

class DeleteLogPresenter: DeleteLogPresenterProtocol {
  weak var delegate: DeleteLogPresenterDelegate?
  
  func deletedLog(indexPath: IndexPath?, error: Error?) {
    if let ip = indexPath {
      delegate?.deletedLogAt(indexPath: ip)
    } else if let e = error {
      Crashlytics.crashlytics().record(error: NSError(domain: "ledgr.DeleteLogError", code: 1, userInfo: nil))
      self.deleteLog(error: e)
    } else {
      Crashlytics.crashlytics().record(error: NSError(domain: "ledgr.DeleteLogError", code: 2, userInfo: nil))
      deleteLog(error: DeleteLogError.generic)
    }
  }
  
  private func deleteLog(error: Error) {
    delegate?.errorDeletingLog(message: "Ruh-roh. We messed up. Try again or send us an angry review and we'll try to get to the bottom of it.")
  }
}
