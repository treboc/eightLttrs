//
//  HighscoreView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 23.08.22.
//

import UIKit

class HighscoreView: UIView {
  private let stackView = UIStackView()
  private let headerCell = HighscoreListHeaderCell()
  private(set) var tableView = UITableView()
  private let divider = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - View setup
extension HighscoreView {
  private func setupViews() {
    divider.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1)
    divider.setContentHuggingPriority(.defaultHigh, for: .vertical)

    let gradient = CAGradientLayer()
    gradient.colors = [UIColor(named: "AccentColor")!.cgColor, UIColor.systemGray.cgColor]
    gradient.frame = divider.frame
    gradient.startPoint = .init(x: 0, y: 0)
    gradient.endPoint = .init(x: 1, y: 0)
    divider.layer.insertSublayer(gradient, at: 0)

    stackView.axis = .vertical

    self.backgroundColor = .systemBackground
  }
}

// MARK: - Layout setup
extension HighscoreView {
  private func setupLayout() {
    let safeArea = safeAreaLayoutGuide
    stackView.translatesAutoresizingMaskIntoConstraints = false

    stackView.addArrangedSubview(headerCell)
    stackView.addArrangedSubview(divider)
    stackView.addArrangedSubview(tableView)

    addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
      stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
      divider.heightAnchor.constraint(equalToConstant: 5)
    ])
  }
}
