//
//  MainViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import Combine
import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
  var mainView: MainView {
    view as! MainView
  }

  var dataSource: UICollectionViewDiffableDataSource<Section, WordCellItem>!
  var cancellables = Set<AnyCancellable>()

  var hasUsedWords: Bool = false

  var gameService: GameServiceProtocol
  var gameType: GameType

  init(gameType: GameType = .randomWord) {
    self.gameType = gameType

    if gameType == .randomWord {
      self.gameService = GameService()
    } else {
      self.gameService = GameService(gameType)
    }

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - loadView()
  override func loadView() {
    view = MainView()
  }

  // MARK: - viewDidLoad()
  override func viewDidLoad() {
    super.viewDidLoad()
    presentOnboardinIfIsFirstStart()

    setupNavigationController()
    setupCollectionView()
    setupActions()
    setupPublishers()

    mainView.wordTextField.delegate = self
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
  enum Section {
    case wordList
  }

  private func setupCollectionView() {
    mainView.collectionView.delegate = self

    // Create cell registration that defines how data should be shown in a cell
    let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, WordCellItem> { (cell, indexPath, item) in
      // Define how data should be shown using content configuration
      var content = cell.defaultContentConfiguration()
      content.image = item.pointsImage
      content.text = item.word

      // Assign content configuration to cell
      cell.contentConfiguration = content
    }

    dataSource = UICollectionViewDiffableDataSource<Section, WordCellItem>(collectionView: mainView.collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, identifier: WordCellItem) -> UICollectionViewCell? in
      // Dequeue reusable cell using cell registration (Reuse identifier no longer needed)
      let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                              for: indexPath,
                                                              item: identifier)
      return cell
    }
    mainView.collectionView.keyboardDismissMode = .interactiveWithAccessory
  }

  // Update cells using snapshot
  private func applySnapshot(with items: [WordCellItem]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, WordCellItem>()
    snapshot.appendSections([.wordList])
    snapshot.appendItems(items, toSection: .wordList)
    dataSource.apply(snapshot)
  }

  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return false
  }

  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return false
  }
}

// MARK: - MainViewControllerSetup
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
    mainView.wordTextField.addTarget(self, action: #selector(submit), for: .primaryActionTriggered)
    mainView.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
    let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"), style: .plain, target: self, action: #selector(showMenu))
    menuButton.accessibilityLabel = "Menu"
    navigationItem.rightBarButtonItem = menuButton
  }

  private func setupPublishers() {
    // Publisher to update the cells, corrosponding to the used words in gameService
    gameService.wordCellItemPublisher
      .dropFirst()
      .sink { [weak self] items in
        self?.applySnapshot(with: items)
      }
      .store(in: &cancellables)

    // Publisher to update the title, when the word changes in gameService
    gameService.currentWordPublisher
      .sink { [weak self] word in
        self?.updateLabels(with: word)
      }
      .store(in: &cancellables)

    gameService.wordCellItemPublisher
      .map { !$0.isEmpty }
      .assign(to: \.hasUsedWords, on: self)
      .store(in: &cancellables)

    gameService.possibleScorePublisher
      .sink { [weak self] (currentScore, possibleScore) in
        self?.updateScoreLabel(with: currentScore, and: possibleScore)
      }
      .store(in: &cancellables)
  }

  func presentAlertControllert(with alert: Alert) {
    let ac = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default)
    ac.addAction(defaultAction)
    present(ac, animated: true)
  }

  private func updateMainViewAfterSubmission() {
    mainView.wordTextField.text?.removeAll()
    // Maybe looking up for another solution because this needs to be done
    // because this is not like typing or removing all characters 'by hand'..
    mainView.submitButton.isEnabled = false
  }
}

// MARK: - Methods for Buttons
extension MainViewController {
  private func updateLabels(with word: String) {
    self.title = word
    mainView.clearTextField()
  }

  private func updateScoreLabel(with currentScore: Int, and possibleScore: Int) {
    mainView.scorePointsLabel.text = "\(currentScore) / \(possibleScore)"
  }

  @objc
  private func showMenu() {
    let menuVC = MenuViewController(gameService: gameService)
    let menuNavVC = UINavigationController(rootViewController: menuVC)
    present(menuNavVC, animated: true)
  }

  @objc
  func submit() {
    guard
      let answer = mainView.wordTextField.text,
      !answer.isEmpty
    else { return }
    do {
      try gameService.submitAnswerWith(answer, onCompletion: updateMainViewAfterSubmission)
      HapticManager.shared.notification(type: .success)
    } catch let error as WordError {
      HapticManager.shared.notification(type: .error)
      presentAlertControllert(with: error.alert)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}

// MARK: EndSessionDelegate
extension MainViewController: EndSessionDelegate {
  // EndSessionDelegate
  // -> gets called in EndSessionViewController
  func submitButtonTapped(_ name: String) {
    setLastPlayersName(name)
    gameService.endGame(playerName: name)
  }

  func cancelButtonTapped() {
    gameService.startGame()
  }

  private func setLastPlayersName(_ name: String) {
    UserDefaults.standard.set(name, forKey: UserDefaultsKeys.lastPlayersName)
  }
}

// MARK: - Handle dismiss keyboard on tap
extension MainViewController {
  fileprivate func hideKeyboardOnTap() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc
  fileprivate func hideKeyboard() {
    view.endEditing(true)
  }
}

// MARK: - Handle onboarding
extension MainViewController {
  private func presentOnboardinIfIsFirstStart() {
    let isFirstStart = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFirstStart)

    if isFirstStart == false {
      let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
      onboardingVC.modalPresentationStyle = .fullScreen
      self.parent?.present(onboardingVC, animated: false)
    }
  }
}

