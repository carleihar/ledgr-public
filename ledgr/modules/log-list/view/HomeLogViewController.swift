//
//  HomeLogViewController.swift
//  ledgr
//
//  Created by Caroline on 1/24/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import UIKit

class HomeLogViewController: UIViewController {
  private let totalsControllerContainerView = UIView()
  private let totalsViewController = TotalsViewController()
  private let logViewControllerContainerView = UIView()
  private let logViewController = LogViewController()
 
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLogButtonTouched))
    navigationItem.rightBarButtonItem?.tintColor = UIColor.LedgrCharcoal()
    setupTotals()
    setupLog()
  }
  
  private func setupTotals() {
    view.addSubview(totalsControllerContainerView)
    addChild(totalsViewController)
    totalsControllerContainerView.addSubview(totalsViewController.view)
    totalsViewController.didMove(toParent: self)
    totalsControllerContainerView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.right.equalToSuperview()
    }
    totalsViewController.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupLog() {
    view.addSubview(logViewControllerContainerView)
    addChild(logViewController)
    logViewController.delegate = self
    logViewControllerContainerView.addSubview(logViewController.view)
    logViewController.didMove(toParent: self)
    logViewControllerContainerView.snp.makeConstraints { (make) in
      make.top.equalTo(totalsControllerContainerView.snp.bottom)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    logViewController.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  // MARK: user interactions
  
  @objc func addLogButtonTouched() {
    createAddLogViewController(editingLog: nil)
  }
}

extension HomeLogViewController: LogViewControllerDelegate {
  func createAddLogViewController(editingLog: DisplayLog?) {
    let addViewController = AddEditLogViewControllerFactory().createAddEditLog(editing: editingLog, date: logViewController.selectedDate)
    let navigation = LedgrNavigationController()
    navigation.viewControllers = [addViewController]
    navigationController?.present(navigation, animated: true, completion: nil)
  }
}
