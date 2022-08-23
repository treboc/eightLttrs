//
//  AlertPresenter.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 20.08.22.
//

import UIKit

struct AlertPresenterData {
  let title: String?
  let message: String?
  let actionTitle: String
  let actionStyle: UIAlertAction.Style
  let actionHandler: ((UIAlertAction) -> Void)?

  init(title: String?,
       message: String?,
       actionTitle: String,
       actionStyle: UIAlertAction.Style = .default,
       actionHandler: ((UIAlertAction) -> Void)? = nil) {
    self.title = title
    self.message = message
    self.actionTitle = actionTitle
    self.actionStyle = actionStyle
    self.actionHandler = actionHandler
  }
}
