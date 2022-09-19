//
//  UIAlertController+Extensions.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 06.09.22.
//

import UIKit

extension UIAlertController {
  enum AlertControllerType {
    case noValidStartWord
    case wordsInSession
    case custom(title: String, message: String)
  }

  static func presentAlertController(on viewController: UIViewController,
                                     with type: AlertControllerType,
                                     onContinuePressed: ((UIAlertAction) -> Void)? = nil ) {
    var title = ""
    var message = ""

    switch type {
    case .noValidStartWord:
      title = L10n.SharedWord.Alert.NoValidStartword.title
      message = L10n.SharedWord.Alert.NoValidStartword.message
    case .wordsInSession:
      title = L10n.SharedWord.Alert.UsedWordsInCurrentSession.title
      message = L10n.SharedWord.Alert.UsedWordsInCurrentSession.message
    case .custom(let acTitle, let acMessage):
      title = acTitle
      message = acMessage
    }

    let ac = UIAlertController(title: title,
                               message: message,
                               preferredStyle: .alert)
    ac.view.accessibilityIdentifier = "alertController"
    if let handler = onContinuePressed {
      let cancelAction = UIAlertAction(title: L10n.ButtonTitle.cancel, style: .cancel)
      ac.addAction(cancelAction)
      let proceedAction = UIAlertAction(title: L10n.ButtonTitle.continue, style: .destructive, handler: handler)
      proceedAction.accessibilityIdentifier = "continueBtn"
      ac.addAction(proceedAction)
    } else {
      ac.addAction(UIAlertAction(title: L10n.ButtonTitle.ok, style: .default))
    }
    viewController.present(ac, animated: true)
  }
}
