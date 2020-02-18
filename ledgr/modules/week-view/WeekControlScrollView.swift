//
//  WeekControlScrollView.swift
//  SpendingLogger
//
//  Created by Caroline on 2/17/19.
//  Copyright © 2019 Caroline. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

protocol WeekViewDelegate: class {
  func weekViewTouched(data: WeekView.DisplayDateObject?)
}

class WeekControlScrollView: UIScrollView {
  var weekViews = [WeekView]()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    showsHorizontalScrollIndicator = false
    isPagingEnabled = true
    canCancelContentTouches = true
    delaysContentTouches = true
    decelerationRate = UIScrollView.DecelerationRate.fast
    setupLabels()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLabels() {
    for _ in 1...21 {
      let l = WeekView()
      weekViews.append(l)
      addSubview(l)
    }
    contentOffset.x = frame.width * 1
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let cellWidth: CGFloat = frame.width / 7.0
    for (index, weekView) in weekViews.enumerated() {
      weekView.frame = CGRect(x: CGFloat(index) * cellWidth, y: 0, width: cellWidth, height: frame.height)
    }
  }
}

class WeekView: UIView {
  struct DisplayDateObject {
    var date: Date
    var subtitle: String
    var title: String
    var subtitleColor: UIColor = UIColor.LedgrCharcoal()
    var titleColor: UIColor = UIColor.LedgrCharcoal()
    var selected: Bool = false
  }
  
  private var labelsContainer = UIView()
  private var titleLabel = UILabel()
  private var subtitleLabel = UILabel()
  private var data: WeekView.DisplayDateObject?
  private var circleView = UIView()
  weak var delegate: WeekViewDelegate?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLabels()
    setupCircle()
    labelsContainer.sendSubviewToBack(circleView)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    self.addGestureRecognizer(tapGesture)
  }
  
  @objc func handleTap() {
    delegate?.weekViewTouched(data: data)
  }
  
  func set(data: WeekView.DisplayDateObject) {
    self.data = data
    titleLabel.text = data.title
    subtitleLabel.text = data.subtitle
    titleLabel.textColor = data.titleColor
    circleView.backgroundColor = data.selected ? UIColor.LedgrBubbleGray() : UIColor.clear
    subtitleLabel.textColor = data.selected ? .white : data.subtitleColor
  }
  
  private func setupLabels() {
    addSubview(labelsContainer)
    labelsContainer.snp.makeConstraints { (make) in
      make.centerX.equalTo(self)
      make.centerY.equalTo(self).offset(1)
    }
    setupTitleLabel()
    setupSubtitleLabel()
  }
  
  private func setupTitleLabel() {
    titleLabel.font = UIFont.regularLedgrFont(size: 10)
    titleLabel.textAlignment = .center
    titleLabel.textColor = UIColor.SLMiddleGray()
    labelsContainer.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { (make) in
      make.left.right.top.equalTo(labelsContainer)
    }
  }
  
  private func setupSubtitleLabel() {
    subtitleLabel.font = UIFont.boldLedgrFont(size: 16)
    subtitleLabel.textAlignment = .center
    subtitleLabel.textColor = UIColor.LedgrCharcoal()
    labelsContainer.addSubview(subtitleLabel)
    let inset = 8
    subtitleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(labelsContainer).offset(inset)
      make.bottom.right.equalTo(labelsContainer).inset(inset)
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
    }
  }
  
  private func setupCircle() {
    circleView.layer.cornerRadius = 10.0
    labelsContainer.addSubview(circleView)
    circleView.snp.makeConstraints { (make) in
      make.height.width.equalTo(35)
      make.centerX.centerY.equalTo(subtitleLabel)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
