//
//  AnimatedCheckmark.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 09.11.22.
//

import Foundation
import SwiftUI

struct AnimatedCheckmark: View {
  struct Checkmark: Shape {
    func path(in rect: CGRect) -> Path {
      let width = rect.size.width
      let height = rect.size.height

      var path = Path()
      path.move(to: .init(x: 0 * width, y: 0.5 * height))
      path.addLine(to: .init(x: 0.4 * width, y: 1.0 * height))
      path.addLine(to: .init(x: 1.0 * width, y: 0 * height))
      return path
    }
  }

  @State private var end: CGFloat = .zero
  var animationDuration: CGFloat? = nil

  var body: some View {
    Checkmark()
      .trim(from: 0, to: end)
      .stroke(.secondary, style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round))
      .aspectRatio(1, contentMode: .fit)
      .padding()
      .onAppear {
        withAnimation(.easeInOut(duration: animationDuration ?? 0.5)) {
          end = 1
        }
      }
  }
}


struct AnimatedCheckmark_Previews: PreviewProvider {
  static var previews: some View {
    AnimatedCheckmark()
  }
}
