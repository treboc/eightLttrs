//
//  OnboardingPageView.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 18.08.22.
//

import SwiftUI

struct OnboardingPageView: View {
  var body: some View {
    TabView {
      Text("1")
      Text("2")
      Text("3")
    }
    .tabViewStyle(.page(indexDisplayMode: .always))
  }
}

struct OnboardingPageViewController_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingPageView()
  }
}
