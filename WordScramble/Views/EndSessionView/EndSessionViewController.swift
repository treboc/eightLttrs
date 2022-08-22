//
//  EndSessionViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//

import UIKit

class EndSessionViewController: UIViewController {
  private let word: String
  private let score: Int
  private let wordCount: Int

  var endSessionView: EndSessionView {
    view as! EndSessionView
  }


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
  }
}
