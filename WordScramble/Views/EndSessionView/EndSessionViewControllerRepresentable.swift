//
//  EndSessionViewControllerRepresentable.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 28.08.22.
//

import SwiftUI

struct EndSessionViewControllerRepresentable: UIViewControllerRepresentable, EndSessionDelegate {
  @Environment(\.dismiss) private var dismiss

  func cancelButtonTapped() {
    dismiss.callAsFunction()
  }

  func submitButtonTapped(_ name: String) {
    gameService.endGame(playerName: name)
    dismiss.callAsFunction()
  }

  typealias UIViewControllerType = EndSessionViewController

  let gameService: GameService

  func makeUIViewController(context: Context) -> EndSessionViewController {
    let vc = EndSessionViewController(session: gameService.session)
    vc.delegate = self
    return vc
  }

  func updateUIViewController(_ uiViewController: EndSessionViewController, context: Context) {

  }
}
