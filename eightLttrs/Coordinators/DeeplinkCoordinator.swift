//
//  DeeplinkCoordinator.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 08.09.22.
//

import Foundation

protocol DeeplinkCoordinatorProtocol {
  func handleURL(_ url: URL)
}

final class DeeplinkCoordinator {
  let handlers: [DeeplinkHandlerProtocol]

  init(handlers: [DeeplinkHandlerProtocol]) {
    self.handlers = handlers
  }
}

extension DeeplinkCoordinator: DeeplinkCoordinatorProtocol {
  func handleURL(_ url: URL) {
    guard let handler = handlers.first(where: { $0.canOpenURL(url) }) else { return }

    handler.openURL(url)
  }
}
