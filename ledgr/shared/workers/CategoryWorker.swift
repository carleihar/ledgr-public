//
//  CategoryWorker.swift
//  ledgr
//
//  Created by Caroline on 12/24/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import Realm

protocol CategoryWorkerProtocol {
  func delete(displayCategory: DisplayCategory, completion: @escaping (Error?) -> Void)
}

class CategoryWorker: CategoryWorkerProtocol {
  func categoryFor(categoryId: String?) -> Category? {
    guard let catId = categoryId else { return nil }
    return RealmWorker.shared.realm.object(ofType: RealmCategory.self, forPrimaryKey: catId)?.toCategory()
  }
  
  func fetchCategories() -> [Category] {
    let categories = RealmWorker.shared.realm.objects(RealmCategory.self)
    return categories.map { $0.toCategory() }
  }
  
  func save(category: Category, completion: @escaping (Error?) -> Void) {
    try? RealmWorker.shared.realm.write {
      RealmWorker.shared.realm.create(RealmCategory.self, value: RealmCategory.toRealmCategory(category), update: .modified)
      completion(nil)
    }
  }
  
  func delete(displayCategory: DisplayCategory, completion: @escaping (Error?) -> Void) {
    let category = RealmWorker.shared.realm.object(ofType: RealmCategory.self, forPrimaryKey: displayCategory.categoryId)
    if let cat = category {
      try? RealmWorker.shared.realm.write {
        RealmWorker.shared.realm.delete(cat)
        completion(nil)
      }
    } else {
      completion(DeleteCategoryError.generic)
    }
  }
}
