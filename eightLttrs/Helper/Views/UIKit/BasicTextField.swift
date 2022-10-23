//
//  BasicTextField.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 22.08.22.
//

import UIKit

class BasicTextField: UITextField {
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.layer.cornerRadius = 5
    self.backgroundColor = .secondarySystemBackground
    self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftViewMode = .always
    self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.rightViewMode = .unlessEditing
    self.clearButtonMode = .whileEditing
    self.textContentType = .nickname
    self.spellCheckingType = .no
    self.autocorrectionType = .no
    self.returnKeyType = .send
    self.becomeFirstResponder()
    self.autocapitalizationType = .allCharacters
  }

  // Disable pasting
  override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
    if action == #selector(UIResponderStandardEditActions.paste) {
      return false
    }
    return super.canPerformAction(action, withSender: sender)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
