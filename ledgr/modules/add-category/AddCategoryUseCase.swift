//
//  AddCategoryUseCase.swift
//  ledgr
//
//  Created by Caroline on 1/9/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

protocol AddCategoryUseCaseProtocol {
  var editingDisplayCategory: DisplayCategory? { get }
  func execute(request: AddCategoryRequest)
}

class AddCategoryUseCase: AddCategoryUseCaseProtocol {
  private(set) var editingDisplayCategory: DisplayCategory?
  private var editingCategory: Category?
  private var presenter: AddCategoryPresenterProtocol

  init(presenter: AddCategoryPresenterProtocol, editingCategory: DisplayCategory? = nil) {
    self.presenter = presenter
    self.editingDisplayCategory = editingCategory
    self.editingCategory = CategoryWorker().categoryFor(categoryId: editingCategory?.categoryId)
  }
  
  init(presenter: AddCategoryPresenterProtocol, editingCategory: DisplayTotal? = nil) {
    self.presenter = presenter
    
    if let editingCategory = CategoryWorker().categoryFor(categoryId: editingCategory?.categoryId) {
      self.editingCategory = editingCategory
      let display = DisplayCategory(categoryId: editingCategory.objectId, title: editingCategory.name, hexColor: editingCategory.hexColor, iconName: editingCategory.iconName, selected: false)
      self.editingDisplayCategory = display
    }
  }

  func execute(request: AddCategoryRequest) {
    let worker = AddCategoryWorker()
    guard let name = worker.parseName(text: request.name) else {
      presenter.createdNewCategory(error: .noTitle)
      return
    }
    let category = CategoryWorker().categoryFor(categoryId: editingCategory?.objectId) ?? Category()
    category.name = name
    category.hexColor = request.hexColor
    category.iconName = request.iconName
    CategoryWorker().save(category: category) { (error) in
      self.presenter.createdNewCategory(error: (error != nil ? .noSave : nil))
    }
  }
}

enum AddCategoryError: Error {
  case noTitle
  case noSave
}
