//
//  AppearancePicker.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 20.10.22.
//

import SwiftUI

struct AppearancePicker: View {
  @ObservedObject var appearanceManager = AppearanceManager.shared

  var body: some View {
    Picker(selection: $appearanceManager.appearance) {
      ForEach(AppearanceManager.Appearance.allCases, id: \.self) {
        Text($0.title)
      }
    } label: {
      HStack {
        Image(systemName: "photo.circle.fill")
          .font(.system(.title2, weight: .bold))
          .foregroundColor(.accent)
        Text(L10n.ColorPicker.title)
      }
    }
    .pickerStyle(.menu)
  }
}

struct AppearancePicker_Previews: PreviewProvider {
  static var previews: some View {
    AppearancePicker()
  }
}
