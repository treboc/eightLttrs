//
//  MenuViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 17.08.22.
//

import UIKit

//protocol MenuViewControllerDelegate {
//  func resetGame()
//  func endGame()
//
//  var gameService: GameServiceProtocol { get }
//
//  var hasUsedWords: Bool { get }
//}

class MenuViewController: UIViewController {
  var menuView: MenuView {
    view as! MenuView
  }

  let gameService: GameServiceProtocol

  init(gameService: GameServiceProtocol) {
    self.gameService = gameService
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = MenuView(frame: .zero)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupActions()

    // disable the endSessionButton if there are no words entered yet
    if gameService.usedWords.isEmpty {
      menuView.endSessionButton.isEnabled = false
    }
  }
}

// MARK: - NavigationArea
extension MenuViewController {
  private func setupNavigationBar() {
    self.title = L10n.MenuView.title
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
  }
}

// MARK: - EndSessionDelegate
extension MenuViewController: EndSessionDelegate {
  func submitButtonTapped(_ name: String) {
    gameService.endGame(playerName: name)
    dismiss(animated: true)
  }

  func cancelButtonTapped() {
    dismiss(animated: true)
  }
}

// MARK: - Actions
extension MenuViewController {
  private func setupActions() {
    // CloseButton
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeMenu))

    menuView.restartSessionButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    menuView.endSessionButton.addTarget(self, action: #selector(endGameButtonTapped), for: .touchUpInside)
    menuView.showHighscoreButton.addTarget(self, action: #selector(showHighscoreButtonTapped), for: .touchUpInside)
  }

  @objc
  private func resetButtonTapped() {
    if gameService.usedWords.isEmpty {
      gameService.startGame()
      dismiss(animated: true)
    } else {
      presentResetAlert { [weak self] _ in
        self?.gameService.startGame()
        self?.dismiss(animated: true)
      }
    }
  }

  @objc
  private func endGameButtonTapped() {
    let ac = UIAlertController(title: L10n.EndGameAlert.title,
                               message: L10n.EndGameAlert.message,
                               preferredStyle: .alert)

    let saveAction = UIAlertAction(title: L10n.ButtonTitle.imSure, style: .default) { [weak self] _ in
      guard let self = self else { return }
      let endSessionVC = EndSessionViewController(word: self.gameService.currentWord,
                                                  score: self.gameService.currentScore,
                                                  wordCount: self.gameService.usedWords.count)
      endSessionVC.delegate = self
      self.navigationController?.pushViewController(endSessionVC, animated: true)
    }
    let cancelAction = UIAlertAction(title: L10n.ButtonTitle.cancel, style: .cancel)
    ac.addAction(saveAction)
    ac.addAction(cancelAction)
    present(ac, animated: true)
  }

  @objc
  private func showHighscoreButtonTapped() {
    let highscoreVC = HighscoreViewController()
    navigationController?.pushViewController(highscoreVC, animated: true)
  }

  @objc
  private func closeMenu() {
    dismiss(animated: true)
  }
}

extension MenuViewController {
  private func presentResetAlert(_ resetHandler: @escaping (UIAlertAction) -> Void) {
    let ac = UIAlertController(title: L10n.ResetGameAlert.title, message: L10n.ResetGameAlert.message, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: L10n.ButtonTitle.cancel, style: .cancel))
    ac.addAction(UIAlertAction(title: L10n.ButtonTitle.imSure, style: .destructive, handler: resetHandler))
    self.present(ac, animated: true)
  }
}
