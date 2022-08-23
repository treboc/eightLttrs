//
//  EndSessionViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//

import UIKit

protocol EndSessionDelegate {
  func submitButtonTapped()
  func cancelButtonTapped()
}

class EndSessionViewController: UIViewController {
  private let word: String
  private let score: Int
  private let wordCount: Int

  var endSessionView: EndSessionView {
    view as! EndSessionView
  }

  var delegate: EndSessionDelegate?

  init(word: String, score: Int, wordCount: Int) {
    self.word = word
    self.score = score
    self.wordCount = wordCount
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    view = EndSessionView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.isModalInPresentation = true
    endSessionView.updateBodyLabel(with: word, score: score, wordCount: wordCount)
    setupActions()
  }
}

extension EndSessionViewController {
  private func setupActions() {
    endSessionView.submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
    endSessionView.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    endSessionView.textField.addTarget(self, action: #selector(submitButtonTapped), for: .primaryActionTriggered)
  }

  @objc
  private func submitButtonTapped() {
    let name = endSessionView.textFieldText
    guard !name
      .trimmingCharacters(in: .whitespacesAndNewlines)
      .isEmpty
    else { return }

    ScoreService.save(word: word, for: name, with: score)
    delegate?.submitButtonTapped()
    self.dismiss(animated: true)
  }

  @objc
  private func cancelButtonTapped() {
    delegate?.submitButtonTapped()
    self.dismiss(animated: true)
  }
}
