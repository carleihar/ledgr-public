//
//  LedgrErrors.swift
//  ledgr
//
//  Created by Caroline on 1/27/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import UIKit

class LedgrErrorHelper {
  static func createGenericErrorMessage() -> String {
    return "Something went wrong but I couldn't tell you what. Try again?"
  }
  
  static func presentErrorAlert(viewController: UIViewController, errorMessage: String) {
    let alert = UIAlertController(title: "Oh Crap", message: errorMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
    alert.view.tintColor = .black
    viewController.present(alert, animated: true, completion: nil)
  }
}
