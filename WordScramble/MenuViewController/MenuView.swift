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
  lazy var stackView: UIStackView = {
    let sv = UIStackView()
    sv.axis = .vertical
    sv.alignment = .center
    sv.spacing = 20
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()

  lazy var restartSessionButton: UIButton = {
    let btn = UIButton()
    btn.configuration = .borderedProminent()
    btn.setTitle(L10n.MenuView.restartSession, for: .normal)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  lazy var endSessionButton: UIButton = {
    let btn = UIButton()
    btn.configuration = .borderedProminent()
    btn.setTitle(L10n.MenuView.endSession, for: .normal)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  lazy var showHighscoreButton: UIButton = {
    let btn = UIButton()
    btn.configuration = .borderedProminent()
    btn.setTitle(L10n.MenuView.showHighscore, for: .normal)
    btn.translatesAutoresizingMaskIntoConstraints = false
    return btn
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = .systemBackground
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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

}
