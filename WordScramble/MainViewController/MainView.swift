//
//  MainView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 14.08.22.
//

import Combine
import UIKit

class MainView: UIView {
  // MARK: - NotificationCenter Publishers
  var cancellables = Set<AnyCancellable>()

  // MARK: - Views
  lazy var wordTextField: UITextField = {
    let tf = UITextField()
    tf.layer.cornerRadius = 5
    tf.layer.borderWidth = 1
    tf.layer.borderColor = UIColor.lightGray.cgColor
    tf.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
    tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
    tf.leftViewMode = .always
    tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: tf.frame.height))
    tf.rightViewMode = .unlessEditing
    tf.clearButtonMode = .whileEditing
    tf.keyboardType = .default
    tf.autocorrectionType = .no
    tf.returnKeyType = .send
    tf.becomeFirstResponder()
    return tf
  }()

  lazy var submitButton: UIButton = {
    let btn = UIButton()
    btn.configuration = .borderedProminent()
    btn.isEnabled = false
    let imageConf = UIImage.SymbolConfiguration(textStyle: .caption1)
    let plusImage = UIImage(systemName: "plus", withConfiguration: imageConf)!
    btn.setImage(plusImage, for: .normal)
    return btn
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(WordTableViewCell.self, forCellReuseIdentifier: WordTableViewCell.identifier)
    return tableView
  }()

  // MARK: - init()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .systemBackground
    setupLayout()
    setupPublishers()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setting up Layout
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
      wordTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.widthPadding),
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

// MARK: - Setting up publishers
extension MainView {
  // Observing the textField's text, to determine if the button should be enabled
  fileprivate func setupPublishers() {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: wordTextField)
      .map { !(($0.object as? UITextField)?.text?.isEmpty ?? false) }
      .assign(to: \MainView.submitButton.isEnabled, on: self)
      .store(in: &cancellables)
  }
}
