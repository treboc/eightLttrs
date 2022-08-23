//
//  HighscoreViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 23.08.22.
//

import Combine
import UIKit

class HighscoreViewController: UIViewController {
  var highscoreView: HighscoreView {
    view as! HighscoreView
  }

  override func loadView() {
    view = HighscoreView()
  }

  lazy var dataSource = configuteDataSource()
  var highscores = [HighscoreCellItem]() {
    didSet {
      updateCollectionViewState(with: highscores)
    }
  }

  // MARK: - viewDidLoad()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.highscores = ScoreService.loadHighscores()
    self.title = "Highscore"

    highscoreView.collectionView.delegate = self
    highscoreView.collectionView.register(HighscoreCell.self, forCellWithReuseIdentifier: HighscoreCell.identifier)

    // Set close button in navigationBar
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeMenu))
  }
}

// MARK: - Actions
extension HighscoreViewController {
  @objc
  private func closeMenu() {
    dismiss(animated: true)
  }
}

// MARK: - UICollectionViewSetup
extension HighscoreViewController: UICollectionViewDelegate {
  enum Section {
    case scores
  }

  // Make this generic
  private func configuteDataSource() -> UICollectionViewDiffableDataSource<Section, HighscoreCellItem> {
    return UICollectionViewDiffableDataSource<Section, HighscoreCellItem>(collectionView: highscoreView.collectionView) { collectionView, indexPath, item in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighscoreCell.identifier, for: indexPath) as! HighscoreCell
      cell.updateLabels(with: item, and: indexPath)
      return cell
    }
  }

  private func updateCollectionViewState(with items: [HighscoreCellItem]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, HighscoreCellItem>()
    snapshot.appendSections([.scores])
    snapshot.appendItems(items, toSection: .scores)
    dataSource.apply(snapshot)
  }

  func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
    return false
  }

  func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
    return false
  }
}
