//
//  MainView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 14.08.22.
//

import UIKit

class MainView: UIView {
  lazy var wordTextField: UITextField = {
    let tf = UITextField()
    tf.layer.cornerRadius = 5
    tf.layer.borderWidth = 1
    tf.layer.borderColor = UIColor.lightGray.cgColor
    tf.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
    tf.leftViewMode = .always
    tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
    tf.rightViewMode = .unlessEditing
    tf.clearButtonMode = .whileEditing
    tf.keyboardType = .default
    tf.autocorrectionType = .no
    tf.returnKeyType = .send
    return tf
  }()

  lazy var submitButton: UIButton = {
    let btn = UIButton()
    btn.configuration = .borderedProminent()
    btn.setTitle("+", for: .normal)
    return btn
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(WordTableViewCell.self, forCellReuseIdentifier: WordTableViewCell.identifier)
    return tableView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .systemBackground
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MainView {
  func setupLayout() {
    let safeArea = self.safeAreaLayoutGuide
    let views = [wordTextField, submitButton, tableView]
    for view in views {
      self.addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      wordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.widthPadding),
      wordTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 12),
      wordTextField.trailingAnchor.constraint(equalTo: submitButton.leadingAnchor, constant: -Constants.widthPadding),
      wordTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

      submitButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.widthPadding),
      submitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.widthPadding),
      submitButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
      submitButton.widthAnchor.constraint(equalTo: submitButton.heightAnchor),

      tableView.topAnchor.constraint(equalTo: wordTextField.bottomAnchor, constant: 12),
      tableView.widthAnchor.constraint(equalTo: widthAnchor),
      tableView.centerXAnchor.constraint(equalTo: centerXAnchor),
      tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }
}
