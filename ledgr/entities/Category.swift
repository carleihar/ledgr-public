//
//  Category.swift
//  SpendingLogger
//
//  Created by Caroline on 3/7/19.
//  Copyright © 2019 Caroline. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Observable {
  var objectId: String = UUID().uuidString
  var hexColor: String = "#ffffff"
  var name: String = "No Name"
  var iconName: String = "No Name"
  var includeInTotals: Bool = true
  var createdDate = Date()
}

class RealmCategory: Object {
  @objc dynamic var objectId: String = UUID().uuidString
  @objc dynamic var hexColor: String = "#ffffff"
  @objc dynamic var name: String = "No Name"
  @objc dynamic var iconName: String = "No Name"
  @objc dynamic var includeInTotals: Bool = true
  @objc dynamic var createdDate = Date()
  
  override static func primaryKey() -> String? {
    return "objectId"
  }
  
  func toCategory() -> Category {
    // TODO: I don't believe Swift supports setting
    // using reflection, but I should look into this.
    // Even so, perhaps there is a way to safeguard adding
    // new values by throwing an exception for mismatching props?
    // or use a library like https://github.com/wickwirew/Runtime
    let category = Category()
    category.objectId = objectId
    category.hexColor = hexColor
    category.name = name
    category.iconName = iconName
    category.includeInTotals = includeInTotals
    category.createdDate = createdDate
    return category
  }
  
  static func toRealmCategory(_ category: Category) -> RealmCategory {
    let realmCategory = RealmCategory()
    realmCategory.objectId = category.objectId
    realmCategory.hexColor = category.hexColor
    realmCategory.name = category.name
    realmCategory.iconName = category.iconName
    realmCategory.includeInTotals = category.includeInTotals
    realmCategory.createdDate = category.createdDate
    return realmCategory
  }
}

let LedgrCategoriesImageNames: [String] = ["airplane", "apple", "cat", "coffee-takeout", "coffee", "dentist", "dog", "dollar-bill", "games", "gas", "grocery", "laundry", "restaurant", "shirt", "shoe", "shopping-bag", "takeout", "travel", "vacation", "workout", "yoga", "dessert", "store", "pacifier", "book", "trophy", "piggy-bank", "turkey", "cleaning", "party", "baby", "gift", "bike", "office", "takeout", "hamburger", "cosmetics", "music", "house", "graduation", "utilities", "art", "doctor", "subway", "martini", "relationship", "cheers", "fruit", "vehicle", "iphone", "phone", "wedding", "maitenence", "home-repair", "tools", "debt"]

let LedgrCategoryColors: [String] = ["#51574a", "#447c69", "#74c493", "#8e8c6d", "#e4bf80", "#e9d78e", "#e2975d", "#f19670", "#e16552", "#c94a53", "#be5168", "#a34974", "#993767", "#65387d", "#4e2472", "#9163b6", "#e279a3", "#e0598b", "#7c9fb0", "#5698c4", "#9abf88"].reversed()
