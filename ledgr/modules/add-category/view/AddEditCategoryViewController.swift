//
//  AddEditCategoryViewController.swift
//  ledgr
//
//  Created by Caroline on 1/12/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import UIKit
import FormToolbar
import FirebaseCrashlytics

class AddEditCategoryViewController: FormViewController {
  private let titleTextField = UITextField()
  private let totalTextField = UITextField()
  private let budgetLabel = UILabel.createRegularLabel(text: "budget per", size: 16)
  private var buttons: [UIButton] = []
  private var categoryCollectionViewContainerView = UIView()
  private let categoryCollectionViewController: CategoryCollectionViewController
  private var categoryColorCollectionViewContainerView = UIView()
  private let categoryColorViewController: CategoryColorPickerViewController
  
  private var selectedBudgetTimeRangeMenu: BudgetTimeRangeMenu = .month
  
  private var visualPresenter = AddCategoryVisualPresenter()
  private var addEditCategoryUseCase: AddCategoryUseCaseProtocol?
  private var addCategoryUseCase: AddCategoryUseCaseProtocol?
  
  init(useCase: AddCategoryUseCaseProtocol) {
    addCategoryUseCase = useCase
    categoryCollectionViewController = CategoryCollectionViewController(categories: [], categoryTitleLabelText: "")
    categoryColorViewController = CategoryColorPickerViewController()
    super.init(nibName: nil, bundle: nil)
    categoryColorViewController.delegate = self
    categoryCollectionViewController.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    if let edit = addCategoryUseCase?.editingDisplayCategory {
      display(editCategory: edit)
    }
    visualPresenter.delegate = self
    visualPresenter.setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    categoryColorViewController.view.layoutIfNeeded()
    titleTextField.becomeFirstResponder()
  }
  
  // MARK: User Events
  
  @objc func buttonTouched() {
    let request = AddCategoryRequest(budget: totalTextField.text, budgetTimeRange: selectedBudgetTimeRangeMenu, name: titleTextField.text, iconName: visualPresenter.selectedIcon ?? "apple", hexColor: visualPresenter.selectedColor ?? "#FFFFFF")
    addCategoryUseCase?.execute(request: request)
  }
  
  @objc func deleteCategory() {
    if let cat = addCategoryUseCase?.editingDisplayCategory {
      let presenter = DeleteCategoryPresenter()
      let useCase = DeleteCategoryUseCase(presenter: presenter)
      presenter.delegate = self
      useCase.execute(displayCategory: cat)
    } else {
      errorCreatingCategory(errorMessage: LedgrErrorHelper.createGenericErrorMessage())
      Crashlytics.crashlytics().record(error: NSError(domain: "ledgr.AddEditCategoryViewControllerError", code: 1, userInfo: nil))
    }
  }
  
  // MARK: View setup
  
  private func setupView() {
    navigationItem.title = "add category"
    setupAddSaveButton()
    setupTextFields()
    setupColorCollectionView()
    setupCollection()
    setupToolbar()
    setBudgetButton(selected: true, rangeMenu: .month)
  }
  
  private func setupAddSaveButton() {
    addButton.setTitle("create category", for: .normal)
    addButton.addTarget(self, action: #selector(buttonTouched), for: .touchUpInside)
  }
  
  private func setupTextFields() {
    titleTextField.font = UIFont.regularLedgrFont(size: 36)
    titleTextField.placeholder = "name"
    titleTextField.delegate = self
    titleTextField.tintColor = UIColor.LedgrCharcoal()
    titleTextField.autocorrectionType = .no
    
    totalTextField.font = UIFont.regularLedgrFont(size: 26)
    totalTextField.autocorrectionType = .no
    totalTextField.delegate = self
    totalTextField.placeholder = "$0.00"
    totalTextField.keyboardType = .decimalPad
    totalTextField.tintColor = UIColor.LedgrCharcoal()
    totalTextField.addTarget(self, action: #selector(amountTextFieldDidChange(_:)), for: .editingChanged)

    containerView.addSubview(titleTextField)
    containerView.addSubview(totalTextField)
    
    titleTextField.snp.makeConstraints { (make) in
      make.top.left.equalToSuperview().offset(20)
      make.right.equalToSuperview().inset(20)
    }
    
//    setupBudgetStackview()
  }
  
  private func setupBudgetStackview() {
    let stackView = UIStackView()
    stackView.backgroundColor = .blue
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.spacing = 5
    containerView.addSubview(stackView)
    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(titleTextField.snp.bottom).offset(20)
      make.left.equalTo(titleTextField)
      make.right.lessThanOrEqualToSuperview()
    }
    
    stackView.addArrangedSubview(budgetLabel)
    for budget in BudgetTimeRangeMenu.allCases {
      let button = UIButton()
      button.titleLabel?.font = UIFont.regularLedgrFont(size: 14)
      button.setTitleColor(UIColor.LedgrBubbleGray(), for: .normal)
      button.setTitle(budget.rawValue, for: .normal)
      button.addTarget(self, action: #selector(setBudgetConstraint), for: .touchUpInside)
      button.layer.cornerRadius = 8
      let padding: CGFloat = 8
      button.titleEdgeInsets = UIEdgeInsets(top: padding, left: padding, bottom: -padding, right: -padding)
      button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 0, bottom: padding * 2, right: padding * 2)
      stackView.addArrangedSubview(button)
      buttons.append(button)
    }

    totalTextField.snp.makeConstraints { (make) in
      make.top.equalTo(stackView.snp.bottom).offset(5)
      make.left.right.equalTo(titleTextField)
    }
  }
  
  private func setupColorCollectionView() {
    containerView.addSubview(categoryColorCollectionViewContainerView)
    categoryColorCollectionViewContainerView.addSubview(categoryColorViewController.view)
    addChild(categoryColorViewController)
    categoryColorCollectionViewContainerView.backgroundColor = .blue
    categoryColorViewController.view.backgroundColor = .red
    categoryColorViewController.didMove(toParent: self)
    categoryColorCollectionViewContainerView.snp.makeConstraints { (make) in
      make.top.equalTo(titleTextField.snp.bottom).offset(20)
      make.left.right.equalToSuperview()
      make.height.equalTo(ColorCollectionViewCell.ColorCollectionViewCellHeight)
    }
    categoryColorViewController.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupCollection() {
    containerView.addSubview(categoryCollectionViewContainerView)
    categoryCollectionViewContainerView.addSubview(categoryCollectionViewController.view)
    addChild(categoryCollectionViewController)
    categoryCollectionViewController.didMove(toParent: self)
    categoryCollectionViewContainerView.snp.makeConstraints { (make) in
      make.top.equalTo(categoryColorCollectionViewContainerView.snp.bottom).offset(10)
      make.left.right.equalToSuperview()
      make.bottom.equalToSuperview().inset(FormViewController.addButtonHeight)
    }
    categoryCollectionViewController.view.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  @objc private func setBudgetConstraint(button: UIButton) {
    for b in buttons {
      setBudgetButton(selected: false, button: b)
    }
    setBudgetButton(selected: true, button: button)
  }
  
  private func setBudgetButton(selected: Bool, button: UIButton? = nil, rangeMenu: BudgetTimeRangeMenu? = nil) {
    let b = buttons.filter { (b) -> Bool in
      b.titleLabel?.text == rangeMenu?.rawValue
    }.first ?? button ?? UIButton()
    if selected {
      selectedBudgetTimeRangeMenu = BudgetTimeRangeMenu(rawValue: b.titleLabel?.text ?? "month") ?? .month
      b.backgroundColor = UIColor.LedgrBubbleGray()
      b.setTitleColor(UIColor.LedgrDarkGray(), for: .normal)
    } else {
      b.backgroundColor = .clear
      b.setTitleColor(UIColor.LedgrBubbleGray(), for: .normal)
    }
  }
  
  private func setupToolbar() {
    toolbar = FormToolbar(inputs: [titleTextField, totalTextField])
    toolbar?.direction = .upDown
  }
  
  private func display(editCategory: DisplayCategory) {
    navigationItem.title = "edit category"
    addButton.setTitle("save", for: .normal)
    titleTextField.text = editCategory.title
    visualPresenter.selected(category: editCategory)
    visualPresenter.selected(color: editCategory.hexColor)
    setupTrashIcon()
  }
  
  private func setupTrashIcon() {
    let menuBtn = UIButton(type: .custom)
    menuBtn.frame = CGRect(x: 0.0, y: 0.0, width: 20, height: 20)
    menuBtn.setImage(UIImage(named:"trash"), for: .normal)
    menuBtn.addTarget(self, action: #selector(deleteCategory), for: UIControl.Event.touchUpInside)

    let menuBarItem = UIBarButtonItem(customView: menuBtn)
    let currWidth = menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24)
    currWidth?.isActive = true
    let currHeight = menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24)
    currHeight?.isActive = true
    self.navigationItem.rightBarButtonItem = menuBarItem
  }
}

extension AddEditCategoryViewController: AddCategoryVisualPresenterDelegate {
  func display(categories: [DisplayCategory], colors: [DisplayCategoryColor]) {
    categoryCollectionViewController.update(categories: categories)
    categoryColorViewController.set(colors: colors)
  }
}

extension AddEditCategoryViewController: CategoryColorPickerViewControllerDelegate {
  func colorSelected(hex: String) {
    visualPresenter.selected(color: hex)
  }
}

extension AddEditCategoryViewController: CategoryCollectionViewControllerDelegate {
  func selected(category: DisplayCategory) {
    visualPresenter.selected(category: category)
  }
}

extension AddEditCategoryViewController: AddCategoryPresenterDelegate {
  func errorCreatingCategory(errorMessage: String) {
    LedgrErrorHelper.presentErrorAlert(viewController: self, errorMessage: errorMessage)
  }
  
  func finishedCreatingCategory() {
    if let nav = navigationController {
      if nav.viewControllers.count > 1 {
        nav.popViewController(animated: true)
      } else {
        dismiss(animated: true, completion: nil)
      }
    }
  }
}

extension AddEditCategoryViewController: DeleteCategoryPresenterDelegate {
  func succesfullyDeletedCategory() {
    dismiss(animated: true, completion: nil)
  }
  
  func categoryDeletion(errorMessage: String) {
    LedgrErrorHelper.presentErrorAlert(viewController: self, errorMessage: errorMessage)
  }
}
