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
    window.rootViewController = mainVC
    window.makeKeyAndVisible()
    self.window = window

    if let firstURL = connectionOptions.urlContexts.first?.url {
      deeplinkCoordinator.handleURL(firstURL)
    }
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let firstURL = URLContexts.first?.url else { return }
    deeplinkCoordinator.handleURL(firstURL)
  }
}
