//
//  RequestCategoriesPresenter.swift
//  ledgr
//
//  Created by Caroline on 12/18/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation

protocol RequestCategoriesPresenterProtocol {
  func didFetch(categories: [Category], selectedCategoryIds: [String])
}

protocol RequestCategoriesPresenterDelegate: class {
  func display(categoryViewModel: RequestCategoriesViewModel)
}

class RequestCategoriesPresenter: RequestCategoriesPresenterProtocol {
  
  weak var delegate: RequestCategoriesPresenterDelegate?
  
  func didFetch(categories: [Category], selectedCategoryIds: [String]) {
    var displayCategories: [DisplayCategory] = []
    var title = "Uncategorized"
    displayCategories = categories.map { (category) -> DisplayCategory in
      let selected = selectedCategoryIds.contains(category.objectId)
      if selected {
        title = category.name
      }
      let display = DisplayCategory(categoryId: category.objectId, title: category.name, hexColor: category.hexColor, iconName: category.iconName, selected: selected)
      return display
    }
    displayCategories = displayCategories.sorted(by: {
      return $0.title < $1.title
    })
    let display = DisplayCategory(categoryId: "add_new", title: "", hexColor: "FFFFFF", iconName: "plus", selected: false, alwaysDisplayBorder: true)
    displayCategories.append(display)
    delegate?.display(categoryViewModel: RequestCategoriesViewModel(categories: displayCategories, categoryLabelTitle: title))
  }
}
