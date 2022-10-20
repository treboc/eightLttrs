//
//  ErrorPopover.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 20.10.22.
//

import SwiftUI

struct ErrorPopover: View {
  let error: WordError

  var body: some View {
    VStack(spacing: 16) {
      Image(systemName: "xmark.octagon.fill")
        .resizable()
        .frame(width: 32, height: 32)
        .foregroundColor(.red)

      Text(error.alert.title)
        .font(.title3.bold())

      Text(error.alert.message)
        .foregroundColor(.secondary)
        .multilineTextAlignment(.center)
    }
    .padding()
    .background(
      RoundedRectangle(cornerRadius: Constants.cornerRadius)
        .fill(.ultraThinMaterial)
        .shadow(color: .accent, radius: 5)
    )
  }
}

struct ErrorPopover_Previews: PreviewProvider {
  static var previews: some View {
    ErrorPopover(error: .notOriginal)
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
