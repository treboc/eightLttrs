//
//  MenuView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 17.08.22.
//

import UIKit

class MenuView: UIView {
  /*
   1. Reset Session Button
   2. End Session Button
   3. Show Highscores Button
   */

  private let stackView = UIStackView()
  private let restartSessionButton = UIButton(configuration: .borderedProminent())
  private let endSessionButton = UIButton(configuration: .borderedProminent())
  private let showHighscoreButton = UIButton(configuration: .borderedProminent())

  var restartSession: (() -> Void)
  var endSession: (() -> Void)

  init(frame: CGRect, restartSession: @escaping () -> Void, endSession: @escaping () -> Void) {
    self.restartSession = restartSession
    self.endSession = endSession
    super.init(frame: frame)
    setupViews()
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension MenuView {
  private func setupViews() {
    // StackView
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 20
    stackView.translatesAutoresizingMaskIntoConstraints = false

    restartSessionButton.setTitle(L10n.MenuView.restartSession, for: .normal)
    endSessionButton.setTitle(L10n.MenuView.endSession, for: .normal)
    showHighscoreButton.setTitle(L10n.MenuView.showHighscore, for: .normal)

    restartSessionButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
    endSessionButton.addTarget(self, action: #selector(endGameButtonTapped), for: .touchUpInside)

    self.backgroundColor = .systemBackground
  }

  private func setupLayout() {
    let views = [restartSessionButton, endSessionButton, showHighscoreButton]
    views.forEach {
      stackView.addArrangedSubview($0)
      $0.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.5).isActive = true
    }

    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  @objc
  private func resetButtonTapped() {
    restartSession()
  }

  @objc
  private func endGameButtonTapped() {
    endSession()
  }
}
