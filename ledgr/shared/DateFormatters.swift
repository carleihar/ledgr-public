import Foundation
import SwifterSwift

struct DateFormatters {
  
  static var shortDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .short
    return dateFormatter
  }()
  
  static var prettyDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
    return dateFormatter
  }()
  
  static var monthFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM"
    return dateFormatter
  }()
  
  static var fullMonthFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM"
    return dateFormatter
  }()
  
  static var yearFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY"
    return dateFormatter
  }()
  
  static func firstDayOfMonth(date: Date) -> Date {
    var first = date
    first.day = 1
    return first
  }
  
  // Returns UTC timestamp for the first day in a week
  static func firstDayInWeekFor(date: Date, calendar: Calendar) -> Date {
    let comps = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
    return calendar.date(from: comps)!
  }
}

extension Date {
  func stripTime() -> Date {
    let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
    let date = Calendar.current.date(from: components)
    return date!
  }
}
