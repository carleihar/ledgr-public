//
//  Parsers.swift
//  SpendingLogger
//
//  Created by Caroline on 3/2/19.
//  Copyright © 2019 Caroline. All rights reserved.
//

import Foundation

struct Parsers {
  static let numberFormatter: NumberFormatter = {
    return NumberFormatter()
  }()
  
  static func parseToNumber(string: String?) -> Float {
    let number = Parsers.numberFormatter.number(from: string?.filter("01234567890.".contains) ?? "")
    return number?.floatValue ?? 0
  }
  
}

struct Formatters {
  static let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()
  
  static func currencyFrom(float: Float) -> String {
    return Formatters.currencyFormatter.string(from: NSNumber(value: float)) ?? "$0.00"
  }
}
