//
//  DataObserver.swift
//  ledgr
//
//  Created by Caroline on 1/25/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

enum DataUpdateClass {
  case log
  case category
}

enum DataUpdateType {
  case added
  case modified
  case deleted
}

protocol Observable { }

class DataObserver {
  static let shared = DataObserver()
  
  private var delegates = [DataObserverProtocol]()
  
  // MARK: Observer delegates
  
  func addDelegate(delegate: DataObserverProtocol) {
    if indexOfDelegate(delegate: delegate) == nil {
      delegates.append(delegate)
    }
  }
  
  func removeDelegate(delegate: DataObserverProtocol) {
    if let index = indexOfDelegate(delegate: delegate) {
      delegates.remove(at: index)
    }
  }
  
  private func indexOfDelegate(delegate: DataObserverProtocol) -> Int? {
    return delegates.firstIndex(where: { $0 === delegate })
  }
  
  func logsHaveUpdated() {
    sendEvent(dataClass: .log, type: .modified)
  }
  
  func logDeleted() {
    sendEvent(dataClass: .log, type: .deleted)
  }
  
  func logAdded() {
    sendEvent(dataClass: .log, type: .added)
  }
  
  func categoryAdded(realmCategory: RealmCategory?) {
    sendEvent(dataClass: .category, type: .added, observable: realmCategory?.toCategory())
  }
  
  func categoryDeleted() {
    sendEvent(dataClass: .category, type: .deleted)
  }
  
  func categoryUpdated() {
    sendEvent(dataClass: .category, type: .modified)
  }
  
  private func sendEvent(dataClass: DataUpdateClass, type: DataUpdateType, observable: Observable? = nil) {
    for delegate in self.delegates {
      delegate.dataUpdated(dataClass: dataClass, type: type, data: observable)
    }
  }
}

protocol DataObserverProtocol: class {
  func dataUpdated(dataClass: DataUpdateClass, type: DataUpdateType, data: Observable?)
}
