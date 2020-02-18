//
//  LedgrNavigationController.swift
//  ledgr
//
//  Created by Caroline on 11/13/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import UIKit

class LedgrNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.prefersLargeTitles = true
    navigationBar.largeTitleTextAttributes =
        [NSAttributedString.Key.font: UIFont.titleBoldLedgrFont(size: 40)!,
         NSAttributedString.Key.foregroundColor: UIColor.black]
    navigationBar.titleTextAttributes =
        [NSAttributedString.Key.font: UIFont.titleBoldLedgrFont(size: 20)!,
         NSAttributedString.Key.foregroundColor: UIColor.black]
  }
}
