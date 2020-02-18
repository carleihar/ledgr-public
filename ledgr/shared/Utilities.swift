//
//  Utilities.swift
//  SpendingLogger
//
//  Created by Caroline on 3/1/19.
//  Copyright © 2019 Caroline. All rights reserved.
//

import Foundation
import UIKit

extension String {
  var isBlank: Bool {
    return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}

extension Optional where Wrapped == String {
  var isBlank: Bool {
    if let unwrapped = self {
      return unwrapped.isBlank
    } else {
      return true
    }
  }
}
