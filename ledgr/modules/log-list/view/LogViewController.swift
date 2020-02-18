//
//  LogViewController.swift
//  ledgr
//
//  Created by Caroline on 11/12/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import UIKit

protocol LogViewControllerDelegate: class {
  func createAddLogViewController(editingLog: DisplayLog?)
}

class LogViewController: UIViewController {
  private let weekControllerContainerView = UIView()
  private let weekControlViewController = WeekControlViewController()
  private let tableView = UITableView()
  private var logRequestUseCase: RequestLogsUseCase?
  private var displayLogs = [DisplaySection]()
  private var reloadingTableView = false
  weak var delegate: LogViewControllerDelegate?
  
  private(set) var selectedDate = Date()
  private var selectedCategoryId: String? = nil
  
  init(selectedCategoryId: String? = nil) {
    self.selectedCategoryId = selectedCategoryId
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    DataObserver.shared.addDelegate(delegate: self)
    
    let presenter = RequestLogsPresenter()
    logRequestUseCase = RequestLogsUseCase(presenter: presenter)
    presenter.delegate = self
    setupView()
    extendedLayoutIncludesOpaqueBars = true
    edgesForExtendedLayout = UIRectEdge.all
    logRequestUseCase?.execute(date: selectedDate, categoryId: selectedCategoryId)
  }
  
  // MARK: view setup
  
  private func setupView() {
    setupWeekControl()
    setupTableView()
    view.sendSubviewToBack(tableView)
  }
  
  private func setupWeekControl() {
    view.addSubview(weekControllerContainerView)
    addChild(weekControlViewController)
    weekControllerContainerView.addSubview(weekControlViewController.view)
    weekControlViewController.didMove(toParent: self)
    weekControlViewController.delegate = self
    weekControllerContainerView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.left.right.equalToSuperview()
      make.height.equalTo(80)
    }
    weekControlViewController.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .white
    tableView.register(LogTableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.separatorStyle = .none
    view.addSubview(tableView)
    tableView.snp.makeConstraints { (make) in
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview()
      make.top.equalTo(weekControllerContainerView.snp.bottom)
    }
  }
  
  private func deleteLogAt(index: IndexPath?) {
    let presenter = DeleteLogPresenter()
    presenter.delegate = self
    DeleteLogUseCase(presenter: presenter).execute(displaySections: displayLogs, indexPath: index)
  }
}

extension LogViewController: WeekControlViewControllerDelegate {
  func selectedDateChanged(date: Date) {
    selectedDate = date
    
    let section = displayLogs.indices { (ds) -> Bool in
      return date.compare(.isSameDay(as: ds.date))
    }?.first
    if let sec = section, tableView.hasRowAtIndexPath(indexPath: IndexPath(row: 0, section: sec)) {
      tableView.scrollToRow(at: IndexPath(row: 0, section: sec), at: .top, animated: true)
    }
  }
  
  func weekChanged(startDate: Date) {
    logRequestUseCase?.execute(date: startDate, categoryId: selectedCategoryId)
  }
}

extension LogViewController: RequestLogsDelegate {
  func displayLogs(errorMessage: String) {
    LedgrErrorHelper.presentErrorAlert(viewController: self, errorMessage: errorMessage)
  }
  
  func displayLogs(displayLogs: [DisplaySection]) {
    self.displayLogs = displayLogs
    reloadingTableView = true
    tableView.reloadData()
  }
}

extension LogViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return displayLogs.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return displayLogs[section].logs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let section = displayLogs[indexPath.section]
    let log = section.logs[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LogTableViewCell
    cell.delegate = self
    cell.set(log: log)
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let section = displayLogs[indexPath.section]
    let log = section.logs[indexPath.row]
    log.expanded = !log.expanded
    tableView.reloadRows(at: [indexPath], with: .fade)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let section = displayLogs[section]
    let view = LogTableViewHeaderCell()
    view.set(title: section.sectionTitle)
    return view
  }
  
  func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
    guard let pathsForVisibleRows = tableView.indexPathsForVisibleRows,
      let lastPath = pathsForVisibleRows.last,
      reloadingTableView != true else { return }

    // realoading the table view calls this method,
    // creating an issue where new logs being loaded
    // will animate the week view back to the first page
    reloadingTableView = false
    //compare the section for the header that just disappeared to the section
    //for the bottom-most cell in the table view
    if lastPath.section >= section {
      let nextSection = section + 1
      if nextSection < displayLogs.count {
        let displaySection = displayLogs[nextSection]
        weekControlViewController.scrollTo(date: displaySection.date)
      }
    }
  }

  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    //lets ensure there are visible rows.  Safety first!
    guard let pathsForVisibleRows = tableView.indexPathsForVisibleRows,
      let firstPath = pathsForVisibleRows.first,
      reloadingTableView != true else { return }

    //compare the section for the header that just appeared to the section
    //for the top-most cell in the table view
    if firstPath.section == section {
      let displaySection = displayLogs[section]
      weekControlViewController.scrollTo(date: displaySection.date)
    }
  }
  
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let action = UIContextualAction(
      style: .normal,
      title: "",
      handler: { (action, view, completion) in
        self.deleteLogAt(index: indexPath)
    })
    
    let cell = tableView.cellForRow(at: indexPath)
    let height = (cell?.height ?? 82) - 20
    let size = CGSize(width: 30, height: height)
    let imageSize: CGFloat = 20
    let imageFrameX = (size.width / 2) - (imageSize / 2)
    let imageFrameY = (size.height / 2) - (imageSize / 2)
    action.image = UIGraphicsImageRenderer(size: size).image {
      _ in UIImage(named: "delete-x")!.withTintColor(.white).draw(in: CGRect(x: imageFrameX, y: imageFrameY, width: imageSize, height: imageSize))
    }
    
    action.backgroundColor = UIColor.LedgrRed()
    let configuration = UISwipeActionsConfiguration(actions: [action])
    configuration.performsFirstActionWithFullSwipe = false
    return configuration
  }
}

extension LogViewController: LogTableViewCellDelegate {
  func editButtonTouched(cell: LogTableViewCell) {
    if let indexPath = tableView.indexPath(for: cell) {
      let section = displayLogs[indexPath.section]
      let log = section.logs[indexPath.row]
      delegate?.createAddLogViewController(editingLog: log)
    }
  }
  
  func deleteButtonTouched(cell: LogTableViewCell) {
    let index = tableView.indexPath(for: cell)
    deleteLogAt(index: index)
  }
}

extension LogViewController: DeleteLogPresenterDelegate {
  func errorDeletingLog(message: String) {
    LedgrErrorHelper.presentErrorAlert(viewController: self, errorMessage: message)
  }
  
  func deletedLogAt(indexPath: IndexPath) {
    tableView.beginUpdates()
    displayLogs[indexPath.section].logs.remove(at: indexPath.row)
    if displayLogs[indexPath.section].logs.count == 0 {
      displayLogs.remove(at: indexPath.section)
      tableView.deleteSections([indexPath.section], with: .middle)
    } else {
      tableView.deleteRows(at: [indexPath], with: .middle)
    }
    tableView.endUpdates()
  }
}

// MARK: RealmLogDelegate
extension LogViewController: DataObserverProtocol {
  func dataUpdated(dataClass: DataUpdateClass, type: DataUpdateType, data: Observable?) {
    logRequestUseCase?.execute(date: selectedDate, categoryId: selectedCategoryId)
  }
}
