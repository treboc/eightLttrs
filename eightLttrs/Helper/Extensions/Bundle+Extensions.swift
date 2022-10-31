//
//  Bundle+Extensions.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 31.10.22.
//

import Foundation

extension Bundle {
  var displayName: String {
    object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Could not determine the application name"
  }

  var appVersion: String {
    object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Could not determine the version number"
  }

  var appBuild: String {
    object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Could not determine the build number"
  }
}
