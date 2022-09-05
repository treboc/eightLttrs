//
//  EndSessionViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//

import UIKit

class EndSessionViewController: UIViewController {
  let gameService: GameService

  var endSessionView: EndSessionView {
    view as! EndSessionView
  }

  init(gameService: GameService) {
    self.gameService = gameService
    super.init(nibName: nil, bundle: nil)

    self.isModalInPresentation = true
    navigationItem.hidesBackButton = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = EndSessionView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    endSessionView.updateBodyLabel(with: gameService.session)
    setupActions()
  }
}

extension EndSessionViewController {
  private func setupActions() {
    endSessionView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    endSessionView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    endSessionView.textField.addTarget(self, action: #selector(submitButtonTapped), for: .primaryActionTriggered)
  }

  @objc
  private func submitButtonTapped() {
    guard let name = endSessionView.textField.text,
          !name.isEmpty
    else { return }
    UserDefaults.standard.setValue(name, forKey: UserDefaultsKeys.lastPlayersName)
    gameService.endGame(playerName: name)
    self.dismiss(animated: true)
  }

  @objc
  private func cancelButtonTapped() {
    self.dismiss(animated: true)
  }
}
