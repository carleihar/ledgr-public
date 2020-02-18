//
//  DeleteLogUseCase.swift
//  ledgr
//
//  Created by Caroline on 12/20/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

protocol DeleteLogUseCaseProtocol {
  func execute(displaySections: [DisplaySection], indexPath: IndexPath?)
}

class DeleteLogUseCase: DeleteLogUseCaseProtocol {
  var presenter: DeleteLogPresenterProtocol
  
  init(presenter: DeleteLogPresenterProtocol) {
    self.presenter = presenter
  }
  
  func execute(displaySections: [DisplaySection], indexPath: IndexPath?) {
    if let indexPath = indexPath {
      let section = displaySections[indexPath.section]
      let log = section.logs[indexPath.row]
      deleteLog(displayLog: log, indexPath: indexPath)
    } else {
      presenter.deletedLog(indexPath: nil, error: DeleteLogError.generic)
    }
  }
  
  private func deleteLog(displayLog: DisplayLog, indexPath: IndexPath) {
    LogWorker().delete(displayLog: displayLog) { (err) in
      self.presenter.deletedLog(indexPath: indexPath, error: err)
    }
  }
}

enum DeleteLogError: Error {
  case generic
}
