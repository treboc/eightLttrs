//
//  ELLocale.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 02.09.22.
//

import Foundation

enum ELLocale: String, CaseIterable, Identifiable {
  var id: String {
    return rawValue
  }

  case DE, AT, CH, EN

  var description: String {
    switch self {
    case .DE, .AT, .CH:
      return L10n.german
    case .EN:
      return L10n.english
    }
  }

  var fileNameSuffix: String {
    switch self {
    case .DE, .AT, .CH:
      return "DE"
    default:
      return "EN"
    }
  }

  var regionCode: String {
    switch self {
    case .DE, .AT, .CH:
      return "de"
    case .EN:
      return "en"
    }
  }

  static func availableLanguages() -> [ELLocale] {
    return [.DE, .EN]
  }

  func persistWSLocale() {
    UserDefaults.standard.set(rawValue, forKey: UserDefaultsKeys.regionCode)
  }

  static func getStoredWSLocale() -> ELLocale {
    guard let storedRegionCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.regionCode),
          let wsLocale = ELLocale.init(rawValue: storedRegionCode)
    else { return .EN }
    return wsLocale
  }

  static func regionHasChanged() -> Bool {
    guard let storedRegionCode = UserDefaults.standard.string(forKey: UserDefaultsKeys.regionCode),
          let currentRegionCode = Locale.autoupdatingCurrent.region?.identifier
    else { return true }

    if storedRegionCode == currentRegionCode {
      return false
    } else {
      return true
    }
  }

  static func wsLocaleBasedOnRegion() -> ELLocale {
    guard
      let regionCode = Locale.autoupdatingCurrent.region,
      let wsLocale = ELLocale.init(rawValue: regionCode.identifier)
    else { return .EN }

    return wsLocale
  }
}
