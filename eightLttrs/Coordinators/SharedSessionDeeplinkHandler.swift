//
//  SharedSessionDeeplinkHandler.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 08.09.22.
//

import Foundation
import UIKit

final class SharedSessionDeeplinkHandler: DeeplinkHandlerProtocol {
  private weak var navViewController: UINavigationController?

  init(navViewController: UINavigationController?) {
    self.navViewController = navViewController
  }

  func canOpenURL(_ url: URL) -> Bool {
    return url.absoluteString.hasPrefix("wordscramble://baseword")
  }
  
  func openURL(_ url: URL) {
    guard let mainViewController = navViewController?.viewControllers.first as? MainViewController else { return }
    mainViewController.navigationController?.topViewController?.dismiss(animated: false)
    
    if let word = extractStartWord(from: url) {
      UIAlertController.presentAlertController(on: mainViewController,
                                               title: L10n.SharedWord.Alert.UsedWordsInCurrentSession.title,
                                               message: L10n.SharedWord.Alert.UsedWordsInCurrentSession.message) { _ in
        mainViewController.viewModel.startNewSession(with: word)
      }
    } else {
      UIAlertController.presentAlertController(on: mainViewController,
                                               title: L10n.SharedWord.Alert.NoValidStartword.title,
                                               message: L10n.SharedWord.Alert.NoValidStartword.message)
    }
  }

  func extractStartWord(from url: URL) -> String? {
    guard
      url.scheme == "wordscramble",
      url.host == "baseword",
      let locale = WSLocale(rawValue: (url.pathComponents[1].uppercased())),
      let word = url.pathComponents[safe: 2]?.removingPercentEncoding,
      WordService.isValidBaseword(word, with: locale) else {
      return nil
    }
    return word
  }
}
