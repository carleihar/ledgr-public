//
//  TotalsViewController.swift
//  ledgr
//
//  Created by Caroline on 12/28/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import UIKit

class TotalsViewController: UIViewController {
  private let categoryCollectionView: UICollectionView
  private var calculateTotalUseCase: CalculateTotalUseCaseProtocol?
  private var totals: [DisplayTotal] = []
  private let categoryLabel = UILabel.createItalicLabel(text: "monthly", size: 14)
  private let arrow = UIImageView(image: UIImage(named: "down-arrow"))
  private let timeButton = UIButton()
  
  init() {
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .horizontal
    categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTopDetails()
    setupCollectionView()
    let presenter = CalculateTotalPresenter()
    presenter.delegate = self
    calculateTotalUseCase = CalculateTotalUseCase(presenter: presenter)
    calculateTotalUseCase?.execute(selection: .month)
    
    DataObserver.shared.addDelegate(delegate: self)
  }
  
  private func setupTopDetails() {
    view.addSubview(categoryLabel)
    categoryLabel.textColor = UIColor.LedgrCharcoal()
    categoryLabel.snp.makeConstraints { (make) in
      make.left.equalToSuperview().inset(20)
      make.top.equalToSuperview().offset(10)
    }
    
    view.addSubview(arrow)
    arrow.contentMode = .scaleAspectFit
    arrow.tintColor = UIColor.LedgrCharcoal()
    arrow.snp.makeConstraints { (make) in
      make.left.equalTo(categoryLabel.snp.right).offset(6)
      make.centerY.equalTo(categoryLabel).offset(-1)
      make.width.equalTo(11)
    }
    
    view.addSubview(timeButton)
    timeButton.snp.makeConstraints { (make) in
      make.left.equalTo(categoryLabel).inset(-20)
      make.top.bottom.equalTo(categoryLabel)
      make.right.equalTo(arrow).offset(20)
    }
    timeButton.addTarget(self, action: #selector(timeButtonSelected), for: .touchUpInside)
  }
  
  private func setupCollectionView() {
    categoryCollectionView.backgroundColor = .white
    categoryCollectionView.showsHorizontalScrollIndicator = false
    categoryCollectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    categoryCollectionView.register(TotalCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    categoryCollectionView.register(TotalsAddCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "add_cell")
    categoryCollectionView.delegate = self
    categoryCollectionView.dataSource = self
    view.addSubview(categoryCollectionView)
    categoryCollectionView.snp.makeConstraints { (make) in
      make.top.equalTo(categoryLabel.snp.bottom).offset(10)
      make.bottom.left.right.equalToSuperview()
      make.height.equalTo(TotalCollectionViewCell.cellHeight)
    }
  }
  
  private func totalsTimeRangeChanged(selection: BudgetTimeRangeMenu) {
    calculateTotalUseCase?.execute(selection: selection)
  }
  
  // MARK: user interactions
  @objc func timeButtonSelected() {
    let optionMenu = UIAlertController(title: nil, message: "Totals Timeframe", preferredStyle: .actionSheet)
    let dayAction = UIAlertAction(title: "Day", style: .default) { action -> Void in
      self.categoryLabel.text = "daily"
      self.totalsTimeRangeChanged(selection: .day)
    }
    let monthAction = UIAlertAction(title: "Month", style: .default) { action -> Void in
      self.categoryLabel.text = "monthly"
      self.totalsTimeRangeChanged(selection: .month)
    }
    let weekAction = UIAlertAction(title: "Week", style: .default) { action -> Void in
      self.categoryLabel.text = "weekly"
      self.totalsTimeRangeChanged(selection: .week)
    }
    let yearAction = UIAlertAction(title: "Year", style: .default) { action -> Void in
      self.categoryLabel.text = "yearly"
      self.totalsTimeRangeChanged(selection: .year)
    }
    optionMenu.addAction(dayAction)
    optionMenu.addAction(weekAction)
    optionMenu.addAction(monthAction)
    optionMenu.addAction(yearAction)
    present(optionMenu, animated: true, completion: nil)
  }
}

extension TotalsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return totals.count + 1
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.row == totals.count {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "add_cell", for: indexPath) as! TotalsAddCategoryCollectionViewCell
      return cell
    }
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TotalCollectionViewCell
    cell.set(total: totals[indexPath.row])
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.row == totals.count {
      let addViewController = AddEditCategoryViewControllerFactory().createAddCategory()
      let navigation = LedgrNavigationController()
           navigation.viewControllers = [addViewController]
           navigationController?.present(navigation, animated: true, completion: nil)
      return
    }
    let total = totals[indexPath.row]
    if total.categoryId != nil {
      let controller = CategoryLogsViewController(displayTotal: total)
      let navigation = LedgrNavigationController()
      navigation.viewControllers = [controller]
      navigationController?.present(navigation, animated: true, completion: nil)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: indexPath.row == totals.count ? 90 : TotalCollectionViewCell.cellWidth, height: TotalCollectionViewCell.cellHeight)
  }
}

extension TotalsViewController: CalculateTotalPresenterDelegate {
  func display(totals: [DisplayTotal]) {
    self.totals = totals
    categoryCollectionView.reloadData()
  }
}

// MARK: RealmLogDelegate
extension TotalsViewController: DataObserverProtocol {
  func dataUpdated(dataClass: DataUpdateClass, type: DataUpdateType, data: Observable?) {
    calculateTotalUseCase?.execute(selection: nil)
  }
}
