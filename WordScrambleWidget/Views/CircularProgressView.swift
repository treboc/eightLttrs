//
//  CircularProgressView.swift
//  WordScrambleWidgetExtension
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import SwiftUI

struct CircularProgressView: View {
  var progress: CGFloat
  let showPercentage: Bool = false

  var progressPercentage: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    return formatter.string(from: progress as NSNumber) ?? "0 %"
  }

  var body: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 16)
        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
        .rotation(Angle(degrees: -90))
        .fill(Color.accentColor.opacity(0.4))

      RoundedRectangle(cornerRadius: 16)
        .trim(from: 0, to: progress)
        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
        .rotation(Angle(degrees: -90))
        .fill(Color.red)

      showPercentage
      ? Text(progressPercentage)
        .monospacedDigit()
        .font(.caption2)
        .fontWeight(.semibold)
      : nil
    }
  }
}

struct CircularProgressView_Previews: PreviewProvider {
  static var previews: some View {
    CircularProgressView(progress: 0.242)
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
