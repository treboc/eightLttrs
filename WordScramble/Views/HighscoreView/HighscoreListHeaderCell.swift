//
//  HighscoreListHeaderCell.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 23.08.22.
//

import UIKit

class HighscoreListHeaderCell: UIView {
  private let stackView = UIStackView()
  private let rankLabel = UILabel()
  private let nameLabel = UILabel()
  private let scoreLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    let views = [rankLabel, nameLabel, scoreLabel]
    views.forEach { view in
      view.font = .preferredFont(forTextStyle: .headline)
    }

    rankLabel.text = "Rank"
    nameLabel.text = "Name"
    scoreLabel.text = "Rank"

    stackView.axis = .horizontal
    stackView.spacing = 10

    rankLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    scoreLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }

  private func setupLayout() {
    let safeArea = self.safeAreaLayoutGuide
    [rankLabel, nameLabel, scoreLabel].forEach { stackView.addArrangedSubview($0) }
    stackView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
      stackView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
      stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20),
      stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
    ])
  }


}
