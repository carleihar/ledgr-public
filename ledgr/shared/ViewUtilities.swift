//
//  ViewUtilities.swift
//  SpendingLogger
//
//  Created by Caroline on 2/18/19.
//  Copyright © 2019 Caroline. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
          CAMediaTimingFunctionName.easeInEaseOut)
      animation.type = CATransitionType.fade
        animation.duration = duration
      layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

extension UILabel {
  static func createBoldLabel(text: String?, size: CGFloat) -> UILabel {
    let label = UILabel(text: text)
    label.font = UIFont.boldLedgrFont(size: size)
    return label
  }
  
  static func createRegularLabel(text: String?, size: CGFloat) -> UILabel {
    let label = UILabel(text: text)
    label.font = UIFont.regularLedgrFont(size: size)
    return label
  }
  
  static func createItalicLabel(text: String?, size: CGFloat) -> UILabel {
    let label = UILabel(text: text)
    label.font = UIFont.italicLedgrFont(size: size)
    return label
  }
}

extension UIFont {
  static func regularLedgrFont(size: CGFloat) -> UIFont? {
    return UIFont(name: "SpaceMono-Regular", size: size)
  }
  
  static func boldLedgrFont(size: CGFloat) -> UIFont? {
    return UIFont(name: "SpaceMono-Bold", size: size)
  }

  static func italicLedgrFont(size: CGFloat) -> UIFont? {
    return UIFont(name: "SpaceMono-Italic", size: size)
  }
  
  static func titleRegularLedgrFont(size: CGFloat) -> UIFont? {
    return UIFont(name: "Quantico-Regular", size: size)
  }
  
  static func titleBoldLedgrFont(size: CGFloat) -> UIFont? {
    return UIFont(name: "Quantico-Bold", size: size)
  }
  
  static func titleItalicLedgrFont(size: CGFloat) -> UIFont? {
    return UIFont(name: "Quantico-Italic", size: size)
  }
  
  static func titleBoldItalicLedgrFont(size: CGFloat) -> UIFont? {
    return UIFont(name: "Quantico-BoldItalic", size: size)
  }
}

extension UIColor {
  static func LedgrRed() -> UIColor {
      return hexStringToUIColor(hex: "#fc5c65")
  }

  static func LedgrYellow() -> UIColor {
      return hexStringToUIColor(hex: "#f7b731")
  }
  
  static func LedgrBubbleGray() -> UIColor {
      return hexStringToUIColor(hex: "#d0d0d0")
  }
  
  static func LedgrLightestGray() -> UIColor {
      return hexStringToUIColor(hex: "#eaeaea")
  }
  
  static func LedgrDarkGray() -> UIColor {
      return hexStringToUIColor(hex: "#686868")
  }
  
  static func LedgrCharcoal() -> UIColor {
      return hexStringToUIColor(hex: "#181818")
  }
    
    static func SLMiddleGray() -> UIColor {
        return hexStringToUIColor(hex: "#9a9b9e")
    }
    
    static func SLMiddleDarkGray() -> UIColor {
        return hexStringToUIColor(hex: "#606062")
    }
    
    static func SLDarkerGray() -> UIColor {
        return hexStringToUIColor(hex: "#3b3b3c")
    }
    
    static func hexStringToUIColor(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIColor {
    static func blend(color1: UIColor, intensity1: CGFloat = 0.5, color2: UIColor, intensity2: CGFloat = 0.5) -> UIColor {
        let total = intensity1 + intensity2
        let l1 = intensity1/total
        let l2 = intensity2/total
        guard l1 > 0 else { return color2}
        guard l2 > 0 else { return color1}
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}

extension CAShapeLayer {
    static func createShadowLayer(frame: CGRect, cornerRadius: CGFloat = 10, shadowColor: UIColor = UIColor.black, shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0), opacity: Float = 0.1, shadowRadius: CGFloat  = 4.0, fillColor: UIColor = UIColor.white) -> CAShapeLayer {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width, height: frame.height), cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = fillColor.cgColor
        
        shadowLayer.shadowColor = shadowColor.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = shadowOffset
        shadowLayer.shadowOpacity = opacity
        shadowLayer.shadowRadius = shadowRadius
        return shadowLayer
    }
}

extension UINavigationBar {
    var largeTitleHeight: CGFloat {
        let maxSize = self.subviews
            .filter { $0.frame.origin.y > 0 }
            .max { $0.frame.origin.y < $1.frame.origin.y }
            .map { $0.frame.size }
        return maxSize?.height ?? 0
    }
}

class DismissSegue: UIStoryboardSegue {
  override func perform() {
    self.source.presentingViewController?.dismiss(animated: true, completion: nil)
  }
}

class CompressedButton: UIButton {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  // MARK: - Overrides
  override var intrinsicContentSize: CGSize {
    get {
      return isHidden ? .zero : titleLabel?.intrinsicContentSize ?? .zero
    }
  }
}

// https://stackoverflow.com/questions/29782982/how-to-input-currency-format-on-a-text-field-from-right-to-left-using-swift
extension String {
    func currencyInputFormatting() -> String {
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))

        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }
}

extension UITableView {
  func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
    return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
  }
}

extension UIColor {

    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }

    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }

    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
