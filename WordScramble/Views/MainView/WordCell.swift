//
//  WordCell.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

extension CALayer {
  func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
    let border = CAGradientLayer()

    switch edge {
    case .top:
      border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
    case .bottom:
      border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
    case .left:
      border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
    case .right:
      border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
    default:
      break
    }

    border.colors = [UIColor.systemBackground.cgColor, UIColor.tintColor.cgColor]
    border.startPoint = .init(x: 0, y: 0)
    border.endPoint = .init(x: 1, y: 0)

    addSublayer(border)
  }
}


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
    stackView.alignment = .center
    stackView.spacing = 10
    stackView.translatesAutoresizingMaskIntoConstraints = false

    self.layer.addBorder(edge: .bottom, color: .tintColor, thickness: 1)
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
  }
}
