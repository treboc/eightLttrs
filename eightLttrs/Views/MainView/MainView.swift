//
//  MainView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 14.08.22.
//

import Combine
import UIKit
import SwiftUI

class MainView: UIView {
  var cancellables = Set<AnyCancellable>()

  let coinsDisplayView = UIView()
  var coinsDisplayTopAnchor: NSLayoutConstraint?

  let shopButton = UIButton()
  var shopButtonTrailingAnchor: NSLayoutConstraint?

  let resetButton = UIButton()
  var resetButtonTopAnchor: NSLayoutConstraint?

  let menuButton = UIButton()
  var menuButtonTopAnchor: NSLayoutConstraint?

  let basewordLabel = UILabel()

  let textField = BasicTextField()
  let submitButton = UIButton()

  private let numberOfWordsTitleLabel = UILabel()
  let numberOfWordsBodyLabel = UILabel()

  private let currentScoreTitleLabel = UILabel()
  let currentScoreBodyLabel = UILabel()

  let divider = UIKitDivider(height: 3)

  private(set) var collectionView: UICollectionView!

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .systemBackground
    AppearanceManager.shared.setAppearance()

    setupViews()
    setupLayout()
    setupPublishers()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MainView {
  private func setupViews() {
    let semiBoldFont = UIFont.monospacedDigitSystemFont(ofSize: 15, weight: .semibold)
    let buttonConfig = UIImage.SymbolConfiguration(textStyle: .title3, scale: .large)

    let shopButtonConfig = UIImage.SymbolConfiguration(textStyle: .largeTitle, scale: .large)
    let shopButtonImage = UIImage(systemName: "bag.circle.fill", withConfiguration: shopButtonConfig)
    shopButton.setImage(shopButtonImage, for: .normal)

    let resetButtonImage = UIImage(systemName: "arrow.counterclockwise.circle.fill", withConfiguration: buttonConfig)
    resetButton.setImage(resetButtonImage, for: .normal)
    resetButton.accessibilityLabel = L10n.MenuView.restartSession

    let menuButtonImage = UIImage(systemName: "line.3.horizontal.circle.fill", withConfiguration: buttonConfig)
    menuButton.setImage(menuButtonImage, for: .normal)
    menuButton.accessibilityLabel = L10n.MenuView.title

    basewordLabel.font = .baseword()
    basewordLabel.textAlignment = .center
    basewordLabel.textColor = .label
    basewordLabel.adjustsFontForContentSizeCategory = true

    var submitBtnConf = UIButton.Configuration.borderedProminent()
    submitBtnConf.baseForegroundColor = .systemBackground
    submitButton.configuration = submitBtnConf
    submitButton.isEnabled = false
    let imageConf = UIImage.SymbolConfiguration(pointSize: 12)
    if let plusImage = UIImage(systemName: "plus", withConfiguration: imageConf) {
      plusImage.withTintColor(.label, renderingMode: .automatic)
      submitButton.setImage(plusImage, for: .normal)
    }

    numberOfWordsTitleLabel.textAlignment = .left
    numberOfWordsTitleLabel.text = L10n.MainView.foundWords
    numberOfWordsTitleLabel.numberOfLines = 0
    numberOfWordsTitleLabel.lineBreakMode = .byWordWrapping
    numberOfWordsTitleLabel.font = .preferredFont(forTextStyle: .caption1)
    numberOfWordsTitleLabel.textColor = .secondaryLabel
    numberOfWordsTitleLabel.adjustsFontForContentSizeCategory = true

    numberOfWordsBodyLabel.textAlignment = .left
    numberOfWordsBodyLabel.text = "0 / 0"
    numberOfWordsBodyLabel.adjustsFontForContentSizeCategory = true
    numberOfWordsBodyLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: semiBoldFont)

    currentScoreTitleLabel.textAlignment = .right
    currentScoreTitleLabel.text = L10n.MainView.currentScore
    currentScoreTitleLabel.numberOfLines = 0
    currentScoreTitleLabel.lineBreakMode = .byWordWrapping
    currentScoreTitleLabel.font = .preferredFont(forTextStyle: .caption1)
    currentScoreTitleLabel.textColor = .secondaryLabel
    currentScoreTitleLabel.adjustsFontForContentSizeCategory = true

    currentScoreBodyLabel.textAlignment = .right
    currentScoreBodyLabel.text = "0 / 0"
    currentScoreBodyLabel.adjustsFontForContentSizeCategory = true
    currentScoreBodyLabel.font = UIFontMetrics(forTextStyle: .subheadline).scaledFont(for: semiBoldFont)

    let collectionViewConfig = UICollectionLayoutListConfiguration(appearance: .plain)
    let layout = UICollectionViewCompositionalLayout.list(using: collectionViewConfig)
    self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

    // Accessibility
    numberOfWordsTitleLabel.accessibilityElementsHidden = true
    currentScoreTitleLabel.accessibilityElementsHidden = true
  }

  private func setupLayout() {
    let safeArea = self.safeAreaLayoutGuide
    let views = [coinsDisplayView, shopButton, resetButton, menuButton, basewordLabel, textField, submitButton, numberOfWordsTitleLabel, numberOfWordsBodyLabel, currentScoreTitleLabel, currentScoreBodyLabel, divider, collectionView]
    for view in views {
      guard let view = view else { return }
      self.addSubview(view)
      view.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      coinsDisplayView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.widthPadding),
      coinsDisplayView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),

      shopButton.bottomAnchor.constraint(equalTo: self.keyboardLayoutGuide.topAnchor, constant: -Constants.widthPadding),

      resetButton.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -Constants.widthPadding),
      menuButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.widthPadding),

      basewordLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: Constants.widthPadding * 4),
      basewordLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),

      textField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: Constants.widthPadding),
      textField.topAnchor.constraint(equalTo: basewordLabel.bottomAnchor, constant: Constants.widthPadding),
      textField.trailingAnchor.constraint(equalTo: submitButton.leadingAnchor, constant: -Constants.widthPadding),
      textField.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),

      submitButton.topAnchor.constraint(equalTo: basewordLabel.bottomAnchor, constant: Constants.widthPadding),
      submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.widthPadding),
      submitButton.heightAnchor.constraint(equalToConstant: 40),
      submitButton.widthAnchor.constraint(equalTo: submitButton.heightAnchor),

      numberOfWordsBodyLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 24),
      numberOfWordsBodyLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),

      numberOfWordsTitleLabel.topAnchor.constraint(equalTo: numberOfWordsBodyLabel.bottomAnchor),
      numberOfWordsTitleLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
      numberOfWordsTitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width / 2),

      currentScoreBodyLabel.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 24),
      currentScoreBodyLabel.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor),

      currentScoreTitleLabel.topAnchor.constraint(equalTo: currentScoreBodyLabel.bottomAnchor),
      currentScoreTitleLabel.trailingAnchor.constraint(equalTo: submitButton.trailingAnchor),
      currentScoreTitleLabel.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width / 2),

      divider.topAnchor.constraint(equalTo: numberOfWordsTitleLabel.bottomAnchor, constant: 8),
      divider.widthAnchor.constraint(equalTo: widthAnchor),
      divider.centerXAnchor.constraint(equalTo: centerXAnchor),
      divider.heightAnchor.constraint(equalToConstant: 3),

      collectionView.topAnchor.constraint(equalTo: divider.bottomAnchor),
      collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])

    // For Animating Buttons in and out, when shop is shown
    coinsDisplayTopAnchor = coinsDisplayView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: -Constants.widthPadding)
    coinsDisplayTopAnchor?.isActive = true

    shopButtonTrailingAnchor = shopButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -Constants.widthPadding)
    shopButtonTrailingAnchor?.isActive = true

    menuButtonTopAnchor = resetButton.topAnchor.constraint(equalTo: safeArea.topAnchor)
    menuButtonTopAnchor?.isActive = true

    resetButtonTopAnchor = menuButton.topAnchor.constraint(equalTo: safeArea.topAnchor)
    resetButtonTopAnchor?.isActive = true
  }

  func clearTextField() {
    textField.text?.removeAll()
  }
}

// MARK: - Setting up publishers
extension MainView {
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

