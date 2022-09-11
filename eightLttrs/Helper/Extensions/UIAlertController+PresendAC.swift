//
//  UIAlertController+Extensions.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 06.09.22.
//

import UIKit

extension UIAlertController {
  static func presentAlertController(on viewController: UIViewController,
                                     title: String,
                                     message: String,
                                     onContinuePressed: ((UIAlertAction) -> Void)? = nil ) {
    let ac = UIAlertController(title: title,
                               message: message,
                               preferredStyle: .alert)
    if let handler = onContinuePressed {
      let cancelAction = UIAlertAction(title: L10n.ButtonTitle.cancel, style: .cancel)
      ac.addAction(cancelAction)
      let proceedAction = UIAlertAction(title: L10n.ButtonTitle.continue, style: .destructive, handler: handler)
      ac.addAction(proceedAction)
    } else {
      ac.addAction(UIAlertAction(title: L10n.ButtonTitle.ok, style: .default))
    }
    viewController.present(ac, animated: true)
  }
}
