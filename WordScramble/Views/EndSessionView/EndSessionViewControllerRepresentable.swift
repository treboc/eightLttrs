//
//  EndSessionViewControllerRepresentable.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 28.08.22.
//

import SwiftUI

struct EndSessionViewControllerRepresentable: UIViewControllerRepresentable {
  @Environment(\.dismiss) private var dismiss

  typealias UIViewControllerType = EndSessionViewController

  let gameService: GameService

  func makeUIViewController(context: Context) -> EndSessionViewController {
    let vc = EndSessionViewController(gameService: gameService)
    return vc
  }

  func updateUIViewController(_ uiViewController: EndSessionViewController, context: Context) {

  }
}
