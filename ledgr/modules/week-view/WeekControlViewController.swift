//
//  WeekControlViewController.swift
//  ledgr
//
//  Created by Caroline on 11/12/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import UIKit
import AFDateHelper

protocol WeekControlViewControllerDelegate: class {
  func selectedDateChanged(date: Date)
  func weekChanged(startDate: Date)
}

class WeekControlViewController: UIViewController {
  weak var delegate: WeekControlViewControllerDelegate?
  private let dateLabels = ["S", "M", "T", "W", "T", "F", "S", "S", "M", "T", "W", "T", "F", "S", "S", "M", "T", "W", "T", "F", "S"]
  private let weekControlScrollView = WeekControlScrollView()
  private var currentPageStartDate = Date() // Monday or Sunday of current week
  private var calendar = Calendar.current
  private var currentSelectedDate = Date()
  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter
  }()
  
  let monthFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM"
    return dateFormatter
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(weekControlScrollView)
    weekControlScrollView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    weekControlScrollView.delegate = self
    start()
  }
  
  private var initialized: Bool = false
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    view.layoutIfNeeded()
    if !initialized {
      indexChanged(index: 1)
    }
  }
  
  private func start() {
    currentPageStartDate = DateFormatters.firstDayInWeekFor(date: Date().stripTime(), calendar: calendar)
    currentSelectedDate = Date().stripTime()
  }
  
  func indexChanged(index: Int) {
    var val = 0
    if index == 0 {
      val = -1
    } else if index == 2 {
      val = 1
    }
    let newDate = calendar.date(byAdding: .weekOfYear, value: val, to: currentPageStartDate)!
    currentPageStartDate = newDate
    if !currentPageStartDate.isInCurrentWeek {
      currentSelectedDate = newDate
    } else {
      currentSelectedDate = Date().stripTime()
    }
    presentDates()
  }
  
  private func presentDates() {
    var totalPages = 3
    if isOnCurrentWeekFor(date: currentPageStartDate, calendar: calendar) {
      totalPages = 2
    }
    presentDates(calendar: calendar, totalPages: totalPages, startDate: currentPageStartDate, selectedDate: currentSelectedDate)
  }
  
  private func isOnCurrentWeekFor(date: Date, calendar: Calendar) -> Bool {
    if date == DateFormatters.firstDayInWeekFor(date: Date(), calendar: calendar) {
      return true
    }
    return false
  }
  
  private func presentDates(calendar: Calendar, totalPages: Int, startDate: Date, selectedDate: Date) {
    var models = [WeekView.DisplayDateObject]()
    for i in 0...((7 * 3) - 1) {
      let diff = -1 * (7 - i)
      let day = calendar.date(byAdding: .day, value: diff, to: startDate)!
      let selected = selectedDate.compare(.isSameDay(as: day))
      var model = WeekView.DisplayDateObject(date: day, subtitle: dateFormatter.string(from: day), title: dateLabels[i], subtitleColor: UIColor.LedgrCharcoal(), titleColor: UIColor.LedgrCharcoal(), selected: selected)
      if day.isInToday {
        model.titleColor = UIColor.LedgrBubbleGray()
        model.subtitleColor = UIColor.LedgrBubbleGray()
      }
      models.append(model)
    }
    setDates(page: 1, totalPages: totalPages, displayObjects: models, selectedDate: selectedDate)
  }
  
  func setDates(page: Int, totalPages: Int, displayObjects: [WeekView.DisplayDateObject], selectedDate: Date) {
    weekControlScrollView.contentOffset.x = weekControlScrollView.frame.width * CGFloat(page)
    weekControlScrollView.contentSize.width = weekControlScrollView.frame.width * CGFloat(totalPages)
    for (index, date) in displayObjects.enumerated() {
      let weekView = weekControlScrollView.weekViews[index]
      weekView.delegate = self
      weekView.set(data: date)
    }
    // logviewcontroller is the delegate
    delegate?.selectedDateChanged(date: selectedDate)
  }
  
}

extension WeekControlViewController: WeekViewDelegate {
  func weekViewTouched(data: WeekView.DisplayDateObject?) {
    if let date = data?.date {
      currentSelectedDate = date
      presentDates()
    }
  }
  
  func scrollTo(date: Date) {
    currentSelectedDate = date
    currentPageStartDate = currentSelectedDate.dateFor(.startOfWeek)
    presentDates()
  }
}

extension WeekControlViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
    indexChanged(index: index)
    delegate?.weekChanged(startDate: currentPageStartDate)
  }
}
