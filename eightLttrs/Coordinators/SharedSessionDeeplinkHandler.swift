//
//  SharedSessionDeeplinkHandler.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 08.09.22.
//

import Foundation
import UIKit

final class SharedSessionDeeplinkHandler: DeeplinkHandlerProtocol {
  private weak var mainViewController: UIViewController?

  init(mainViewController: UIViewController?) {
    self.mainViewController = mainViewController
  }

  func canOpenURL(_ url: URL) -> Bool {
    return url.absoluteString.hasPrefix("eightlttrs://baseword")
  }
  
  func openURL(_ url: URL) {
    guard let mainViewController = mainViewController as? MainViewController else { return }
    mainViewController.presentedViewController?.dismiss(animated: false)

    if let word = extractStartWord(from: url) {
      UIAlertController.presentAlertController(on: mainViewController,
                                               with: .wordsInSession) { _ in
        mainViewController.viewModel.startNewSession(with: word)
      }
    } else {
      UIAlertController.presentAlertController(on: mainViewController,
                                               with: .noValidStartWord)
    }
  }

  func extractStartWord(from url: URL) -> String? {
    guard
      url.scheme == "eightlttrs",
      url.host == "baseword",
      let locale = WSLocale(rawValue: (url.pathComponents[1].uppercased())),
      let word = url.pathComponents[safe: 2]?.removingPercentEncoding,
      WordService.isValidBaseword(word, with: locale) else {
      return nil
    }
    return word
  }
}
