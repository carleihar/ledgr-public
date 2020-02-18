//
//  AddCategoryVisualPresenter.swift
//  ledgr
//
//  Created by Caroline on 2/18/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

typealias DisplayCategoryColor = (color: String, selected: Bool)

protocol AddCategoryVisualPresenterProtocol {
  func setup()
  func selected(color: String)
  func selected(category: DisplayCategory)
}

protocol AddCategoryVisualPresenterDelegate: class {
  func display(categories: [DisplayCategory], colors: [DisplayCategoryColor])
}

class AddCategoryVisualPresenter: AddCategoryVisualPresenterProtocol {
  weak var delegate: AddCategoryVisualPresenterDelegate?
  private(set) var selectedColor: String?
  private(set) var selectedIcon: String?
  
  func setup() {
    if self.selectedColor == nil {
      self.selectedColor = LedgrCategoryColors.randomElement()
    }
    
    var cats: [DisplayCategory] = []
    for name in LedgrCategoriesImageNames {
      let cat = DisplayCategory(categoryId: name, title: "", hexColor: (selectedIcon == name) ? (self.selectedColor ?? "#FFFFFF") : "#FFFFFF", iconName: name, selected: selectedIcon == name, alwaysDisplayBorder: true)
      cats.append(cat)
    }
    
    if selectedIcon == nil {
      let selectedCategory = cats.randomElement()
      selectedIcon = selectedCategory?.iconName
      selectedCategory?.selected = true
      selectedCategory?.hexColor = (self.selectedColor ?? "#FFFFFF")
    }
    
    var displayColors: [DisplayCategoryColor] = []
    for color in LedgrCategoryColors {
      let c: DisplayCategoryColor = (color, color == selectedColor)
      displayColors.append(c)
    }
    
    delegate?.display(categories: cats, colors: displayColors)
  }
  
  func selected(color: String) {
    self.selectedColor = color
    setup()
  }
  
  func selected(category: DisplayCategory) {
    selectedIcon = category.iconName
    setup()
  }
}
