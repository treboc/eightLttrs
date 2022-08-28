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
  private let scoreTextLabel = UILabel()
  let scorePointsLabel = UILabel()
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
    // CollectionView
    let config = UICollectionLayoutListConfiguration(appearance: .plain)
    let layout = UICollectionViewCompositionalLayout.list(using: config)

    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    // WordTextField
    wordTextField.autocapitalizationType = .none

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
    scoreTextLabel.font = .preferredFont(forTextStyle: .caption1)

    // ScorePointsLabel
    scorePointsLabel.textAlignment = .right
    scorePointsLabel.text = "0"
    scorePointsLabel.font = .preferredFont(forTextStyle: .headline)
    scorePointsLabel.font = .monospacedDigitSystemFont(ofSize: scorePointsLabel.font.pointSize, weight: .semibold)
  }

  private func setupLayout() {
    let safeArea = self.safeAreaLayoutGuide
    let views = [wordTextField, submitButton, scoreTextLabel, scorePointsLabel, collectionView]
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

      scoreTextLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 8),
      scoreTextLabel.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor),
      scoreTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

      scorePointsLabel.topAnchor.constraint(equalTo: scoreTextLabel.bottomAnchor),
      scorePointsLabel.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor),
      scorePointsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),

      collectionView.topAnchor.constraint(equalTo: scorePointsLabel.bottomAnchor),
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
