//
//  SceneDelegate.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  private var mainVC: MainViewController?
  var window: UIWindow?

  // Gets called on 'cold start'!
  // App is currently not running, whether in background nor active
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: scene)

    // We check the connectionOptions, they contain the urlContexts,
    // if the App was launched by clicking an AppLink
    // If so and the baseWord inside the link is a valid start baseWord,
    // try to start the session
    if let context = connectionOptions.urlContexts.first,
       let word = extractStartWord(from: context) {
      let gameService = GameService(gameType: .shared(word))
      mainVC = MainViewController(gameService: gameService)
    } else if let session = SessionService.returnLastSession() {
      let gameService = GameService(lastSession: session)
      mainVC = MainViewController(gameService: gameService)
    } else {
      let gameService = GameService()
      mainVC = MainViewController(gameService: gameService)
    }

    guard let mainVC = mainVC else { return }
    window.rootViewController = UINavigationController(rootViewController: mainVC)
    window.makeKeyAndVisible()
    self.window = window
  }

  // Gets called when the app is already opened (e.g. running in background) and a link is clicked
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if
      let scene = (scene as? UIWindowScene),
      let context = URLContexts.first,
      let word = extractStartWord(from: context),
      let mainVC = getMainViewController(in: scene) {
      if mainVC.gameServiceHasUsedWords {
        // dismiss topViewController, to get present the Alert on the mainViewController
        (scene.keyWindow?.rootViewController as? UINavigationController)?.topViewController?.dismiss(animated: false)
        // the "continue"-action
        UIAlertController.presentAlertController(on: mainVC,
                                                 title: L10n.SharedWord.Alert.UsedWordsInCurrentSession.title,
                                                 message: L10n.SharedWord.Alert.UsedWordsInCurrentSession.message) { _ in
          mainVC.gameService.startNewSession(with: word)
        }
      } else {
        mainVC.gameService.startNewSession(with: word)
      }
    } else {
      if let mainVC = getMainViewController(in: scene as! UIWindowScene) {
        // dismiss topViewController, to get present the Alert on the mainViewController
        mainVC.navigationController?.topViewController?.dismiss(animated: false)
        // the "continue"-action
        UIAlertController.presentAlertController(on: mainVC,
                                                 title: L10n.SharedWord.Alert.NoValidStartword.title,
                                                 message: L10n.SharedWord.Alert.NoValidStartword.message)
      } else {
        return
      }
    }
  }
}

extension SceneDelegate {
  private func extractStartWord(from context: UIOpenURLContext) -> String? {
    if
      context.url.scheme == "wordscramble",
      context.url.host == "baseword",
      let locale = WSLocale(rawValue: (context.url.pathComponents[1].uppercased())),
      let word = context.url.pathComponents[safe: 2],
      WordService.isValidBaseword(word, with: locale) {
      return word
    } else {
      return nil
    }
  }

  private func getMainViewController(in scene: UIWindowScene) -> MainViewController? {
    guard let viewControllers = (scene.keyWindow?.rootViewController as? UINavigationController)?.viewControllers else { return nil }

    return viewControllers.first { $0 is MainViewController } as? MainViewController
  }
}

