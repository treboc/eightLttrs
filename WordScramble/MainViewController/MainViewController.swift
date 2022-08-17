//
//  MainViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import Combine
import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {
  var gameService: GameServiceProtocol

  var mainView: MainView {
    view as! MainView
  }

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
    setupNavigationController()
    setupActions()
    startGame()
    mainView.tableView.dataSource = self
    mainView.tableView.delegate = self
    mainView.wordTextField.delegate = self
  }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return gameService.usedWords.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: WordTableViewCell.identifier, for: indexPath) as! WordTableViewCell
    cell.word = gameService.usedWords[indexPath.row]
    cell.selectionStyle = .none
    return cell
  }
}

extension MainViewController {
  func setupNavigationController() {
    self.navigationItem.largeTitleDisplayMode = .always
    self.navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
  }

  func setupActions() {
    mainView.wordTextField.addTarget(self, action: #selector(submit), for: .primaryActionTriggered)
    mainView.submitButton.addTarget(self, action: #selector(submit), for: .touchUpInside)
    self.hideKeyboardOnTap()
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
