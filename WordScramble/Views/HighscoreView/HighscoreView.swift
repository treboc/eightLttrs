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
  private let divider = Divider(height: 1)

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
    self.backgroundColor = .systemBackground
    stackView.axis = .vertical
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
      divider.heightAnchor.constraint(equalToConstant: 1)
    ])
  }
}
