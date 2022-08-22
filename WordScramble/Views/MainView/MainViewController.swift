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

  init(gameService: GameServiceProtocol = GameService(scoreService: ScoreService())) {
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
    presentOnboardingOnFirstStart()

    setupNavigationController()
    setupActions()

    mainView.tableView.dataSource = self
    mainView.tableView.delegate = self
    mainView.tableView.register(WordTableViewCell.self, forCellReuseIdentifier: WordTableViewCell.identifier)

    mainView.wordTextField.delegate = self

    startGame()
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return gameService.usedWords.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: WordTableViewCell.identifier, for: indexPath) as! WordTableViewCell
    let (word, points) = gameService.populateWordWithScore(at: indexPath)
    cell.updateLabels(with: (word, points))
    return cell
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
    let indexPath = IndexPath(row: 0, section: 0)
    mainView.tableView.insertRows(at: [indexPath], with: .left)
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
      mainView.tableView.reloadData()
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
    ac.addTextField()
    let saveAction = UIAlertAction(title: L10n.EndGameAlert.save, style: .default) { [weak self] _ in
      guard let name = ac.textFields?[0].text else { return }
      self?.gameService.endGame(playerName: name)
      self?.startGame()
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
  private func presentOnboardingOnFirstStart() {
    let isFirstStart = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isFirstStart)

    if isFirstStart == false {
      let onboardingVC = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
      onboardingVC.modalPresentationStyle = .fullScreen
      self.parent?.present(onboardingVC, animated: false)
    }
  }
}
