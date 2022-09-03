//
//  HighscoreViewViewcontrollerRepresentable.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 28.08.22.
//

import SwiftUI

struct HighscoreListViewRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = HighscoreViewController

  func makeUIViewController(context: Context) -> HighscoreViewController {
    return HighscoreViewController()
  }

  func updateUIViewController(_ uiViewController: HighscoreViewController, context: Context) {

  }
}
