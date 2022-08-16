//
//  WordTableViewCell.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

class WordTableViewCell: UITableViewCell {
  static let identifier = "WordTableViewCell"
  var word: String! {
    didSet {
      wordLabel.text = word
      pointsImage.image = UIImage(systemName: "\(word.calclulateScore()).circle.fill")
    }
  }

  lazy var pointsImage: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

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
    self.addSubview(pointsImage)
    self.addSubview(wordLabel)
    NSLayoutConstraint.activate([
      pointsImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.widthPadding),
      pointsImage.topAnchor.constraint(equalTo: topAnchor, constant: Constants.widthPadding),
      pointsImage.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.widthPadding * 2),
      pointsImage.heightAnchor.constraint(equalTo: pointsImage.widthAnchor),
      pointsImage.centerYAnchor.constraint(equalTo: centerYAnchor),


      wordLabel.leadingAnchor.constraint(equalTo: pointsImage.trailingAnchor, constant: Constants.widthPadding),
      wordLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.widthPadding),
      wordLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -(2*Constants.widthPadding) + pointsImage.frame.width),
      wordLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.widthPadding),
      wordLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
