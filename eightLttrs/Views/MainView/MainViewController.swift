//
//  MainViewController.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import Combine
import Popovers
import UIKit
import SwiftUI

class MainViewController: UIViewController, UITextFieldDelegate {
  var mainView: MainView {
    view as! MainView
  }

  var viewModel: MainViewModel
  private var dataSource: UICollectionViewDiffableDataSource<Section, String>!
  private var cancellables = Set<AnyCancellable>()

  init(viewModel: MainViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    self.viewModel.resetUICallback = resetPublishers
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = MainView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    presentOnboarding()

    setupCollectionView()
    setupCoinsDisplayView()
    setupActions()
    setupPublishers()
    setupAccessibility()

    mainView.textField.delegate = self
    view.bringSubviewToFront(mainView.shopButton)
  }
}

extension MainViewController: UICollectionViewDelegate {
  enum Section {
    case wordList
  }

  private func setupCoinsDisplayView() {
    let childView = UIHostingController(rootView: CoinsDisplayView(coinShopManager: viewModel.coinShopManager))
    addChild(childView)
    childView.view.translatesAutoresizingMaskIntoConstraints = false
    mainView.coinsDisplayView.addSubview(childView.view)
    childView.didMove(toParent: self)

    NSLayoutConstraint.activate([
      childView.view.leadingAnchor.constraint(equalTo: mainView.coinsDisplayView.leadingAnchor),
      childView.view.trailingAnchor.constraint(equalTo: mainView.coinsDisplayView.trailingAnchor),
      childView.view.topAnchor.constraint(equalTo: mainView.coinsDisplayView.topAnchor),
      childView.view.bottomAnchor.constraint(equalTo: mainView.coinsDisplayView.bottomAnchor),
    ])
  }

  private func setupCollectionView() {
    mainView.collectionView.delegate = self

    // Create cell registration that defines how data should be shown in a cell
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { (cell, indexPath, word) in
      // Define how data should be shown using content configuration
      var content = cell.defaultContentConfiguration()
      let points = word.calculatedScore()
      let config = UIImage.SymbolConfiguration(font: .preferredFont(forTextStyle: .headline), scale: .large)
      let image = UIImage(systemName: "\(points <= 50 ? points : 0).circle.fill", withConfiguration: config)!
      content.image = image
      content.text = word

      // Assign content configuration to cell
      cell.contentConfiguration = content
      cell.accessibilityLabel = L10n.A11y.MainView.Cell.label(word, points)
    }

    dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: mainView.collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
      // Dequeue reusable cell using cell registration (Reuse identifier no longer needed)
      let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                              for: indexPath,
                                                              item: identifier)
      return cell
    }

    mainView.collectionView.keyboardDismissMode = .onDrag
  }

  // Update cells using snapshot
  private func applySnapshot(with items: [String]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    snapshot.appendSections([.wordList])
    snapshot.appendItems(items, toSection: .wordList)
    dataSource.apply(snapshot)
  }

  private func applyFilteredSnapshot(with string: String, on items: [String]) {
    guard !string.isEmpty else {
      applySnapshot(with: items)
      return
    }
    let filteredItems = items.filter { $0.lowercased().contains(string.lowercased()) }
    applySnapshot(with: filteredItems)
  }

  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return false
  }

  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return false
  }
}

extension MainViewController {
  private func setupActions() {
    // SubmitActions
    mainView.textField.addTarget(self, action: #selector(submit), for: .primaryActionTriggered)
    mainView.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)

    mainView.menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
    mainView.resetButton.addTarget(self, action: #selector(newBaseword), for: .touchUpInside)
    mainView.shopButton.addTarget(self, action: #selector(showShop), for: .touchUpInside)
  }

  private func setupPublishers() {
    // Publisher -> updates title
    viewModel.session
      .publisher(for: \.baseword, options: [.initial, .new])
      .receive(on: DispatchQueue.main)
      .compactMap({ $0 })
      .sink(receiveValue: didReceiveBaseword)
      .store(in: &cancellables)

    // Publisher -> updates collectionView
    viewModel.session
      .publisher(for: \.usedWords)
      .sink { [weak self] words in
        guard let self else { return }
        self.applySnapshot(with: words)
        self.mainView.resetButton.isHidden = words.count == 0 ? false : true
      }
      .store(in: &cancellables)

    // Publisher -> updates left-side foundWordsLabels
    viewModel.session
      .publisher(for: \.usedWords)
      .map { $0.count }
      .combineLatest(viewModel.session.publisher(for: \.maxPossibleWordsOnBaseWord))
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (usedWordsCount, maxPossibleWordsCount) in
        self?.updateWordsLabel(with: usedWordsCount, and: maxPossibleWordsCount)
      }
      .store(in: &cancellables)

    // Publisher -> updates right-side scoreLabels
    viewModel.session
      .publisher(for: \.score)
      .combineLatest(viewModel.session.publisher(for: \.maxPossibleScoreOnBaseWord))
      .receive(on: DispatchQueue.main)
      .map({ ($0, $1) })
      .sink(receiveValue: updateScoreLabel)
      .store(in: &cancellables)

    // Publisher -> enables filtering
    viewModel.input
      .debounce(for: 0.3, scheduler: DispatchQueue.main)
      .subscribe(on: DispatchQueue.main)
      .receive(on: DispatchQueue.main)
      .sink { [unowned self] (value) in
        self.applyFilteredSnapshot(with: value, on: self.viewModel.session.usedWords)
      }
      .store(in: &cancellables)

    // Publisher -> color baseword with input
    viewModel.input
      .sink { [unowned self] value in
        mainView.basewordLabel.attributedText = highlighted(input: value, onString: viewModel.session.unwrappedBaseword)
      }
      .store(in: &cancellables)

    // Publisher -> input to mainViewModel
    mainView.textField.textPublisher()
      .sink { [unowned self] (value) in
        viewModel.input.send(value)
      }
      .store(in: &cancellables)

    viewModel.$shopIsShown
      .dropFirst()
      .sink { [weak self] shopIsShown in
        if shopIsShown {
          self?.hideButtons()
        } else {
          self?.showButtons()
        }

        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: {
          self?.view.layoutIfNeeded()
        }, completion: nil)
      }
      .store(in: &cancellables)

    viewModel.error
      .dropFirst()
      .compactMap { $0 }
      .sink(receiveValue: presentPopover)
      .store(in: &cancellables)
  }

  private func resetPublishers() {
    cancellables.removeAll(keepingCapacity: true)
    setupPublishers()
  }

  private func presentPopover(with wordError: WordError) {
    var popover = Popover { ErrorPopover(error: wordError) }
    popover.attributes.sourceFrame = self.mainView.divider.windowFrame
    popover.attributes.position = .absolute(originAnchor: .top, popoverAnchor: .top)
    present(popover)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      popover.dismiss()
    }
  }

  private func presentAlertController(with wordError: WordError) {
    let title = wordError.alert.title
    let message = wordError.alert.message
    UIAlertController.presentAlertController(on: self, with: .custom(title: title, message: message))
  }

  private func clearTextField() {
    // Maybe looking up for another solution because this needs to be done
    // because this is not like typing or removing all characters 'by hand'..
    mainView.submitButton.isEnabled = false
    mainView.clearTextField()
  }

  private func didReceiveBaseword(_ baseword: String) {
    mainView.basewordLabel.text = baseword
    mainView.clearTextField()
  }
}

// MARK: - Methods
extension MainViewController {
  private func updateScoreLabel(with currentScore: Int, and possibleScore: Int) {
    mainView.currentScoreBodyLabel.text = "\(viewModel.session.score) / \(possibleScore)"
  }

  private func updateWordsLabel(with usedWordsCount: Int, and possibleWordsCount: Int) {
    mainView.numberOfWordsBodyLabel.text = "\(usedWordsCount) / \(possibleWordsCount)"
  }

  @objc
  private func showMenu() {
    let vc = UIHostingController(rootView: MenuView()
      .environmentObject(viewModel))
    present(vc, animated: true)
  }

  @objc
  private func showShop() {
    let vc = UIHostingController(rootView: CoinShopView(session: viewModel.session) { [weak self] in
      self?.viewModel.shopIsShown = false
    }
    )
    vc.modalPresentationStyle = .overCurrentContext
    vc.modalTransitionStyle = .crossDissolve
    vc.view.backgroundColor = .clear
    viewModel.shopIsShown = true
    present(vc, animated: true)
  }

  @objc
  private func newBaseword() {
    viewModel.resetSession(on: self)
  }

  @objc
  private func submit() {
    viewModel.submit(onCompletion: clearTextField)
  }

  private func showButtons() {
    mainView.coinsDisplayTopAnchor?.constant = -Constants.widthPadding
    mainView.shopButtonTrailingAnchor?.constant = -Constants.widthPadding
  }

  private func hideButtons() {
    mainView.coinsDisplayTopAnchor?.constant = -300
    mainView.shopButtonTrailingAnchor?.constant = 300
  }

  /// Returns a NSAttributedString where the input is greyed out, the rest remains normally visible.
  /// - Parameters:
  ///   - input: The part that will be greyed out.
  ///   - onString: The String that this applies to.
  ///
  func highlighted(input: String, onString: String) -> NSAttributedString {
    let markedAttribute: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.label.withAlphaComponent(0.2)]
    let attributedString = NSMutableAttributedString()
    var tmpInput = input
    for letter in onString {
      if tmpInput.contains(letter) {
        let attributedLetter = NSAttributedString(string: String(letter), attributes: markedAttribute)
        attributedString.append(attributedLetter)
        if let index = tmpInput.firstIndex(of: letter) {
          tmpInput.remove(at: index)
        }
      } else {
        let attributedLetter = NSAttributedString(string: String(letter))
        attributedString.append(attributedLetter)
      }
    }
    return attributedString
  }
}

// MARK: - Handle onboarding
extension MainViewController {
  private func presentOnboarding() {
    if UserDefaults.standard.value(forKey: UserDefaults.Keys.isFirstStart) == nil {
      let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
      onboardingVC.modalPresentationStyle = .fullScreen
      self.parent?.present(onboardingVC, animated: false)
    }
  }

  private func setupAccessibility() {
    guard let collectionView = mainView.collectionView else { return }
    accessibilityElements = [mainView.textField, mainView.submitButton, mainView.numberOfWordsBodyLabel, mainView.currentScoreBodyLabel, collectionView]

    mainView.textField.accessibilityHint = L10n.A11y.MainView.Textfield.hint
    mainView.numberOfWordsBodyLabel.accessibilityLabel = L10n.A11y.MainView.WordsLabels.label(viewModel.session.usedWords.count, viewModel.session.maxPossibleWordsOnBaseWord)
    mainView.currentScoreBodyLabel.accessibilityLabel = L10n.A11y.MainView.ScoreLabels.label(viewModel.session.score, viewModel.session.maxPossibleScoreOnBaseWord)
  }
}

