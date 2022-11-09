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
      var p = Path()
      p.move(to: CGPoint(x: rect.minX + rect.width / 5, y: rect.midY + (rect.height / 5)))
      p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
      p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
      return p
    }
  }

  @State private var end: CGFloat = .zero
  var animationDuration: CGFloat? = nil

  var body: some View {
    Checkmark()
      .trim(from: 0, to: end)
      .stroke(.secondary, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
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
