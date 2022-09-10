//
//  Divider.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 30.08.22.
//

import UIKit

class Divider: UIView {
  let gradient = CAGradientLayer()

  init(height: CGFloat = 1) {
    super.init(frame: .zero)

    self.frame = .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
    self.setContentHuggingPriority(.defaultHigh, for: .vertical)
    gradient.frame = self.frame
    gradient.startPoint = .init(x: 0, y: 0)
    gradient.endPoint = .init(x: 1, y: 0)
    self.layer.insertSublayer(gradient, at: 0)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    gradient.colors = [UIColor.tintColor.cgColor,
                       UIColor.tintColor.withAlphaComponent(0.5).cgColor,
                       UIColor.tintColor.cgColor]
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
