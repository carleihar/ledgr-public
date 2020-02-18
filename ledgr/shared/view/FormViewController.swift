//
//  FormViewController.swift
//  ledgr
//
//  Created by Caroline on 1/12/20.
//  Copyright © 2020 carleihar. All rights reserved.
//

import Foundation
import UIKit
import FormToolbar

class FormViewController: UIViewController {
  static let addButtonHeight: CGFloat = 54
  let addButton = UIButton()
  var toolbar: FormToolbar?
  let containerView = UIView()
  
  private let scrollView = UIScrollView()
  private var selectedTextField: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    subscribe()
    setupView()
  }
  
  deinit {
    unsubscribe()
  }
  
  private func setupView() {
    view.backgroundColor = .white
    view.addSubview(scrollView)
    
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
    
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.addSubview(containerView)
    scrollView.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(view.safeAreaLayoutGuide)
      make.left.right.width.equalToSuperview()
    }
    
    containerView.snp.makeConstraints { (make) in
      make.edges.centerX.equalToSuperview()
    }
    
    setupAddLogButton()
  }
  
  private func setupAddLogButton() {
    view.addSubview(addButton)
    addButton.titleLabel?.font = UIFont.boldLedgrFont(size: 18)
    addButton.backgroundColor = UIColor.LedgrCharcoal()
    addButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(view.safeAreaLayoutGuide)
      make.left.right.equalToSuperview()
      make.height.equalTo(FormViewController.addButtonHeight)
    }
    let blackBottom = UIView()
    blackBottom.backgroundColor = UIColor.LedgrCharcoal()
    view.addSubview(blackBottom)
    blackBottom.snp.makeConstraints { (make) in
      make.left.right.bottom.equalToSuperview()
      make.top.equalTo(addButton.snp.bottom)
    }
  }
  
  // MARK: Keyboard
  private func setupKeyboard() {
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
    tapGesture.cancelsTouchesInView = false
    self.scrollView.addGestureRecognizer(tapGesture)
    subscribe()
  }
  
  private func subscribe() {
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func unsubscribe() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
    selectedTextField = nil
    view.endEditing(true)
  }
  
  @objc func keyboardWillShow(notification: NSNotification) {
    let window = UIApplication.shared.keyWindow
    let bottomPadding = window?.safeAreaInsets.bottom ?? 0
    
    let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    let keyboardHeight = keyboardSize.height
    
    var contentInset = self.scrollView.contentInset
    contentInset.bottom = keyboardHeight + 100
    scrollView.contentInset = contentInset
    
    if let selected = selectedTextField {
      let rect = scrollView.convert(selected.bounds, from: selected)
      scrollView.scrollRectToVisible(rect, animated: true)
    }
    
    addButton.snp.remakeConstraints { (make) in
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(keyboardHeight - bottomPadding)
      make.left.right.equalToSuperview()
      make.height.equalTo(44)
    }
    UIView.animate(withDuration: 0.2) {
      self.view.layoutIfNeeded()
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    scrollView.contentInset = .zero
    addButton.snp.remakeConstraints { (make) in
      make.bottom.equalTo(view.safeAreaLayoutGuide)
      make.left.right.equalToSuperview()
      make.height.equalTo(44)
    }
    UIView.animate(withDuration: 0.2) {
      self.view.layoutIfNeeded()
    }
  }
}

extension FormViewController: UITextFieldDelegate, UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    toolbar?.update()
    selectedTextField = textView
    if textView.textColor == UIColor.LedgrBubbleGray() {
      textView.text = nil
      textView.textColor = UIColor.LedgrCharcoal()
    }
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    selectedTextField = textField
  }
  
  @objc func amountTextFieldDidChange(_ textField: UITextField) {
    if let amountString = textField.text?.currencyInputFormatting() {
      textField.text = amountString
    }
  }
}
