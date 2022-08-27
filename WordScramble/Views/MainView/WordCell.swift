//
//  WordCell.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

class WordCell: UICollectionViewListCell {
  static var identifier: String {
    String(describing: self)
  }

  private let pointsImage = UIImageView()
  private let wordLabel = UILabel()
  private let stackView = UIStackView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayout()
  }


  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateLabels(with wordCellItem: WordCellItem) {
    pointsImage.image = wordCellItem.pointsImage
    wordLabel.text = wordCellItem.word
  }

  private func setupViews() {
    wordLabel.font = .preferredFont(forTextStyle: .headline)
    wordLabel.adjustsFontForContentSizeCategory = true

    stackView.axis = .horizontal
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false
  }

  private func setupLayout() {
    stackView.addArrangedSubview(pointsImage)
    stackView.addArrangedSubview(wordLabel)
    addSubview(stackView)

    pointsImage.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.widthPadding),
      stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.widthPadding),
      stackView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.widthPadding),
      stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.widthPadding)
    ])

//    self.addSubview(pointsImage)
//    self.addSubview(wordLabel)
//
//    pointsImage.translatesAutoresizingMaskIntoConstraints = false
//    wordLabel.translatesAutoresizingMaskIntoConstraints = false
//
//    NSLayoutConstraint.activate([
//      pointsImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.widthPadding),
//      pointsImage.topAnchor.constraint(equalTo: topAnchor, constant: Constants.widthPadding),
//      pointsImage.widthAnchor.constraint(equalToConstant: Constants.widthPadding * 2),
//      pointsImage.heightAnchor.constraint(equalTo: pointsImage.widthAnchor),
//      pointsImage.centerYAnchor.constraint(equalTo: centerYAnchor),
//
//      wordLabel.leadingAnchor.constraint(equalTo: pointsImage.trailingAnchor, constant: Constants.widthPadding),
//      wordLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.widthPadding),
//      wordLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -(2*Constants.widthPadding) + pointsImage.frame.width),
//      wordLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.widthPadding),
//      wordLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//    ])
  }
}
