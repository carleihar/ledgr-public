//
//  CategoryLogsViewController.swift
//  ledgr
//
//  Created by Caroline on 1/7/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import UIKit

class CategoryLogsViewController: UIViewController {
  private let displayTotal: DisplayTotal
  private let logViewControllerContainerView = UIView()
  private let logViewController: LogViewController
  
  init(displayTotal: DisplayTotal) {
    self.displayTotal = displayTotal
    logViewController = LogViewController(selectedCategoryId: displayTotal.categoryId)
    super.init(nibName: nil, bundle: nil)
    logViewController.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLog()
  }
  
  private func setupView() {
    view.backgroundColor = .white
    navigationItem.title = displayTotal.title.lowercased()
    
    if displayTotal.categoryId != "uncategorized" && displayTotal.categoryId != nil {
      setupEditIcon()
    }
  }
  
  private func setupLog() {
    view.addSubview(logViewControllerContainerView)
    addChild(logViewController)
    logViewControllerContainerView.addSubview(logViewController.view)
    logViewController.didMove(toParent: self)
    logViewControllerContainerView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    logViewController.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupEditIcon() {
    let menuBtn = UIButton(type: .custom)
    menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
    menuBtn.setImage(UIImage(named:"edit"), for: .normal)
    menuBtn.addTarget(self, action: #selector(editTapped), for: UIControl.Event.touchUpInside)

    let menuBarItem = UIBarButtonItem(customView: menuBtn)
    let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
    currWidth?.isActive = true
    let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
    currHeight?.isActive = true
    self.navigationItem.rightBarButtonItem = menuBarItem
  }
  
  // MARK: user interactions
  @objc func editTapped() {
    let addViewController = AddEditCategoryViewControllerFactory().createAddCategoryFromTotal(editing: displayTotal)
    navigationController?.pushViewController(addViewController)
  }
}

extension CategoryLogsViewController: LogViewControllerDelegate {
  func createAddLogViewController(editingLog: DisplayLog?) {
    let addViewController = AddEditLogViewControllerFactory().createAddEditLog(editing: editingLog, date: logViewController.selectedDate)
    navigationController?.pushViewController(addViewController)
  }
}
