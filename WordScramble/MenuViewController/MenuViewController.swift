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
}

class MenuViewController: UIViewController {
  var menuView: MenuView {
    view as! MenuView
  }

  var delegate: MenuViewControllerDelegate?

  override func loadView() {
    view = MenuView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = L10n.MenuView.title
    setupActions()
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeMenu))
  }
}

extension MenuViewController {
  private func setupActions() {
    menuView.restartSessionButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    menuView.endSessionButton.addTarget(self, action: #selector(endGameButtonTapped), for: .touchUpInside)
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
  private func closeMenu() {
    dismiss(animated: true)
  }
}
