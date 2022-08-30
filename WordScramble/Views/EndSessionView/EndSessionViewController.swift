//
//  EndSessionViewController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//

import UIKit

protocol EndSessionDelegate {
  func submitButtonTapped(_ name: String)
  func cancelButtonTapped()
}

class EndSessionViewController: UIViewController {
  private let session: Session

  var endSessionView: EndSessionView {
    view as! EndSessionView
  }

  var delegate: EndSessionDelegate?

  init(session: Session) {
    self.session = session
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
    endSessionView.updateBodyLabel(with: session.unwrappedWord, score: Int(session.score), wordCount: session.usedWords.count)
    navigationItem.hidesBackButton = true
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
    guard let name = endSessionView.textField.text,
          !name.trimmingCharacters(in: .whitespacesAndNewlines)
               .isEmpty
    else { return }
    UserDefaults.standard.setValue(name, forKey: UserDefaultsKeys.lastPlayersName)
    delegate?.submitButtonTapped(name)
    self.dismiss(animated: true)
  }

  @objc
  private func cancelButtonTapped() {
    delegate?.cancelButtonTapped()
    self.dismiss(animated: true)
  }
}
