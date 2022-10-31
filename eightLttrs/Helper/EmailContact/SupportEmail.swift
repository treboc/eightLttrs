//
//  SupportEmail.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 31.10.22.
//

import Foundation
import SwiftUI

struct SupportEmail {
  static let address: String = Constants.contactAddress
  static let subject: String = "[support@eightLttrs]"
  static let body: String = """


    ---
    Version: \(Bundle.main.appVersion)
    Build: \(Bundle.main.appBuild)
  """

  static func send(openURL: OpenURLAction) {
    let urlString = "mailto:\(address)?subject=\(subject)&body=\(body.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "")"
    guard let url = URL(string: urlString) else { return }
    openURL(url) { accepted in
      if !accepted {
        print("This device does not support mail.")
      }
    }
  }
}
