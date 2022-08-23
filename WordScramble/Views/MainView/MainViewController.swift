//
//  MainViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import Combine
import UIKit

class MainViewController: UIViewController, UITextFieldDelegate, MenuViewControllerDelegate {
  var gameService: GameServiceProtocol

  var mainView: MainView {
    view as! MainView
  }

  lazy var dataSource = configuteDataSource()
  var cancellable: AnyCancellable?

  init(gameService: GameServiceProtocol = GameService()) {
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
    presentOnboardinIfIsFirstStart()

    setupNavigationController()
    setupActions()

    mainView.collectionView.delegate = self
    mainView.collectionView.register(WordCell.self, forCellWithReuseIdentifier: WordCell.identifier)

    mainView.wordTextField.delegate = self

    cancellable = gameService.wordCellItemPublisher
      .sink { [weak self] items in
        self?.updateCollectionViewState(with: items)
      }

    startGame()
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
  private func updateCollectionViewState(with items: [WordCellItem]) {
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
  func setupNavigationController() {
    self.navigationItem.largeTitleDisplayMode = .always
    self.navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.circle"), style: .plain, target: self, action: #selector(showMenu))
  }

  func setupActions() {
    self.hideKeyboardOnTap()
    mainView.wordTextField.addTarget(self, action: #selector(submit), for: .primaryActionTriggered)
    mainView.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
  }


  func presentAlertControllert(with alert: Alert) {
    let ac = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default)
    ac.addAction(defaultAction)
    present(ac, animated: true)
  }

  private func updateUIAfterSumbission() {
    mainView.scorePointsLabel.text = "\(gameService.currentScore)"
    mainView.wordTextField.text?.removeAll()
  }
}

// MARK: - Methods for Buttons
extension MainViewController {
  @objc
  private func showMenu() {
    let menuVC = MenuViewController()
    menuVC.delegate = self
    let menuNavVC = UINavigationController(rootViewController: menuVC)
    present(menuNavVC, animated: true)
  }

  @objc
  func startGame() {
    gameService.startGame { [weak self] currentWord in
      self?.title = currentWord
      mainView.scorePointsLabel.text = "\(gameService.currentScore)"
      mainView.collectionView.reloadData()
    }
  }

  @objc
  func resetGame() {
    if gameService.usedWords.isEmpty {
      startGame()
    } else {
      let alertData = AlertPresenterData(title: L10n.ResetGameAlert.title, message: L10n.ResetGameAlert.message, actionTitle: L10n.ButtonTitle.imSure) { [weak self] _ in
        self?.startGame()
      }
      AlertPresenter.presentAlert(on: self, with: alertData)
    }
  }

  @objc
  func endGame() {
    let ac = UIAlertController(title: L10n.EndGameAlert.title,
                               message: L10n.EndGameAlert.message,
                               preferredStyle: .alert)
    let saveAction = UIAlertAction(title: L10n.ButtonTitle.imSure, style: .default) { [weak self] _ in
      guard let self = self else { return }
      let endSessionVC = EndSessionViewController(word: self.gameService.currentWord,
                                                  score: self.gameService.currentScore,
                                                  wordCount: self.gameService.usedWords.count)
      endSessionVC.delegate = self
      self.present(endSessionVC, animated: true)
    }
    let cancelAction = UIAlertAction(title: L10n.ButtonTitle.cancel, style: .cancel)
    ac.addAction(saveAction)
    ac.addAction(cancelAction)
    present(ac, animated: true)
  }

  @objc
  func submit() {
    guard
      let answer = mainView.wordTextField.text,
      !answer.isEmpty
    else { return }
    do {
      try gameService.submitAnswerWith(answer, onCompletion: updateUIAfterSumbission)
    } catch let error as WordError {
      presentAlertControllert(with: error.alert)
    } catch {
      fatalError(error.localizedDescription)
    }
  }
}

extension MainViewController: EndSessionDelegate {
  func submitButtonTapped() {
    startGame()
  }

  func cancelButtonTapped() {
    startGame()
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

// MARK: - Onboarding on first start
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

