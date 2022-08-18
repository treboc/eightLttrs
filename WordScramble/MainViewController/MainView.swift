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
    tf.backgroundColor = .secondarySystemBackground
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
    var configuration = UIButton.Configuration.borderedProminent()
    configuration.baseForegroundColor = .systemBackground
    btn.configuration = configuration
    btn.isEnabled = false
    let imageConf = UIImage.SymbolConfiguration(pointSize: 12)
    let plusImage = UIImage(systemName: "plus", withConfiguration: imageConf)!
    plusImage.withTintColor(.label, renderingMode: .automatic)
    btn.setImage(plusImage, for: .normal)
    return btn
  }()

  lazy var scoreTextLabel: UILabel = {
    let lbl = UILabel()
    lbl.textAlignment = .right
    lbl.text = L10n.MainView.currentScore
    lbl.font = .preferredFont(forTextStyle: .subheadline)
    return lbl
  }()

  lazy var scorePointsLabel: UILabel = {
    let lbl = UILabel()
    lbl.textAlignment = .right
    lbl.text = "0"
    lbl.font = .preferredFont(forTextStyle: .headline)
    lbl.font = .monospacedDigitSystemFont(ofSize: lbl.font.pointSize, weight: .semibold)
    return lbl
  }()

  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(WordTableViewCell.self, forCellReuseIdentifier: WordTableViewCell.identifier)
    tableView.separatorColor = .systemOrange
    tableView.keyboardDismissMode = .interactiveWithAccessory
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
    let views = [wordTextField, submitButton, scoreTextLabel, scorePointsLabel, tableView]
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
      submitButton.heightAnchor.constraint(equalToConstant: 40),
      submitButton.widthAnchor.constraint(equalTo: submitButton.heightAnchor),

      scoreTextLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 8),
      scoreTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.widthPadding),
      scoreTextLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
      scoreTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

      scorePointsLabel.topAnchor.constraint(equalTo: scoreTextLabel.bottomAnchor),
      scorePointsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.widthPadding),
      scorePointsLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
      scorePointsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

      tableView.topAnchor.constraint(equalTo: scorePointsLabel.bottomAnchor),
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
