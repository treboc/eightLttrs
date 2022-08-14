//
//  WordTableViewCell.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

class WordTableViewCell: UITableViewCell {
  static let identifier = "WordTableViewCell"

  lazy var wordLabel: UILabel = {
    let lbl = UILabel()
    lbl.translatesAutoresizingMaskIntoConstraints = false
    lbl.font = .preferredFont(forTextStyle: .headline)
    return lbl
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupLabel() {
    self.addSubview(wordLabel)
    NSLayoutConstraint.activate([
      wordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      wordLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
      wordLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -16),
      wordLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
    ])
  }
}
