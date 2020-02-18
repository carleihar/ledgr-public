//
//  AddEditCategoryViewControllerFactory.swift
//  ledgr
//
//  Created by Caroline on 2/18/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import UIKit

class AddEditCategoryViewControllerFactory {
  func createAddCategory(editing: DisplayCategory? = nil) -> AddEditCategoryViewController {
    let presenter = AddCategoryPresenter()
    let useCase = AddCategoryUseCase(presenter: presenter, editingCategory: editing)
    
    let controller = AddEditCategoryViewController(useCase: useCase)
    presenter.delegate = controller
    
    return controller
  }
  
  func createAddCategoryFromTotal(editing: DisplayTotal? = nil) -> AddEditCategoryViewController {
    let presenter = AddCategoryPresenter()
    let useCase = AddCategoryUseCase(presenter: presenter, editingCategory: editing)
    
    let controller = AddEditCategoryViewController(useCase: useCase)
    presenter.delegate = controller
    
    return controller
  }
}
