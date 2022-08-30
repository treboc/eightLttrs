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
  let textField = BasicTextField()
  let submitButton = UIButton()

  private let numberOfWordsTitleLabel = UILabel()
  let numberOfWordsBodyLabel = UILabel()

  private let currentScoreTitleLabel = UILabel()
  let currentScoreBodyLabel = UILabel()

  let divider = Divider(height: 3)

  private(set) var collectionView: UICollectionView!

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
    // Submit Button
    var configuration = UIButton.Configuration.borderedProminent()
    configuration.baseForegroundColor = .systemBackground
    submitButton.configuration = configuration
    submitButton.isEnabled = false
    let imageConf = UIImage.SymbolConfiguration(pointSize: 12)
    let plusImage = UIImage(systemName: "plus", withConfiguration: imageConf)!
    plusImage.withTintColor(.label, renderingMode: .automatic)
    submitButton.setImage(plusImage, for: .normal)

    // NumberOfWordsTitleLabel
    numberOfWordsTitleLabel.textAlignment = .left
    numberOfWordsTitleLabel.text = L10n.MainView.foundWords
    numberOfWordsTitleLabel.font = .preferredFont(forTextStyle: .caption1)
    numberOfWordsTitleLabel.textColor = .secondaryLabel

    // NumberOfWordsBodyLabel
    numberOfWordsBodyLabel.textAlignment = .left
    numberOfWordsBodyLabel.text = "0 / 0"
    numberOfWordsBodyLabel.font = .preferredFont(forTextStyle: .subheadline)
    numberOfWordsBodyLabel.font = .monospacedDigitSystemFont(ofSize: numberOfWordsBodyLabel.font.pointSize, weight: .semibold)

    // CurrentScoreTitleLabel
    currentScoreTitleLabel.textAlignment = .right
    currentScoreTitleLabel.text = L10n.MainView.currentScore
    currentScoreTitleLabel.font = .preferredFont(forTextStyle: .caption1)
    currentScoreTitleLabel.textColor = .secondaryLabel

    // CurrentScoreTitleLabel
    currentScoreBodyLabel.textAlignment = .right
    currentScoreBodyLabel.text = "0 / 0"
    currentScoreBodyLabel.font = .preferredFont(forTextStyle: .subheadline)
    currentScoreBodyLabel.font = .monospacedDigitSystemFont(ofSize: currentScoreBodyLabel.font.pointSize, weight: .semibold)

    // CollectionView
    let config = UICollectionLayoutListConfiguration(appearance: .plain)
    let layout = UICollectionViewCompositionalLayout.list(using: config)
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  }

  private func setupLayout() {
    let safeArea = self.safeAreaLayoutGuide
    let views = [textField, submitButton, numberOfWordsTitleLabel, numberOfWordsBodyLabel, currentScoreTitleLabel, currentScoreBodyLabel, divider, collectionView]
    for view in views {
      guard let view = view else { return }
      self.addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      textField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.widthPadding),
      textField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.widthPadding),
      textField.trailingAnchor.constraint(equalTo: submitButton.leadingAnchor, constant: -Constants.widthPadding),
      textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

      submitButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.widthPadding),
      submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.widthPadding),
      submitButton.heightAnchor.constraint(equalToConstant: 40),
      submitButton.widthAnchor.constraint(equalTo: submitButton.heightAnchor),

      numberOfWordsTitleLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 8),
      numberOfWordsTitleLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
      numberOfWordsTitleLabel.trailingAnchor.constraint(equalTo: currentScoreTitleLabel.leadingAnchor),

      numberOfWordsBodyLabel.topAnchor.constraint(equalTo: currentScoreTitleLabel.bottomAnchor),
      numberOfWordsBodyLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
      numberOfWordsBodyLabel.trailingAnchor.constraint(equalTo: currentScoreBodyLabel.leadingAnchor),

      currentScoreTitleLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 8),
      currentScoreTitleLabel.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor),

      currentScoreBodyLabel.topAnchor.constraint(equalTo: currentScoreTitleLabel.bottomAnchor),
      currentScoreBodyLabel.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor),

      divider.topAnchor.constraint(equalTo: currentScoreBodyLabel.bottomAnchor, constant: 8),
      divider.widthAnchor.constraint(equalTo: widthAnchor),
      divider.centerXAnchor.constraint(equalTo: centerXAnchor),
      divider.heightAnchor.constraint(equalToConstant: 3),

      collectionView.topAnchor.constraint(equalTo: divider.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }

  func clearTextField() {
    textField.text?.removeAll()
  }
}

// MARK: - Setting up publishers
extension MainView {
  // Observing the textField's text, to determine if the button should be enabled
  fileprivate func setupPublishers() {
    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: textField)
      .map { !(($0.object as? UITextField)?.text?.isEmpty ?? false) }
      .assign(to: \MainView.submitButton.isEnabled, on: self)
      .store(in: &cancellables)

    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: textField)
      .sink {
        if let charCount = ($0.object as? UITextField)?.text?.count,
           charCount > 8 {
          self.textField.text?.removeLast()
        }
      }
      .store(in: &cancellables)
  }
}
