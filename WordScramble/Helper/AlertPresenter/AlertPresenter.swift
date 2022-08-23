//
//  AlertPresenter.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 20.08.22.
//

import UIKit

struct AlertPresenter {
  static func presentAlert(on viewController: UIViewController, with alertData: AlertPresenterData) {
    let ac = UIAlertController(title: alertData.title, message: alertData.message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: L10n.ButtonTitle.cancel, style: .cancel)
    let customAction = UIAlertAction(title: alertData.actionTitle, style: alertData.actionStyle, handler: alertData.actionHandler)

    ac.addAction(defaultAction)
    ac.addAction(customAction)
    viewController.present(ac, animated: true)
  }
}
