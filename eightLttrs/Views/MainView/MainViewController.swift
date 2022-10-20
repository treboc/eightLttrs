//
//  MainViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import AVFoundation
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

  private var menuButton: UIBarButtonItem!
  private var resetButton: UIBarButtonItem!

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

    setupNavigationController()
    setupCollectionView()
    setupActions()
    setupPublishers()
    setupAccessibility()

    mainView.textField.delegate = self
  }
}

extension MainViewController: UICollectionViewDelegate {
  enum Section {
    case wordList
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

    var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
    snapshot.appendSections([.wordList])
    snapshot.appendItems(filteredItems, toSection: .wordList)
    dataSource.apply(snapshot)
  }

  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return false
  }

  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return false
  }
}

extension MainViewController {
  private func setupNavigationController() {
    self.navigationItem.largeTitleDisplayMode = .always
    self.navigationController?.navigationBar.prefersLargeTitles = true

    // Set NavTitle to rounded design
    var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
    titleFont = UIFont(descriptor: titleFont
      .fontDescriptor
      .withDesign(.rounded)?
      .withSymbolicTraits(.traitBold)
                       ?? titleFont.fontDescriptor, size: titleFont.pointSize
    )
    self.navigationController?.navigationBar.largeTitleTextAttributes = [.font: titleFont]
  }

  private func setupActions() {
    self.hideKeyboardOnTap()

    // SubmitActions 
    mainView.textField.addTarget(self, action: #selector(submit), for: .primaryActionTriggered)
    mainView.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)

    // Right -> UIBarButtonItem
    resetButton = UIBarButtonItem(image: UIImage(systemName: "arrow.counterclockwise.circle.fill"), style: .plain, target: self, action: #selector(resetButtonTapped))
    resetButton.accessibilityLabel = L10n.MenuView.restartSession

    menuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle.fill"), style: .plain, target: self, action: #selector(showMenu))
    menuButton.accessibilityLabel = L10n.MenuView.title
    menuButton.accessibilityIdentifier = "menuBtn"

    navigationItem.rightBarButtonItems = [menuButton, resetButton]
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
        self?.applySnapshot(with: words)
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

    // Publisher -> input to mainViewModel
    mainView.textField.textPublisher()
      .sink { [unowned self] (value) in
        viewModel.input.send(value)
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

  func presentPopover(with wordError: WordError) {
    var popOver = Popover { ErrorPopover(error: wordError) }
    popOver.attributes.sourceFrame = self.mainView.windowFrame
    popOver.attributes.presentation.transition = .slide
    popOver.attributes.dismissal.transition = .slide
    popOver.attributes.position = .absolute(originAnchor: .center, popoverAnchor: .center)
    present(popOver)
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
      popOver.dismiss()
    }
  }

  func presentAlertController(with wordError: WordError) {
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

  private func didReceiveBaseword(_ baseWord: String) {
    self.title = baseWord
    navigationItem.accessibilityLabel = L10n.A11y.MainView.title(baseWord)
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

  // dismiss keyboard on tap anywhere outside the keyboard
  fileprivate func hideKeyboardOnTap() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc
  fileprivate func hideKeyboard() {
    view.endEditing(true)
  }

  @objc
  private func showMenu() {
    let vc = UIHostingController(rootView: MenuView().environmentObject(viewModel))
    present(vc, animated: true)
  }

  @objc
  private func resetButtonTapped() {
    viewModel.resetSession(on: self)
  }

  @objc
  private func submit() {
    viewModel.submit(onCompletion: clearTextField)
  }
}

// MARK: - Handle onboarding
extension MainViewController {
  private func presentOnboarding() {
    if UserDefaults.standard.value(forKey: UserDefaultsKeys.isFirstStart) == nil {
      let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
      onboardingVC.modalPresentationStyle = .fullScreen
      self.parent?.present(onboardingVC, animated: false)
    }
  }

  private func setupAccessibility() {
    guard let menuButton = menuButton,
          let collectionView = mainView.collectionView else { return }
    accessibilityElements = [menuButton, mainView.textField, mainView.submitButton, mainView.numberOfWordsBodyLabel, mainView.currentScoreBodyLabel, collectionView]

    mainView.textField.accessibilityHint = L10n.A11y.MainView.Textfield.hint
    mainView.numberOfWordsBodyLabel.accessibilityLabel = L10n.A11y.MainView.WordsLabels.label(viewModel.session.usedWords.count, viewModel.session.maxPossibleWordsOnBaseWord)
    mainView.currentScoreBodyLabel.accessibilityLabel = L10n.A11y.MainView.ScoreLabels.label(viewModel.session.score, viewModel.session.maxPossibleScoreOnBaseWord)
  }
}

