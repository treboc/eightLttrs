//
//  EndSessionView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//

import Combine
import UIKit

class EndSessionView: UIView {
  /*
   
   Needed Views / Layout Ideas
   1. - Label for "Cogratulations! 🎉"
   2. - Label below the first label, showing: current word, reached score and maybe number of found words
   3. - textfield for name input
   4. - button to submit score
   -> after that, maybe an alert showing success of saving and giving possibility to share saved score

   */

  private var cancellables = Set<AnyCancellable>()

  private let stackView = UIStackView()

  private let titleLabel = UILabel()
  private let bodyLabel = UILabel()
  private let textField = BasicTextField()
  private var submitButton = UIButton()
  private var cancelButton = UIButton()
  private(set) var textFieldText: String = ""

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayout()

    setupTextFieldPublisher()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension EndSessionView {
  private func setupViews() {
    self.backgroundColor = .systemBackground

    // StackView
    stackView.alignment = .center
    stackView.axis = .vertical
    stackView.spacing = 30
    stackView.distribution = .fill

    // CongratulationsLabel
    titleLabel.text = "Congratulations! 🎉"
    titleLabel.font = .preferredFont(forTextStyle: .title2)
    titleLabel.font = .boldSystemFont(ofSize: titleLabel.font.pointSize)
    titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

    // DisplayDataLabel
    bodyLabel.text = "Plcaceholder\nLorem ipsum"
    bodyLabel.font = .preferredFont(forTextStyle: .body)
    bodyLabel.textColor = .secondaryLabel
    bodyLabel.numberOfLines = 0
    bodyLabel.textAlignment = .center
    bodyLabel.setContentHuggingPriority(.defaultLow, for: .vertical)

    // TextField
    textField.placeholder = "Name"

    // SubmitButton
    var submitButtonConfig = UIButton.Configuration.borderedProminent()
    submitButtonConfig.cornerStyle = .large
    submitButtonConfig.buttonSize = .large
    submitButton = UIButton(configuration: submitButtonConfig)
    submitButton.isEnabled = false
    submitButton.setTitle("Submit Score!", for: .normal)

    // CancelButton
    var cancelButtonConfig = UIButton.Configuration.tinted()
    cancelButtonConfig.cornerStyle = .large
    cancelButtonConfig.buttonSize = .large
    cancelButton = UIButton(configuration: cancelButtonConfig)
    cancelButton.tintColor = .systemRed
    cancelButton.setTitle("Cancel", for: .normal)
  }

  private func setupLayout() {
    let views = [titleLabel, bodyLabel, textField, submitButton, cancelButton]
    views.forEach { stackView.addArrangedSubview($0) }

    textField.translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
      stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),

      textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
      textField.heightAnchor.constraint(equalToConstant: 40)
    ])
  }
}

extension EndSessionView {
  func updateBodyLabel(with word: String, score: Int, wordCount: Int) {
    bodyLabel.text = "Hooray!" + "\n\n" + "That scores with \(score) points!"
  }
}

// MARK: - Setting up publishers
extension EndSessionView {
  // Observing the textField's text, to determine if the button should be enabled
  fileprivate func setupTextFieldPublisher() {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: textField)
      .map { !(($0.object as? UITextField)?.text?.isEmpty ?? false) }
      .assign(to: \EndSessionView.submitButton.isEnabled, on: self)
      .store(in: &cancellables)

    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: textField)
      .map { ($0.object as? UITextField)?.text ?? "Unknown" }
      .assign(to: \EndSessionView.textFieldText, on: self)
      .store(in: &cancellables)
  }
}
