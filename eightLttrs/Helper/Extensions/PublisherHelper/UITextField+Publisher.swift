//
//  UITextField+Publisher.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 07.09.22.
//

import Combine
import UIKit

extension UITextField {
  func textPublisher() -> AnyPublisher<String, Never> {
    return NotificationCenter.default
      .publisher(for: UITextField.textDidChangeNotification, object: self)
      .compactMap( {($0.object as? UITextField)?.text })
      .eraseToAnyPublisher()
  }
}
