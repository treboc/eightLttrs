//
//  WordScrambleUITests.swift
//  WordScrambleUITests
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import XCTest
@testable import eightLttrs

final class WordScrambleUITests: XCTestCase {
  let app = XCUIApplication()

  override func setUpWithError() throws {
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
  }

  func testExample() throws {
    let language = Locale.autoupdatingCurrent.language
    setupSnapshot(app)
    app.launch()

    open(language.languageCode == "en" ? "en" : "de")

    app.alerts.matching(identifier: "alertController").buttons.matching(identifier: "continueBtn").element.tap()

    if language.languageCode == "en" {
      input("air")
      input("port")
      input("sport")
      input("airport")
    } else {
      input("Taube")
      input("taub")
      input("Tauben")
      input("taube")
      input("tauben")
    }

    snapshot("0wordlist")

    app.buttons["menuBtn"].tap()
    app.buttons["endSessionBtn"].tap()

    app.alerts.firstMatch.buttons.matching(identifier: "continueBtn").element.tap()

    app.buttons["saveBtn"].tap()

    snapshot("1HighscoreDetail")
  }

  func input(_ word: String) {
    app.textFields["inputField"].tap()
    app.typeText(word)
    app.buttons["submitBtn"].tap()
  }

  func open(_ identifier: String) {
    var baseString = ""

    if identifier == "en" {
      baseString = "wordscramble://baseword/en/airports"
    } else {
      baseString = "wordscramble://baseword/de/Taubenei"
    }
    openFromSafari(baseString)
    XCTAssert(app.wait(for: .runningForeground, timeout: 5))
  }

  private func openFromSafari(_ urlString: String) {
    let safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    safari.launch()

    // Make sure Safari is really running before asserting
    XCTAssert(safari.wait(for: .runningForeground, timeout: 5))

    // Type the deeplink and execute it
    let firstLaunchContinueButton = safari.buttons["Continue"]
    if firstLaunchContinueButton.exists {
      firstLaunchContinueButton.tap()
    }

    safari.textFields["Address"].tap()
    let keyboardTutorialButton = safari.buttons["Continue"]
    if keyboardTutorialButton.exists {
      keyboardTutorialButton.tap()
    }

    safari.typeText(urlString)
    safari.buttons["go"].tap()
    let openButton = safari.buttons["Open"]
    let _ = openButton.waitForExistence(timeout: 2)
    if openButton.exists {
      openButton.tap()
    }
  }
}


