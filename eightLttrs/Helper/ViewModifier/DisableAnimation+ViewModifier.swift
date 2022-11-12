//
//  DisableAnimation+ViewModifier.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 10.11.22.
//

import SwiftUI

struct DisableAnimation: ViewModifier {
  func body(content: Content) -> some View {
    content
      .transaction { transaction in
        transaction.animation = nil
      }
  }
}

extension View {
  func disableAnimation() -> some View {
    modifier(DisableAnimation())
  }
}
