//
//  HighscoreCell.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 23.08.22.
//

import UIKit

class HighscoreCell: UITableViewCell {
  static var identifier: String {
    String(describing: self)
  }

  private let stackView = UIStackView()
  private let rankLabel = UILabel()
  private let nameLabel = UILabel()
  private let scoreLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateLabels(with cellItem: HighscoreCellItem, and indexPath: IndexPath) {
    rankLabel.text = "#\(indexPath.item + 1)"
    nameLabel.text = cellItem.name
    scoreLabel.text = String(format: "%03d", cellItem.score)
  }

  private func setupViews() {
    self.selectionStyle = .none

    rankLabel.font = .preferredFont(forTextStyle: .headline)

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

      rankLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1)
    ])
  }
}
