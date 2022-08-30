//
//  SceneDelegate.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  // Gets called on 'cold start'!
  // App is currently not running, whether in background nor active
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: scene)
    var mainVC: MainViewController!

    // We check the connectionOptions, they contain the urlContexts,
    // if the App was launched by clicking an AppLink
    // If so and the word inside the link is a valid start word,
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
    
    // check if there is currently a session with atleast one word
    if let mainVC = getMainViewController(in: scene) {
       if mainVC.hasUsedWords {
        // dismiss topViewController, to get present the Alert on the mainViewController
        (scene.keyWindow?.rootViewController as? UINavigationController)?.topViewController?.dismiss(animated: false)
        // the "continue"-action
         presentAlertController(on: mainVC,
                                with: L10n.SharedWord.Alert.UsedWordsInCurrentSession.title,
                                and: L10n.SharedWord.Alert.UsedWordsInCurrentSession.message) { _ in
          mainVC.gameService.startGame(with: word)
        }
      } else {
        mainVC.gameService.startGame(with: word)
      }
    }
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }
}

extension SceneDelegate {
  private func extractStartWord(from context: UIOpenURLContext) -> String? {
    guard
      let word = context.url.pathComponents[safe: 1],
      GameService.isValidStartWord(word)
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
