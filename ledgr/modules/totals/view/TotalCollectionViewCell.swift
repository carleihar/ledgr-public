//
//  TotalCollectionViewCell.swift
//  ledgr
//
//  Created by Caroline on 12/30/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import UIKit

class TotalCollectionViewCell: UICollectionViewCell {
  static let cellHeight = 120
  static let cellWidth = 150
  private let colorView = UIView()
  private let imageView = UIImageView()
  private let totalLabel = UILabel.createBoldLabel(text: nil, size: 16)
  private let totalBar = UIView()
  private let percentageBar = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(colorView)
    colorView.addSubview(imageView)
    colorView.addSubview(totalLabel)
    colorView.addSubview(totalBar)
    totalBar.addSubview(percentageBar)
    
    colorView.layer.cornerRadius = 10
    colorView.snp.makeConstraints { (make) in
      make.left.top.equalToSuperview().offset(5)
      make.right.equalToSuperview().inset(5)
      make.bottom.equalToSuperview().inset(5)
    }
    
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(15)
      make.width.height.equalTo(35)
    }
    
    totalLabel.textColor = UIColor.LedgrCharcoal()
    totalLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(10)
      make.right.equalToSuperview().inset(20)
      make.top.equalTo(imageView.snp.bottom).offset(10)
    }
    
    totalBar.cornerRadius = 2.5
    totalBar.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(10)
      make.right.equalToSuperview().inset(10)
      make.top.equalTo(totalLabel.snp.bottom).offset(5)
      make.height.equalTo(5)
      make.bottom.equalToSuperview().inset(10)
    }

    percentageBar.snp.makeConstraints { (make) in
      make.left.top.bottom.equalToSuperview()
      make.width.equalTo(0)
    }
  }
  
  func set(total: DisplayTotal) {
    colorView.backgroundColor = UIColor(hexString: total.backgroundColorHex)?.withAlphaComponent(0.4)
    percentageBar.snp.remakeConstraints { (make) in
      make.left.top.bottom.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(total.barPercentage)
    }
    imageView.image = UIImage(named: total.imageName)
    imageView.tintColor = UIColor(hexString: total.backgroundColorHex)?.darken(by: 0.8)
    totalLabel.text = total.totalString
  }
}

class TotalsAddCategoryCollectionViewCell: UICollectionViewCell {
  override init(frame: CGRect) {
    super.init(frame: .zero)
    let borderView = UIView()
    borderView.borderWidth = 1
    borderView.borderColor = UIColor.LedgrBubbleGray()
    borderView.layer.cornerRadius = 10.0
    addSubview(borderView)
    borderView.snp.makeConstraints { (make) in
      make.left.top.equalToSuperview().offset(5)
      make.right.equalToSuperview().inset(5)
      make.bottom.equalToSuperview().inset(5)
    }
    
    let image = UIImageView(image: UIImage(named: "plus"))
    addSubview(image)
    image.snp.makeConstraints { (make) in
      make.height.width.equalTo(40)
      make.centerX.centerY.equalToSuperview()
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
