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
//    UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isFirstStart)
    continueAfterFailure = false
  }

  override func tearDownWithError() throws {
  }

  func testExample() throws {
    setupSnapshot(app)
    app.launch()
    open(appPath: "")
    app.alerts.matching(identifier: "alertController").buttons.matching(identifier: "continueBtn").element.tap()

    input("Taube")
    input("taub")
    input("Tauben")
    input("taube")
    input("tauben")

    snapshot("0Launch")

    app.buttons["Menu"].tap()

//    let collectionViewsQuery = app.collectionViews
//    collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["End Session"]/*[[".cells.buttons[\"End Session\"]",".buttons[\"End Session\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//    app.alerts["Saving"].scrollViews.otherElements.buttons["Yes, I'm sure"].tap()
//
//    let mKey = app.keys["Marvin"]
//    mKey.tap()
//    mKey.tap()
//    app.buttons["Save"].tap()
//    app.navigationBars["Sumerern"].buttons["Menu"].tap()
//    collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Highscore"]/*[[".cells.buttons[\"Highscore\"]",".buttons[\"Highscore\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//    collectionViewsQuery/*@START_MENU_TOKEN@*/.otherElements["1., M, 53 Points"]/*[[".cells.otherElements[\"1., M, 53 Points\"]",".otherElements[\"1., M, 53 Points\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
//    collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Share Session"].press(forDuration: 1.1);/*[[".cells.buttons[\"Share Session\"]",".tap()",".press(forDuration: 1.1);",".buttons[\"Share Session\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
//    app.navigationBars["Details"].buttons["Highscores"].tap()

  }

  func input(_ word: String) {
    app.textFields["inputField"].tap()
    app.typeText(word)
    app.buttons["submitBtn"].tap()
  }

  func open(appPath pathString: String) {
    openFromSafari("wordscramble://baseword/de/Taubenei")
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


