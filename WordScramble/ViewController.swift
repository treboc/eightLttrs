//
//  ViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

class ViewController: UIViewController {
  lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(WordTableViewCell.self, forCellReuseIdentifier: WordTableViewCell.identifier)
    tableView.dataSource = self
    tableView.delegate = self
    return tableView
  }()

  let store = Store()

  override func loadView() {
    view = tableView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
    setupNavigationController()
    startGame()
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return store.usedWords.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: WordTableViewCell.identifier, for: indexPath) as! WordTableViewCell
    cell.wordLabel.text = store.usedWords[indexPath.row]
    return cell
  }
}

extension ViewController {
  func setupNavigationController() {
    self.navigationItem.largeTitleDisplayMode = .always
    self.navigationController?.navigationBar.prefersLargeTitles = true
  }

  @objc
  func startGame() {
    title = store.allWords.randomElement()
    store.usedWords.removeAll(keepingCapacity: true)
    tableView.reloadData()
  }

  @objc
  func promptForAnswer() {
    let ac = UIAlertController(title: "Enter Answer", message: nil, preferredStyle: .alert)
    ac.addTextField()

    let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
      guard let answer = ac?.textFields?[0].text else { return }
      self?.submit(answer)
    }
    ac.addAction(submitAction)
    present(ac, animated: true)
  }

  func submit(_ answer: String) {
    let lowerAnswer = answer.lowercased()
    do {
      try check(lowerAnswer)
      store.usedWords.insert(answer, at: 0)
      let indexPath = IndexPath(row: 0, section: 0)
      tableView.insertRows(at: [indexPath], with: .automatic)
    } catch let error as WordError {
      catchError(error)
    } catch {
      presentErrorAlertWith(title: "Someething went wrong!")
    }

  }

  func catchError(_ error: WordError) {
      switch error {
      case .notReal:
        presentErrorAlertWith(title: "Word not recognized", message: "You can't just make them up, you know!")
      case .notOriginal:
        presentErrorAlertWith(title: "Word already used", message: "Be more original.")
      case .notPossible(let word):
        presentErrorAlertWith(title: "Word not possible", message: "You can't spell that from \(word).")
      case .tooShort:
        presentErrorAlertWith(title: "Word is too short", message: "The word should have at least 3 letters.")
      }
  }

  func presentErrorAlertWith(title: String, message: String? = nil) {
    let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default)
    ac.addAction(defaultAction)
    present(ac, animated: true)
  }

}

extension ViewController {
  func check(_ word: String) throws {
    // tooShort
    if word.count < 3 {
      throw WordError.tooShort
    }

    // isOriginal
    if store.usedWords
      .map({ $0.lowercased() })
      .contains(word) {
      throw WordError.notOriginal
    }

    // isPossible
    guard var tempWord = title?.lowercased() else { return }
    try word.forEach {
      if let position = tempWord.firstIndex(of: $0) {
        tempWord.remove(at: position)
      } else {
        throw WordError.notPossible(word: tempWord)
      }
    }

    // isReal
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

    if misspelledRange.location != NSNotFound {
      throw WordError.notReal
    }
  }
}

enum WordError: Error {
  case notReal, notOriginal, notPossible(word: String), tooShort
}

struct ErrorAlert {
  let title: String
  let message: String
}
