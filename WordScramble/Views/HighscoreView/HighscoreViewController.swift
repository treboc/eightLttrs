//
//  HighscoreViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 23.08.22.
//

import Combine
import LinkPresentation
import UIKit
import SwiftUI

class HighscoreViewController: UIViewController {
  var highscoreView: HighscoreView {
    view as! HighscoreView
  }

  let metadata = LPLinkMetadata()

  override func loadView() {
    view = HighscoreView()
  }

  var metaData: LPLinkMetadata?

  private var highscores = [HighscoreCellItem]() {
    didSet {
      highscoreView.tableView.reloadData()
    }
  }

  // MARK: - viewDidLoad()
  override func viewDidLoad() {
    super.viewDidLoad()
    self.highscores = ScoreService.loadHighscores()
//    self.title = "Highscore"

    highscoreView.tableView.delegate = self
    highscoreView.tableView.dataSource = self
    highscoreView.tableView.register(HighscoreCell.self, forCellReuseIdentifier: HighscoreCell.identifier)

    // Set close button in navigationBar
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.largeTitleDisplayMode = .always
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeMenu))
  }

  @objc
  private func closeMenu() {
    dismiss(animated: true)
  }
}

// MARK: - Sharing Score (UIActivityItemSource)
extension HighscoreViewController: UIActivityItemSource {
  func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
    "Spread the word!"
  }

  func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
    return metadata
  }

  func activityViewControllerLinkMetadata(_: UIActivityViewController) -> LPLinkMetadata? {
    return metadata
  }

  private func shareHighscore(_ item: HighscoreCellItem) {
    if let word = item.word.addingPercentEncoding(withAllowedCharacters: .letters),
       let url = URL(string: "wordscramble://word/\(word)") {
      metadata.originalURL = URL(string: "wordscramble://\(word)")
      metadata.url = metadata.originalURL
      metadata.title = "Try it yourself!"
      metadata.imageProvider = NSItemProvider.init(contentsOf: Bundle.main.url(forResource: "icon", withExtension: "jpg"))
      let text = L10n.HighscoreView.ShareScore.text(item.score, item.word)
      let ac = UIActivityViewController(activityItems: [self, text, url], applicationActivities: nil)
      present(ac, animated: true)
    }
  }
}

// MARK: - UITableViewController Methods
extension HighscoreViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    highscores.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: HighscoreCell.identifier, for: indexPath) as! HighscoreCell
    cell.updateLabels(with: highscores[indexPath.row], and: indexPath)
    return cell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }

  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    let shareAction = UIContextualAction(style: .normal, title: "Share") { [weak self] action, view, completion in
      guard let self = self else { return }
      self.shareHighscore(self.highscores[indexPath.row])
      completion(true)
    }
    shareAction.backgroundColor = UIColor(named: "AccentColor")
    shareAction.image = UIImage(systemName: "square.and.arrow.up")

    return UISwipeActionsConfiguration(actions: [shareAction])
  }

}
