//
//  AppearancePicker.swift
//  TriomiCount
//
//  Created by Marvin Lee Kobert on 21.07.22.
//

//import Introspect
import SwiftUI

struct AppearancePicker: View {
  @State private var selection: Int = 0
//  @Environment(\.colorScheme) private var colorScheme

  var body: some View {
    Picker("Select Theme", selection: $selection) {
      ForEach(0..<AppearanceManager.Appearance.allCases.count, id: \.self) { index in
        Text(AppearanceManager.Appearance.allCases[index].title)
          .tag(index)
      }
    }
    .pickerStyle(.segmented)
    .onChange(of: selection) { newValue in
      print(newValue)
    }
//    .introspectSegmentedControl { control in
//      let textColor: UIColor = colorScheme == .dark ? .black : .white
//      control.setTitleTextAttributes([.foregroundColor: textColor], for: .selected)
//      control.selectedSegmentTintColor = UIColor(.accentColor)
//    }
  }
}
