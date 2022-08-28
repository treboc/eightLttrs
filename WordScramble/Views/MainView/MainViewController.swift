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

  lazy var dataSource = configuteDataSource()
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
    setupActions()
    setupPublishers()

    mainView.collectionView.delegate = self
    mainView.collectionView.register(WordCell.self, forCellWithReuseIdentifier: WordCell.identifier)
    mainView.wordTextField.delegate = self

    mainView.collectionView.keyboardDismissMode = .interactiveWithAccessory
  }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
  enum Section {
    case wordList
  }

  private func configuteDataSource() -> UICollectionViewDiffableDataSource<Section, WordCellItem> {
    return UICollectionViewDiffableDataSource<Section, WordCellItem>(collectionView: mainView.collectionView) { collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WordCell.identifier, for: indexPath) as! WordCell
      cell.updateLabels(with: item)
      return cell
    }
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
    mainView.scorePointsLabel.text = "\(gameService.currentScore)"
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

