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
    guard
      let scene = (scene as? UIWindowScene),
      let context = URLContexts.first,
      let word = extractStartWord(from: context)
    else {
      if let mainVC = getMainViewController(in: scene as! UIWindowScene) {
        // dismiss topViewController, to get present the Alert on the mainViewController
        mainVC.navigationController?.topViewController?.dismiss(animated: false)
        // the "continue"-action
        presentAlertController(on: mainVC,
                               with: L10n.SharedWord.Alert.NoValidStartword.title,
                               and: L10n.SharedWord.Alert.NoValidStartword.message)
      }
      return
    }
    
    // check if there is currently a session with atleast one baseWord
    if let mainVC = getMainViewController(in: scene) {
       if mainVC.gameServiceHasUsedWords {
        // dismiss topViewController, to get present the Alert on the mainViewController
        (scene.keyWindow?.rootViewController as? UINavigationController)?.topViewController?.dismiss(animated: false)
        // the "continue"-action
         presentAlertController(on: mainVC,
                                with: L10n.SharedWord.Alert.UsedWordsInCurrentSession.title,
                                and: L10n.SharedWord.Alert.UsedWordsInCurrentSession.message) { _ in
          mainVC.gameService.startNewSession(with: word)
        }
      } else {
        mainVC.gameService.startNewSession(with: word)
      }
    }
  }
}

extension SceneDelegate {
  private func extractStartWord(from context: UIOpenURLContext) -> String? {
    guard
      context.url.scheme == "wordscramble",
      context.url.host == "baseword",
      let locale = context.url.pathComponents[safe: 1],
      let word = context.url.pathComponents[safe: 2],
      GameService.isValidBaseWord(word, with: locale)
    else { return nil }

    return word
  }

  private func getMainViewController(in scene: UIWindowScene) -> MainViewController? {
    guard let viewControllers = (scene.keyWindow?.rootViewController as? UINavigationController)?.viewControllers else { return nil }

    let mainVC = viewControllers.first { viewController in
      viewController is MainViewController
    }

    return mainVC as? MainViewController
  }

  private func presentAlertController(on viewController: UIViewController,
                                      with title: String,
                                      and message: String,
                                      onContinuePressed: ((UIAlertAction) -> Void)? = nil ) {
    let ac = UIAlertController(title: title,
                               message: message,
                               preferredStyle: .alert)
    if let handler = onContinuePressed {
      let cancelAction = UIAlertAction(title: L10n.ButtonTitle.cancel, style: .cancel)
      ac.addAction(cancelAction)
      let proceedAction = UIAlertAction(title: L10n.ButtonTitle.continue, style: .destructive, handler: handler)
      ac.addAction(proceedAction)
    } else {
      ac.addAction(UIAlertAction(title: L10n.ButtonTitle.ok, style: .default))
    }
    viewController.present(ac, animated: true)
  }
}
