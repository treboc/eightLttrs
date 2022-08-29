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
  let wordTextField = BasicTextField()
  let submitButton = UIButton()

  private let foundWordsTitleLabel = UILabel()
  let foundWordsBodyLabel = UILabel()

  private let currentScoreTitleLabel = UILabel()
  let currentScoreBodyLabel = UILabel()

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

    // foundWordsTitleLabel
    foundWordsTitleLabel.textAlignment = .left
    foundWordsTitleLabel.text = L10n.MainView.foundWords
    foundWordsTitleLabel.font = .preferredFont(forTextStyle: .caption1)

    // FoundWordsBodyLabel
    foundWordsBodyLabel.textAlignment = .left
    foundWordsBodyLabel.text = "0 / 0"
    foundWordsBodyLabel.font = .preferredFont(forTextStyle: .headline)
    foundWordsBodyLabel.font = .monospacedDigitSystemFont(ofSize: foundWordsBodyLabel.font.pointSize, weight: .semibold)

    // CurrentScoreTitleLabel
    currentScoreTitleLabel.textAlignment = .right
    currentScoreTitleLabel.text = L10n.MainView.currentScore
    currentScoreTitleLabel.font = .preferredFont(forTextStyle: .caption1)

    // CurrentScoreTitleLabel
    currentScoreBodyLabel.textAlignment = .right
    currentScoreBodyLabel.text = "0 / 0"
    currentScoreBodyLabel.font = .preferredFont(forTextStyle: .headline)
    currentScoreBodyLabel.font = .monospacedDigitSystemFont(ofSize: currentScoreBodyLabel.font.pointSize, weight: .semibold)

    // CollectionView
    let config = UICollectionLayoutListConfiguration(appearance: .plain)
    let layout = UICollectionViewCompositionalLayout.list(using: config)
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  }

  private func setupLayout() {
    let safeArea = self.safeAreaLayoutGuide
    let views = [wordTextField, submitButton, foundWordsTitleLabel, foundWordsBodyLabel, currentScoreTitleLabel, currentScoreBodyLabel, collectionView]
    for view in views {
      guard let view = view else { return }
      self.addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      wordTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.widthPadding),
      wordTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.widthPadding),
      wordTextField.trailingAnchor.constraint(equalTo: submitButton.leadingAnchor, constant: -Constants.widthPadding),
      wordTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

      submitButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.widthPadding),
      submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.widthPadding),
      submitButton.heightAnchor.constraint(equalToConstant: 40),
      submitButton.widthAnchor.constraint(equalTo: submitButton.heightAnchor),

      foundWordsTitleLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 8),
      foundWordsTitleLabel.leadingAnchor.constraint(equalTo: wordTextField.leadingAnchor),
      foundWordsTitleLabel.trailingAnchor.constraint(equalTo: currentScoreTitleLabel.leadingAnchor),

      foundWordsBodyLabel.topAnchor.constraint(equalTo: currentScoreTitleLabel.bottomAnchor),
      foundWordsBodyLabel.leadingAnchor.constraint(equalTo: wordTextField.leadingAnchor),
      foundWordsBodyLabel.trailingAnchor.constraint(equalTo: currentScoreBodyLabel.leadingAnchor),

      currentScoreTitleLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 8),
      currentScoreTitleLabel.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor),

      currentScoreBodyLabel.topAnchor.constraint(equalTo: currentScoreTitleLabel.bottomAnchor),
      currentScoreBodyLabel.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor),

      collectionView.topAnchor.constraint(equalTo: currentScoreBodyLabel.bottomAnchor, constant: 8),
      collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
    ])
  }

  func clearTextField() {
    wordTextField.text?.removeAll()
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

    NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: wordTextField)
      .sink {
        if let charCount = ($0.object as? UITextField)?.text?.count,
           charCount > 8 {
          self.wordTextField.text?.removeLast()
        }
      }
      .store(in: &cancellables)
  }
}
