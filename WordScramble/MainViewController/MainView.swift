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
  let wordTextField = UITextField()
  let submitButton = UIButton()
  private let scoreTextLabel = UILabel()
  let scorePointsLabel = UILabel()
  let tableView = UITableView()

  // MARK: - init()
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .systemBackground
    setupViews()
    setupLayout()
    setupPublishers()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Setting up Layout
extension MainView {
  private func setupViews() {
    // WordTextField
    wordTextField.layer.cornerRadius = 5
    wordTextField.backgroundColor = .secondarySystemBackground
    wordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: wordTextField.frame.height))
    wordTextField.leftViewMode = .always
    wordTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: wordTextField.frame.height))
    wordTextField.rightViewMode = .unlessEditing
    wordTextField.clearButtonMode = .whileEditing
    wordTextField.keyboardType = .default
    wordTextField.autocorrectionType = .no
    wordTextField.returnKeyType = .send
    wordTextField.becomeFirstResponder()

    // Submit Button
    var configuration = UIButton.Configuration.borderedProminent()
    configuration.baseForegroundColor = .systemBackground
    submitButton.configuration = configuration
    submitButton.isEnabled = false
    let imageConf = UIImage.SymbolConfiguration(pointSize: 12)
    let plusImage = UIImage(systemName: "plus", withConfiguration: imageConf)!
    plusImage.withTintColor(.label, renderingMode: .automatic)
    submitButton.setImage(plusImage, for: .normal)

    // ScoreTextLabel
    scoreTextLabel.textAlignment = .right
    scoreTextLabel.text = L10n.MainView.currentScore
    scoreTextLabel.font = .preferredFont(forTextStyle: .subheadline)

    // ScorePointsLabel
    scorePointsLabel.textAlignment = .right
    scorePointsLabel.text = "0"
    scorePointsLabel.font = .preferredFont(forTextStyle: .headline)
    scorePointsLabel.font = .monospacedDigitSystemFont(ofSize: scoreTextLabel.font.pointSize, weight: .semibold)

    // UsedWordsTableView
    tableView.separatorColor = .systemOrange
    tableView.keyboardDismissMode = .interactiveWithAccessory
  }

  private func setupLayout() {
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
