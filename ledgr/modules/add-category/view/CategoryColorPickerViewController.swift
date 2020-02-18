//
//  CategoryColorPickerViewController.swift
//  ledgr
//
//  Created by Caroline on 1/20/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryColorPickerViewControllerDelegate: class {
  func colorSelected(hex: String)
}

protocol CategoryColorPickerViewControllerProtocol {
  func set(colors: [DisplayCategoryColor])
}

class CategoryColorPickerViewController: UIViewController {
  weak var delegate: CategoryColorPickerViewControllerDelegate?
  private let categoryCollectionView: UICollectionView
  private var colors: [DisplayCategoryColor] = []

  init() {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 10
    layout.scrollDirection = .horizontal
    categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCategories()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let selectedRow = self.colors.indices { (c) -> Bool in
      c.selected
    }?.first
    if let sr = selectedRow {
      categoryCollectionView.scrollToItem(at: IndexPath(row: sr, section: 0), at: .centeredHorizontally, animated: true)
    }
  }
  
  // MARK: View setup
  
  private func setupCategories() {
    view.addSubview(categoryCollectionView)

    categoryCollectionView.showsHorizontalScrollIndicator = false
    categoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    categoryCollectionView.delegate = self
    categoryCollectionView.dataSource = self
    categoryCollectionView.backgroundColor = .white
    categoryCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    categoryCollectionView.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(0)
      make.right.equalToSuperview().inset(0)
      make.top.bottom.equalToSuperview()
    }
  }
}

extension CategoryColorPickerViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colors.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let color = colors[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ColorCollectionViewCell
    cell.set(color: color.color)
    if color.selected {
      cell.set(selected: true)
    } else {
      cell.set(selected: false)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
      let color = colors[indexPath.row]
      cell.set(selected: true)
      delegate?.colorSelected(hex: color.color)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell {
      cell.set(selected: false)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: ColorCollectionViewCell.ColorCollectionViewCellHeight, height: ColorCollectionViewCell.ColorCollectionViewCellHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .zero
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}

class ColorCollectionViewCell: UICollectionViewCell {
  static var ColorCollectionViewCellHeight: CGFloat = 50
  
  private let colorView = UIView()
  private let borderView = UIView()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    addSubview(colorView)
    addSubview(borderView)
    
    colorView.snp.makeConstraints { (make) in
      make.left.top.equalTo(borderView).offset(3)
      make.right.bottom.equalTo(borderView).inset(3)
    }
    colorView.cornerRadius = (ColorCollectionViewCell.ColorCollectionViewCellHeight - 6) / 2
    
    borderView.borderWidth = 1
    borderView.borderColor = .clear
    borderView.layer.cornerRadius = ColorCollectionViewCell.ColorCollectionViewCellHeight / 2

    borderView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
      make.height.width.equalTo(ColorCollectionViewCell.ColorCollectionViewCellHeight)
    }
  }
  
  func set(color: String) {
    colorView.backgroundColor = UIColor.hexStringToUIColor(hex: color)
  }
  
  func set(selected: Bool) {
    borderView.borderColor = selected ? UIColor.LedgrBubbleGray() : .clear
  }
}

extension CategoryColorPickerViewController: CategoryColorPickerViewControllerProtocol {
  
  func set(colors: [DisplayCategoryColor]) {
    self.colors = colors
    categoryCollectionView.reloadData()
  }
}
