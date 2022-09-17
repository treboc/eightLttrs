//
//  AppDelegate.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // german for de/at/ch, else en
    let wsLocale = WSLocale.wsLocaleBasedOnRegion()

    application.accessibilityLanguage = Locale.autoupdatingCurrent.language.region?.identifier

    // register settings
    UserDefaults.standard.register(
      defaults: [
        UserDefaultsKeys.regionCode: wsLocale.rawValue,
        UserDefaultsKeys.enabledVibration: true,
        UserDefaultsKeys.enabledSound: true,
        UserDefaultsKeys.enabledFiltering: true,
        UserDefaultsKeys.flagUppercaseHintAlreadyShown: false
      ]
    )
    return true
  }
}

