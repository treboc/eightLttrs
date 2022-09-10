//
//  RoundedNavigationTitle-ViewModifier.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 28.08.22.
//

import SwiftUI

extension View {
  func roundedNavigationTitle() -> some View {
    modifier(RoundedNavigationTitle())
  }
}

struct RoundedNavigationTitle: ViewModifier {
  func body(content: Content) -> some View {
    content
  }

  init() {
    var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle)
    titleFont = UIFont(descriptor:
                        titleFont.fontDescriptor
      .withDesign(.rounded)?
      .withSymbolicTraits(.traitBold)
                       ??
                       titleFont.fontDescriptor,
                       size: titleFont.pointSize
    )
    UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
  }
}
