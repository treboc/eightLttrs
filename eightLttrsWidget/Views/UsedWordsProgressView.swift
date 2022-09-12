//
//  UsedWordsProgressView.swift
//  WordScrambleWidgetExtension
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import SwiftUI

struct UsedWordsProgressView: View {
  var progress: CGFloat
  let showPercentage: Bool = false

  var progressPercentage: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    return formatter.string(from: progress as NSNumber) ?? "0 %"
  }

  var body: some View {
    ZStack {
      ContainerRelativeShape()
        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
        .fill(Color.accent.opacity(0.4))

      ContainerRelativeShape()
        .trim(from: 0, to: progress)
        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
        .fill(Color.accent)

      showPercentage
      ? Text(progressPercentage)
        .monospacedDigit()
        .font(.caption2)
        .fontWeight(.semibold)
      : nil
    }
  }
}

struct UsedWordsProgressView_Previews: PreviewProvider {
  static var previews: some View {
    UsedWordsProgressView(progress: 0.242)
      .padding()
      .previewLayout(.sizeThatFits)
  }
}
