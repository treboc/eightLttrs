//
//  AppDelegate.swift
//  eightLttrs
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // german for de/at/ch, else en
    let wsLocale = ELLocale.wsLocaleBasedOnRegion()
    application.accessibilityLanguage = Locale.autoupdatingCurrent.language.region?.identifier

    // register settings
    UserDefaults.standard.register(
      defaults: [
        UserDefaults.Keys.appearance: "system",
        UserDefaults.Keys.regionCode: wsLocale.rawValue,
        UserDefaults.Keys.enabledVibration: true,
        UserDefaults.Keys.enabledSound: true,
        UserDefaults.Keys.setVolume: 0.5,
        UserDefaults.Keys.enabledFiltering: true,
        UserDefaults.Keys.flagUppercaseHintAlreadyShown: false
      ]
    )
    return true
  }
}
