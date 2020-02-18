//
//  CalculateTotalPresenter.swift
//  ledgr
//
//  Created by Caroline on 2/18/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation

protocol CalculateTotalPresenterProtocol {
  func calculated(totals: [(Category, Float)], uncategorized: Float, segmentTotal: Float)
}

protocol CalculateTotalPresenterDelegate: class {
  func display(totals: [DisplayTotal])
}

class CalculateTotalPresenter: CalculateTotalPresenterProtocol {
  weak var delegate: CalculateTotalPresenterDelegate?
  
  func calculated(totals: [(Category, Float)], uncategorized: Float, segmentTotal: Float) {
    var displayTotals: [DisplayTotal] = []
    let display = DisplayTotal(categoryId: nil, imageName: "wallet", totalString: Formatters.currencyFormatter.string(from: NSNumber(value: segmentTotal)) ?? "$0", barPercentage: 0, title: "Monthly Total", count: "0 logs", backgroundColorHex: "badecf")
    displayTotals.append(display)
    for total in totals {
      let display = DisplayTotal(categoryId: total.0.objectId, imageName: total.0.iconName, totalString: Formatters.currencyFormatter.string(from: NSNumber(value: total.1)) ?? "$0", barPercentage: 0, title: total.0.name, count: "0 logs", backgroundColorHex: total.0.hexColor)
      displayTotals.append(display)
    }
    if uncategorized != 0 {
      let uncat = DisplayTotal(categoryId: "uncategorized", imageName: "uncategorized", totalString: Formatters.currencyFormatter.string(from: NSNumber(value: uncategorized)) ?? "$0", barPercentage: 0, title: "Uncategorized", count: "0 logs", backgroundColorHex: "#d0d0d0")
      displayTotals.append(uncat)
    }
    delegate?.display(totals: displayTotals)
  }
}
