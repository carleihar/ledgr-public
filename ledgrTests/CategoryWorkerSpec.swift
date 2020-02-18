//
//  CategoryWorkerSpec.swift
//  ledgrTests
//
//  Created by Caroline on 2/16/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

class MockCategoryWorker: CategoryWorkerProtocol {
  var returnError: Error? = nil
  
  func delete(displayCategory: DisplayCategory, completion: @escaping (Error?) -> Void) {
    completion(returnError)
  }
}
