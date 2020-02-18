//
//  DisplayTotal.swift
//  ledgr
//
//  Created by Caroline on 2/18/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

class DisplayTotal {
  let categoryId: String?
  let imageName: String
  let totalString: String
  let barPercentage: Float
  let title: String
  let count: String
  let backgroundColorHex: String
  
  init(categoryId: String?, imageName: String, totalString: String, barPercentage: Float, title: String, count: String, backgroundColorHex: String) {
    self.categoryId = categoryId
    self.imageName = imageName
    self.totalString = totalString
    self.barPercentage = barPercentage
    self.title = title
    self.count = count
    self.backgroundColorHex = backgroundColorHex
  }
}
