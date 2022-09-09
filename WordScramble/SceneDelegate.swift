//
//  SceneDelegate.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private var mainVC: MainViewController = MainViewController(viewModel: MainViewModel(gameType: .continueLastSession))

  lazy var deeplinkCoordinator: DeeplinkCoordinatorProtocol = {
    return DeeplinkCoordinator(handlers: [
      SharedSessionDeeplinkHandler(navViewController: navController)
    ])
  }()

  var navController: UINavigationController? {
    return window?.rootViewController as? UINavigationController
  }

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let scene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: scene)
    window.rootViewController = UINavigationController(rootViewController: mainVC)
    window.makeKeyAndVisible()
    self.window = window

    UserDefaults.standard.addObserver(self, forKeyPath: "Appearance", options: [.new], context: nil)

    if let firstURL = connectionOptions.urlContexts.first?.url {
      deeplinkCoordinator.handleURL(firstURL)
    }
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let firstURL = URLContexts.first?.url else { return }

    deeplinkCoordinator.handleURL(firstURL)
  }

  override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
    print("fired")
    guard
      let change = change,
      object != nil,
      keyPath == "Appearance",
      let themeValue = change[.newKey] as? String,
      let theme = AppearanceManager.Appearance(rawValue: themeValue)?.uiStyle
    else { return }

    UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: { [weak self] in
      self?.window?.overrideUserInterfaceStyle = theme
    }, completion: .none)
  }
}

extension SceneDelegate {
  private func extractStartWord(from context: UIOpenURLContext?) -> String? {
    guard let context = context else { return nil }
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
