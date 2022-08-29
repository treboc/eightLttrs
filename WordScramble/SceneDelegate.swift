//
//  SceneDelegate.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: scene)
    window.makeKeyAndVisible()

    // opened from session
    if let context = connectionOptions.urlContexts.first,
       let mainVCwithStartWord = createMainViewController(from: context) {
      window.rootViewController = UINavigationController(rootViewController: mainVCwithStartWord)
    } else {
      window.rootViewController = UINavigationController(rootViewController: MainViewController())
    }
    self.window = window
  }

  // Gets called when the app is already opened (e.g. running in background) and a link is clicked
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard
      let scene = (scene as? UIWindowScene),
      let context = URLContexts.first,
      let word = getStartWord(from: context)
    else { return }

    // check if there is currently a session with atleast one word
    if let mainVC = getMainViewController(in: scene) {
      if mainViewControllerHasUsedWords(in: scene) {
        // dismiss topViewController, to get present the Alert on the mainViewController
        (scene.keyWindow?.rootViewController as? UINavigationController)?.topViewController?.dismiss(animated: false)
        // the "continue"-action
        presentAlertController(on: mainVC) { _ in
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
  private func getStartWord(from context: UIOpenURLContext) -> String? {
    let word = context.url.pathComponents[1]

    if word.count == 8 {
      return word
    } else {
      return nil
    }
  }

  private func createMainViewController(from context: UIOpenURLContext) -> MainViewController? {
    if let word = getStartWord(from: context) {
      return MainViewController(gameType: .shared(word))
    }
    return nil
  }

  private func getMainViewController(in scene: UIWindowScene) -> MainViewController? {
    guard let viewControllers = (scene.keyWindow?.rootViewController as? UINavigationController)?.viewControllers else { return nil }

    let mainVC = viewControllers.first { viewController in
      viewController is MainViewController
    }

    return mainVC as? MainViewController
  }

  private func mainViewControllerHasUsedWords(in scene: UIWindowScene) -> Bool {
    if let mainVC = getMainViewController(in: scene),
       mainVC.hasUsedWords {
      return true
    }
    return false
  }

  private func presentAlertController(on viewController: UIViewController, with handler: @escaping ((UIAlertAction) -> Void) ) {
    let ac = UIAlertController(title: L10n.SharedWord.AlertIfAlreadyStartedSession.title,
                               message: L10n.SharedWord.AlertIfAlreadyStartedSession.message,
                               preferredStyle: .alert)
    let proceedAction = UIAlertAction(title: L10n.ButtonTitle.continue, style: .destructive, handler: handler)
    let cancelAction = UIAlertAction(title: L10n.ButtonTitle.cancel, style: .cancel)
    ac.addAction(proceedAction)
    ac.addAction(cancelAction)
    viewController.present(ac, animated: true)
  }
}
