//
//  CategoryCollectionViewCell.swift
//  ledgr
//
//  Created by Caroline on 12/8/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
  private let colorView = UIView()
  private let borderView = UIView()
  private let iconView = UIImageView()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(borderView)
    addSubview(colorView)
    addSubview(iconView)
    colorView.layer.cornerRadius = 8.8
    
    colorView.snp.makeConstraints { (make) in
      make.left.top.equalToSuperview().offset(8)
      make.right.bottom.equalToSuperview().inset(8)
      make.centerX.centerY.equalToSuperview()
    }
    
    borderView.borderWidth = 1
    borderView.borderColor = .clear
    borderView.layer.cornerRadius = 10

    borderView.snp.makeConstraints { (make) in
      make.left.top.equalToSuperview().offset(5)
      make.right.bottom.equalToSuperview().inset(5)
      make.centerX.centerY.equalToSuperview()
    }

    iconView.contentMode = .scaleAspectFit
    
    iconView.snp.makeConstraints { (make) in
      make.left.top.equalToSuperview().offset(20)
      make.right.bottom.equalToSuperview().inset(20)
      make.centerX.centerY.equalToSuperview()
    }
  }
  
  func set(category: DisplayCategory) {
    if category.alwaysDisplayBorder {
      colorView.borderWidth = 1
      colorView.borderColor = UIColor.LedgrBubbleGray()
    }
    colorView.backgroundColor = UIColor(hexString: category.hexColor)
    iconView.image = UIImage(named: category.iconName)
    iconView.tintColor = UIColor(hexString: category.hexColor)?.darken(by: 0.8)
  }
  
  func set(selected: Bool, category: DisplayCategory) {
    if !category.alwaysDisplayBorder {
      borderView.borderColor = selected ? UIColor.LedgrBubbleGray() : .clear
    }
    colorView.backgroundColor = UIColor(hexString: category.hexColor)
  }
}
