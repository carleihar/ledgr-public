//
//  LogTableViewCell.swift
//  ledgr
//
//  Created by Caroline on 11/14/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import UIKit

protocol LogTableViewCellDelegate: class {
  func editButtonTouched(cell: LogTableViewCell)
  func deleteButtonTouched(cell: LogTableViewCell)
}

class LogTableViewCell: UITableViewCell {
  weak var delegate: LogTableViewCellDelegate?
  
  private let titleLabel = UILabel.createBoldLabel(text: nil, size: 16)
  private let priceLabel = UILabel.createBoldLabel(text: nil, size: 16)
  private let categoryLabel = UILabel.createRegularLabel(text: nil, size: 12)
  private let extraNotesLabel = UILabel.createRegularLabel(text: nil, size: 14)
  private let categoryColorView = UIView()
  private let borderView = UIView()
  private let padding: CGFloat = 20
  private let editButton = UIButton()
  private let deleteButton = UIButton()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    selectionStyle = .none
    
    let categoryColorViewSize: CGFloat = 6.0
    
    addSubview(borderView)
    addSubview(categoryColorView)
    addSubview(titleLabel)
    addSubview(extraNotesLabel)
    addSubview(categoryLabel)
    addSubview(priceLabel)
    addSubview(editButton)
    addSubview(deleteButton)
    
    categoryLabel.isHidden = true
    categoryLabel.textColor = UIColor.LedgrDarkGray()
    extraNotesLabel.isHidden = true
    extraNotesLabel.numberOfLines = 0
    
    editButton.isHidden = true
    editButton.addTarget(self, action: #selector(editButtonTouched), for: .touchUpInside)
    editButton.tintColor = UIColor.LedgrDarkGray()
    editButton.setImage(UIImage(named: "edit"), for: .normal)
    
    deleteButton.isHidden = true
    deleteButton.addTarget(self, action: #selector(deleteButtonTouched), for: .touchUpInside)
    deleteButton.tintColor = UIColor.LedgrRed()
    deleteButton.setImage(UIImage(named: "delete-x"), for: .normal)
    
    categoryColorView.backgroundColor = UIColor.LedgrLightestGray()
    categoryColorView.snp.makeConstraints { (make) in
      make.left.equalTo(borderView).offset(padding)
      make.width.height.equalTo(categoryColorViewSize)
      make.centerY.equalTo(priceLabel)
    }
    categoryColorView.layer.cornerRadius = categoryColorViewSize / 2.0
    
    titleLabel.snp.makeConstraints { (make) in
      make.left.equalTo(categoryColorView.snp.right).offset(10)
      make.centerY.equalTo(priceLabel)
      make.right.equalTo(priceLabel.snp.left)
    }
    
    priceLabel.textAlignment = .right
    priceLabel.snp.makeConstraints { (make) in
      make.top.equalTo(borderView).offset(padding)
      make.bottom.equalTo(borderView).inset(padding)
      make.right.equalTo(borderView).inset(padding)
    }
    
    borderView.layer.cornerRadius = 5
    borderView.layer.borderWidth = 1
    borderView.backgroundColor = .clear
    borderView.layer.borderColor = UIColor.LedgrLightestGray().cgColor
    borderView.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(padding)
      make.left.equalToSuperview().offset(padding)
      make.top.equalToSuperview().offset(padding / 2)
      make.bottom.equalToSuperview().inset(padding / 2)
    }
  }
  
  func set(log: DisplayLog) {
    titleLabel.text = log.title
    priceLabel.text = log.total
    categoryLabel.text = log.categoryText?.isEmpty ?? true ? "Uncategorized" : log.categoryText
    extraNotesLabel.text = log.extraNotes
    if let colorHex = log.categoryColorHex, let color = UIColor(hexString: colorHex) {
      categoryColorView.backgroundColor = color
    }
    if log.expanded { setExpanded() } else { setHidden() }
  }
  
  private func setExpanded() {
    sendSubviewToBack(borderView)
    borderView.backgroundColor = UIColor.LedgrLightestGray()
    priceLabel.snp.remakeConstraints { (make) in
      make.top.equalTo(borderView).offset(padding)
      make.right.equalTo(borderView).inset(padding)
    }
    
    categoryLabel.isHidden = false
    categoryLabel.snp.makeConstraints { (make) in
      make.left.equalTo(categoryColorView)
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
    }
    
    extraNotesLabel.isHidden = false
    extraNotesLabel.snp.makeConstraints { (make) in
      make.left.equalTo(categoryColorView)
      make.right.equalToSuperview().inset(8)
      make.top.equalTo(categoryLabel.snp.bottom).offset(8)
    }
    
    editButton.isHidden = false
    deleteButton.isHidden = false
    editButton.snp.remakeConstraints { (make) in
      make.height.width.equalTo(20)
      make.top.equalTo(extraNotesLabel.snp.bottom).offset(padding)
      make.left.equalTo(borderView).offset(padding)
      make.bottom.equalTo(borderView).inset(padding)
    }
    
    deleteButton.snp.remakeConstraints { (make) in
      make.height.width.equalTo(20)
      make.centerY.equalTo(editButton)
      make.right.equalTo(borderView).inset(padding)
    }
  }
  
  private func setHidden() {
    borderView.backgroundColor = .clear
    editButton.isHidden = true
    deleteButton.isHidden = true
    categoryLabel.isHidden = true
    extraNotesLabel.isHidden = true
    
    editButton.snp.removeConstraints()
    deleteButton.snp.removeConstraints()
    categoryLabel.snp.removeConstraints()
    
    priceLabel.snp.makeConstraints { (make) in
      make.top.equalTo(borderView).offset(padding)
      make.bottom.equalTo(borderView).inset(padding)
      make.right.equalTo(borderView).inset(padding)
    }
  }
  
  @objc func editButtonTouched() {
    delegate?.editButtonTouched(cell: self)
  }
  
  @objc func deleteButtonTouched() {
    delegate?.deleteButtonTouched(cell: self)
  }
}

class LogTableViewHeaderCell: UIView {
  private let label = UILabel.createItalicLabel(text: nil, size: 11)
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(label)
    backgroundColor = .white
    label.textColor = UIColor.LedgrDarkGray()
    label.snp.makeConstraints { (make) in
      make.right.equalToSuperview().inset(20)
      make.left.equalToSuperview().offset(20)
      make.top.equalToSuperview().offset(0)
      make.bottom.equalToSuperview().inset(0)
    }
  }
  
  func set(title: String) {
    label.text = title
  }
}
