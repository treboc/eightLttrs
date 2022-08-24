//
//  MenuViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 17.08.22.
//

import UIKit

protocol MenuViewControllerDelegate {
  func resetGame()
  func endGame()

  var hasUsedWords: Bool { get }
}

class MenuViewController: UIViewController {
  var menuView: MenuView {
    view as! MenuView
  }

  var delegate: MenuViewControllerDelegate?

  override func loadView() {
    view = MenuView(frame: .zero)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupActions()

    // disable the endSessionButton if there are no words entered yet
    if let hasUsedWords = delegate?.hasUsedWords {
      menuView.endSessionButton.isEnabled = hasUsedWords ? true : false
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
    dismiss(animated: true)
    delegate?.resetGame()
  }

  @objc
  private func endGameButtonTapped() {
    dismiss(animated: true)
    delegate?.endGame()
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
