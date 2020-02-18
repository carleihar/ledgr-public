//
//  CategoryCollectionViewController.swift
//  ledgr
//
//  Created by Caroline on 1/7/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import UIKit

protocol CategoryCollectionViewControllerProtocol {
  func update(categories: [DisplayCategory])
}

protocol CategoryCollectionViewControllerDelegate: class {
  func selected(category: DisplayCategory)
}

class CategoryCollectionViewController: UIViewController {
  weak var delegate: CategoryCollectionViewControllerDelegate?
  private var categories: [DisplayCategory] = []
  private let categoryCollectionView: UICollectionView
  private let categoryTitleLabel = UILabel.createRegularLabel(text: "", size: 16)
  private(set) var selectedCategoryId: String?
  let categoryTitleLabelText: String
  
  init(categories: [DisplayCategory], categoryTitleLabelText: String = "uncategorized") {
    self.categories = categories
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    self.categoryTitleLabelText = categoryTitleLabelText
    categoryTitleLabel.text = categoryTitleLabelText
    super.init(nibName: nil, bundle: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCategories()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateCategoryViewHeight()
  }
  
  private func setupCategories() {
    view.addSubview(categoryTitleLabel)
    view.addSubview(categoryCollectionView)

    categoryCollectionView.delegate = self
    categoryCollectionView.dataSource = self
    categoryCollectionView.backgroundColor = .white
    categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    categoryTitleLabel.textColor = UIColor.LedgrDarkGray()
    categoryTitleLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.equalToSuperview().offset(20)
      make.right.equalToSuperview().inset(20)
    }
    categoryCollectionView.snp.makeConstraints { (make) in
      make.top.equalTo(categoryTitleLabel.snp.bottom).offset(8)
      make.left.equalToSuperview().offset(10)
      make.right.equalToSuperview().inset(10)
      make.bottom.equalToSuperview()
    }
  }

  private func updateCategoryViewHeight() {
    let cellHeight: CGFloat = (categoryCollectionView.frame.size.width / 5)
    let numberOfRows: CGFloat = ceil(CGFloat(categories.count) / 5.0)
    let collectionViewHeight = numberOfRows * cellHeight
    categoryCollectionView.snp.remakeConstraints { (make) in
      make.height.equalTo(collectionViewHeight)
      make.top.equalTo(categoryTitleLabel.snp.bottom).offset(8)
      make.left.equalToSuperview().offset(10)
      make.right.equalToSuperview().inset(10)
      make.bottom.equalToSuperview()
    }
  }
  
  private func showAddCategory() {
    let addViewController = AddEditCategoryViewControllerFactory().createAddCategory()
    navigationController?.pushViewController(addViewController)
  }
}

extension CategoryCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let category = categories[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoryCollectionViewCell
    cell.set(category: category)
    if category.selected {
      selected(cell: cell, category: category)
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
      let category = categories[indexPath.row]
      if category.categoryId == "add_new" {
        showAddCategory()
        return
      }
      deselectAllCells()
      if selectedCategoryId == category.categoryId {
        categoryTitleLabel.text = categoryTitleLabelText
        selectedCategoryId = nil
        category.selected = false
        cell.set(selected: false, category: category)
      } else {
        selected(cell: cell, category: category)
        delegate?.selected(category: category)
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionViewCell {
      let category = categories[indexPath.row]
      category.selected = false
      cell.set(selected: false, category: category)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let size = collectionView.frame.width / 5
    return CGSize(width: size, height: size)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return .zero
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  private func selected(cell: CategoryCollectionViewCell, category: DisplayCategory) {
    categoryTitleLabel.text = category.title.lowercased()
    selectedCategoryId = category.categoryId
    cell.set(selected: true, category: category)
  }
  
  private func deselectAllCells() {
    for (idx, cat) in categories.enumerated() {
      let cell = categoryCollectionView.cellForItem(at: IndexPath(row: idx, section: 0)) as? CategoryCollectionViewCell
      cell?.set(selected: false, category: cat)
    }
  }
}

extension CategoryCollectionViewController: CategoryCollectionViewControllerProtocol {
  func update(categories: [DisplayCategory]) {
    self.categories = categories
    let selected = self.categories.first { (cat) -> Bool in
      return cat.selected
    }
    selectedCategoryId = selected?.categoryId
    categoryCollectionView.reloadData()
    updateCategoryViewHeight()
  }
}
