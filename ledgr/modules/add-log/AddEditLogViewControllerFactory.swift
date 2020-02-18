//
//  AddEntityViewControllerFactory.swift
//  ledgr
//
//  Created by Caroline on 1/7/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

class AddEditLogViewControllerFactory {
  func createAddEditLog(editing: DisplayLog? = nil, date: Date = Date()) -> AddEditLogViewController {
    let presenter = AddLogPresenter()
    let useCase = AddLogUseCase(presenter: presenter, date: date, editingLog: editing)
    let controller = AddEditLogViewController(useCase: useCase)
    presenter.delegate = controller
    return controller
  }
}
