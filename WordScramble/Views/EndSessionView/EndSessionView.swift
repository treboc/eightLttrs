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

  private let scrollView = UIScrollView()
  private let stackView = UIStackView()

  private let titleLabel = UILabel()
  private let bodyLabel = UILabel()
  private(set) var textField = BasicTextField()
  private(set) var submitButton = UIButton()
  private(set) var cancelButton = UIButton()

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

    // ScrollView
    scrollView.keyboardDismissMode = .onDrag

    // StackView
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 30

    // CongratulationsLabel
    titleLabel.text = L10n.EndSessionView.title
    titleLabel.font = .preferredFont(forTextStyle: .title2)
    titleLabel.font = .boldSystemFont(ofSize: titleLabel.font.pointSize)
    titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

    // DisplayDataLabel
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
    submitButton.setTitle(L10n.ButtonTitle.submit, for: .normal)

    // CancelButton
    var cancelButtonConfig = UIButton.Configuration.tinted()
    cancelButtonConfig.cornerStyle = .large
    cancelButtonConfig.buttonSize = .large
    cancelButton = UIButton(configuration: cancelButtonConfig)
    cancelButton.tintColor = .systemRed
    cancelButton.setTitle(L10n.ButtonTitle.cancel, for: .normal)

    // set last players name and enable button, if not Rnil
    setLastPlayersName()
  }

  private func setupLayout() {
    let views = [titleLabel, bodyLabel, textField, submitButton, cancelButton]
    views.forEach { stackView.addArrangedSubview($0) }

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    stackView.translatesAutoresizingMaskIntoConstraints = false
    textField.translatesAutoresizingMaskIntoConstraints = false

    addSubview(scrollView)
    scrollView.addSubview(stackView)

    NSLayoutConstraint.activate([
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 50),
      scrollView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.bottomAnchor, constant: -50),

      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

      textField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
      textField.heightAnchor.constraint(equalToConstant: 40)
    ])
  }

  private func setLastPlayersName() {
    if let lastName = UserDefaults.standard.string(forKey: UserDefaultsKeys.lastPlayersName) {
      textField.text = lastName
      submitButton.isEnabled = true
    }
  }
}

extension EndSessionView {
  func updateBodyLabel(with word: String, score: Int, wordCount: Int) {
    bodyLabel.text = L10n.Words.count(wordCount) 
    + "\n"
    + L10n.EndSessionView.body(score)
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
  }
}
