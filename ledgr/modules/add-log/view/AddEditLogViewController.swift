//
//  AddLogViewController.swift
//  ledgr
//
//  Created by Caroline on 12/7/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import FormToolbar

class AddEditLogViewController: FormViewController {
  private var categories: [DisplayCategory] = []
  private let amountTextField = UITextField()
  private let titleTextField = UITextField()
  private var extraNotesTextView = UITextView()
  private var collectionViewContainerView = UIView()
  private let collectionViewController: CategoryCollectionViewController
  
  private var addEntityUseCase: AddLogUseCaseProtocol?
  private var requestCategoriesUseCase: RequestCategoriesUseCase?
  
  init(useCase: AddLogUseCaseProtocol) {
    let presenter = RequestCategoriesPresenter()
    requestCategoriesUseCase = RequestCategoriesUseCase(presenter: presenter, displayLog: useCase.editingLog)
    collectionViewController = CategoryCollectionViewController(categories: [])
    super.init(nibName: nil, bundle: nil)
    presenter.delegate = self
    addEntityUseCase = useCase
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    
    DataObserver.shared.addDelegate(delegate: self)

    if let edit = addEntityUseCase?.editingLog {
      displayEditLog(displayLog: edit)
    }
    requestCategoriesUseCase?.execute()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    amountTextField.becomeFirstResponder()
  }
  
  // MARK: View setup
  
  private func setupView() {
    navigationItem.title = "add log"
    setupAddSaveButton()
    setupTextFields()
    setupTextView()
    setupCollection()
    setupToolbar()
  }
  
  private func setupAddSaveButton() {
    addButton.setTitle("add log", for: .normal)
    addButton.addTarget(self, action: #selector(addLogTouched), for: .touchUpInside)
  }
  
  private func setupTextFields() {
    amountTextField.font = UIFont.regularLedgrFont(size: 36)
    amountTextField.autocorrectionType = .no
    amountTextField.delegate = self
    amountTextField.placeholder = "$0.00"
    amountTextField.keyboardType = .decimalPad
    amountTextField.tintColor = UIColor.LedgrCharcoal()
    amountTextField.addTarget(self, action: #selector(amountTextFieldDidChange(_:)), for: .editingChanged)
    
    titleTextField.font = UIFont.regularLedgrFont(size: 22)
    titleTextField.placeholder = "expense name"
    titleTextField.delegate = self
    titleTextField.tintColor = UIColor.LedgrCharcoal()
    titleTextField.autocorrectionType = .no
    
    containerView.addSubview(amountTextField)
    containerView.addSubview(titleTextField)
    amountTextField.snp.makeConstraints { (make) in
      make.top.left.equalToSuperview().offset(20)
      make.right.equalToSuperview().inset(20)
    }
    
    titleTextField.snp.makeConstraints { (make) in
      make.left.right.equalTo(amountTextField)
      make.top.equalTo(amountTextField.snp.bottom).offset(20)
    }
  }
  
  private func setupTextView() {
    extraNotesTextView.font = UIFont.regularLedgrFont(size: 16)
    extraNotesTextView.delegate = self
    extraNotesTextView.text = "extra notes"
    extraNotesTextView.textColor = UIColor.LedgrBubbleGray()
    extraNotesTextView.tintColor = UIColor.LedgrCharcoal()
    extraNotesTextView.layer.cornerRadius = 10
    extraNotesTextView.layer.borderColor = UIColor.LedgrBubbleGray().cgColor
    extraNotesTextView.layer.borderWidth = 1
    containerView.addSubview(extraNotesTextView)
    extraNotesTextView.snp.makeConstraints { (make) in
      make.top.equalTo(titleTextField.snp.bottom).offset(20)
      make.height.equalTo(80)
      make.left.equalToSuperview().offset(20)
      make.right.equalToSuperview().inset(20)
    }
  }
  
  private func setupCollection() {
    containerView.addSubview(collectionViewContainerView)
    collectionViewContainerView.addSubview(collectionViewController.view)
    addChild(collectionViewController)
    collectionViewController.didMove(toParent: self)
    collectionViewContainerView.snp.makeConstraints { (make) in
      make.top.equalTo(extraNotesTextView.snp.bottom).offset(20)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview().inset(FormViewController.addButtonHeight)
    }
    collectionViewController.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupToolbar() {
    toolbar = FormToolbar(inputs: [amountTextField, titleTextField, extraNotesTextView])
    toolbar?.direction = .upDown
  }
  
  private func displayEditLog(displayLog: DisplayLog) {
    amountTextField.text = displayLog.total
    if let title = displayLog.title {
      titleTextField.text = title
    }
    if let notes = displayLog.extraNotes {
      extraNotesTextView.text = notes
      extraNotesTextView.textColor = UIColor.LedgrCharcoal()
    }
    addButton.setTitle("save log", for: .normal)
    navigationItem.title = "edit log"
  }

  // MARK: user interactions
  
  @objc func addLogTouched() {
    let extraNotes: String? = extraNotesTextView.text == "extra notes" ? nil : extraNotesTextView.text
    let request = AddLogRequest(amount: amountTextField.text, title: titleTextField.text, categoryId: collectionViewController.selectedCategoryId, extraNotes: extraNotes)
    addEntityUseCase?.execute(request: request)
  }
}

extension AddEditLogViewController {
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "extra notes"
      textView.textColor = UIColor.LedgrBubbleGray()
    }
  }
}

extension AddEditLogViewController: AddLogPresenterDelegate {
  func errorCreatingLog(errorMessage: String) {
    LedgrErrorHelper.presentErrorAlert(viewController: self, errorMessage: errorMessage)
  }
  
  func finishedCreatingLog() {
    if let nav = navigationController {
      if nav.viewControllers.count > 1 {
        nav.popViewController(animated: true)
      } else {
        dismiss(animated: true, completion: nil)
      }
    }
  }
}

extension AddEditLogViewController: RequestCategoriesPresenterDelegate {
  func display(categoryViewModel: RequestCategoriesViewModel) {
    categories = categoryViewModel.categories
    collectionViewController.update(categories: categories)
  }
}

// MARK: RealmLogDelegate
extension AddEditLogViewController: DataObserverProtocol {
  func dataUpdated(dataClass: DataUpdateClass, type: DataUpdateType, data: Observable?) {
    switch dataClass {
    case .category:
      requestCategoriesUseCase?.execute()
      if type == .added, let cat = data as? Category {
        let selectedCat = categories.first { (dc) -> Bool in
          dc.categoryId == cat.objectId
        }
        selectedCat?.selected = true
        collectionViewController.update(categories: categories)
      }
    default: break
    }
  }
}

