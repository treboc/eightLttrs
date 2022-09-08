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

  private let rankLabel = UILabel()
  private let nameLabel = UILabel()
  private let wordLabel = UILabel()
  private let scorePointsLabel = UILabel()
  private let scoreTextLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateLabels(with session: Session, and indexPath: IndexPath) {
    rankLabel.text = "\(indexPath.item + 1)."
    nameLabel.text = session.unwrappedName
    wordLabel.text = "gestartet mit: \(session.unwrappedBaseword)"
    scorePointsLabel.text = String(format: "%03d", session.score)
  }

  private func setupViews() {
    self.selectionStyle = .none
    self.accessoryType = .disclosureIndicator

    // RankLabel
    rankLabel.textAlignment = .center
    rankLabel.font = .preferredFont(forTextStyle: .headline)

    wordLabel.font = .preferredFont(forTextStyle: .caption2)
    wordLabel.textColor = .secondaryLabel

    // ScoreTextLabel
    scoreTextLabel.text = "Punkte"
    scoreTextLabel.font = .preferredFont(forTextStyle: .caption2)
    scoreTextLabel.textColor = .secondaryLabel
  }

  private func setupLayout() {
    let safeArea = self.safeAreaLayoutGuide
    [rankLabel, nameLabel, wordLabel, scorePointsLabel, scoreTextLabel].forEach {
      addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      // RankLabel
      rankLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
      rankLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      rankLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.1),

      // NameLabel
      nameLabel.leadingAnchor.constraint(equalTo: rankLabel.trailingAnchor, constant: 12),
      nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),

      // wordLabel
      wordLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
      wordLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),

      // ScorePointsLabel
      scorePointsLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      scorePointsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),

      // scoreTextLabel
      scoreTextLabel.topAnchor.constraint(equalTo: scorePointsLabel.bottomAnchor),
      scoreTextLabel.trailingAnchor.constraint(equalTo: scorePointsLabel.trailingAnchor),
      scoreTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
    ])
  }
}
