//
//  MainViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import AVFoundation
import Combine
import UIKit
import SwiftUI

class MainViewController: UIViewController, UITextFieldDelegate {
  var mainView: MainView {
    view as! MainView
  }

  var gameServiceHasUsedWords: Bool = false

  var gameService: GameService
  var audioPlayer: AVAudioPlayer?
  var dataSource: UICollectionViewDiffableDataSource<Section, String>!
  var cancellables = Set<AnyCancellable>()

  init(gameService: GameService) {
    self.gameService = gameService

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
    presentOnboarding()

    setupNavigationController()
    setupCollectionView()
    setupActions()
    setupPublishers()

    mainView.textField.delegate = self
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
    }

    dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: mainView.collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell? in
      // Dequeue reusable cell using cell registration (Reuse identifier no longer needed)
      let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                              for: indexPath,
                                                              item: identifier)
      return cell
    }

    mainView.collectionView.keyboardDismissMode = .interactiveWithAccessory
  }

  // Update cells using snapshot
  private func applySnapshot(with items: [String]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
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

    // SubmitActions
    mainView.textField.addTarget(self, action: #selector(submit), for: .primaryActionTriggered)
    mainView.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)

    // Right -> UIBarButtonItem
    let menuButton = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"), style: .plain, target: self, action: #selector(showMenu))
    menuButton.accessibilityLabel = L10n.MenuView.title
    navigationItem.rightBarButtonItem = menuButton
  }



  private func setupPublishers() {
    // Publisher -> updates title
    gameService.$baseWord
      .sink { [weak self] baseWord in
        self?.didReceive(baseWord)
      }
      .store(in: &cancellables)

    // Publisher -> updates collectionView
    gameService.$usedWords
      .sink { [weak self] words in
        self?.applySnapshot(with: words)
      }
      .store(in: &cancellables)

    // Publisher -> updates left-side foundWordsLabels
    gameService.$usedWords
      .map { $0.count }
      .combineLatest(gameService.$maxPossibleWordsForBaseWord)
      .receive(on: RunLoop.main)
      .sink { [weak self] (usedWordsCount, possibleWordsCount) in
        self?.updateWordsLabel(with: usedWordsCount, and: possibleWordsCount)
      }
      .store(in: &cancellables)

    // Publisher -> updates right-side scoreLabels
    gameService.$totalScore
      .combineLatest(gameService.$maxPossibleScoreForBaseWord)
      .receive(on: RunLoop.main)
      .sink { [weak self] (currentScore, possibleScore) in
        self?.updateScoreLabel(with: currentScore, and: possibleScore)
      }
      .store(in: &cancellables)

    // Publisher -> disables / enables "End Session" button in menu
    gameService.$usedWords
      .map { !$0.isEmpty }
      .assign(to: \.gameServiceHasUsedWords, on: self)
      .store(in: &cancellables)
  }

  func presentWordError(with alert: WordErrorAlert) {
    let ac = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default)
    ac.addAction(defaultAction)
    present(ac, animated: true)
  }

  private func updateMainViewAfterSubmission() {
    // Maybe looking up for another solution because this needs to be done
    // because this is not like typing or removing all characters 'by hand'..
    mainView.submitButton.isEnabled = false
    mainView.clearTextField()
  }
}

// MARK: - Methods for Buttons
extension MainViewController {
  private func didReceive(_ baseWord: String) {
    self.title = baseWord
    mainView.clearTextField()
  }

  private func updateScoreLabel(with currentScore: Int, and possibleScore: Int) {
    mainView.currentScoreBodyLabel.text = "\(currentScore) / \(possibleScore)"
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
    let vc = UIHostingController(rootView: MenuView_SwiftUI(gameService: gameService))
    present(vc, animated: true)
  }

  @objc
  private func submit() {
    guard
      let input = mainView.textField.text,
      !input.isEmpty
    else { return }
    do {
      try gameService.submit(input, onCompletion: updateMainViewAfterSubmission)
      HapticManager.shared.success()
      playSound(.success)
    } catch let error as WordError {
      HapticManager.shared.error()
      playSound(.error)
      presentWordError(with: error.alert)
    } catch {
      fatalError(error.localizedDescription)
    }
  }

  private func playSound(_ type: SoundType) {
    if UserDefaults.standard.bool(forKey: UserDefaultsKeys.enabledSound) {
      DispatchQueue.global(qos: .background).async { [weak self] in
        do {
          self?.audioPlayer = try AVAudioPlayer(contentsOf: type.fileURL)
          self?.audioPlayer?.play()
        } catch {
          print(error.localizedDescription)
        }
      }
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
//    gameService.startGame()
  }

  private func setLastPlayersName(_ name: String) {
    UserDefaults.standard.set(name, forKey: UserDefaultsKeys.lastPlayersName)
  }
}

extension MainViewController {

}

// MARK: - Handle onboarding
extension MainViewController {
  private func presentOnboarding() {
    if UserDefaults.standard.value(forKey: UserDefaultsKeys.isFirstStart) == nil {
      let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
      onboardingVC.modalPresentationStyle = .fullScreen
      self.parent?.present(onboardingVC, animated: false)

      UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isFirstStart)
    }
  }
}

