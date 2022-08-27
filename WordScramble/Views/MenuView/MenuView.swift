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
  private let tableView = UITableView()

  let restartSessionButton = UIButton()
  let endSessionButton = UIButton()
  let showHighscoreButton = UIButton()

  override init(frame: CGRect) {
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
    // Buttons
    var buttonConfiguration = UIButton.Configuration.borderedProminent()
    buttonConfiguration.buttonSize = .large
    buttonConfiguration.cornerStyle = .large
    buttonConfiguration.baseForegroundColor = .systemBackground

    let buttons = [restartSessionButton, endSessionButton, showHighscoreButton]
    buttons.forEach { $0.configuration = buttonConfiguration }

    restartSessionButton.setTitle(L10n.MenuView.restartSession, for: .normal)
    endSessionButton.setTitle(L10n.MenuView.endSession, for: .normal)
    showHighscoreButton.setTitle(L10n.MenuView.showHighscore, for: .normal)

    // StackView
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.spacing = 20
    stackView.translatesAutoresizingMaskIntoConstraints = false

    self.backgroundColor = .systemBackground
  }

  private func setupLayout() {
    let views = [restartSessionButton, endSessionButton, showHighscoreButton]
    views.forEach {
      stackView.addArrangedSubview($0)
      $0.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.6).isActive = true
      $0.heightAnchor.constraint(greaterThanOrEqualToConstant: 45).isActive = true
    }

    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.widthAnchor.constraint(equalTo: widthAnchor),
      stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
      stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
}
