//
//  MainViewControllerTests.swift
//  WordScrambleTests
//
//  Created by Marvin Lee Kobert on 05.09.22.
//

import XCTest
@testable import WordScramble

class MainViewControllerTests: XCTestCase {
  var sut: MainViewController!

  override func setUpWithError() throws {
    sut = MainViewController(gameService: .init())
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_loadView_setsMainView() {
    XCTAssertNotNil(sut.view as? MainView)
  }

//  func test_viewDidLoad_presentOnboarding_showsOnboardingOnFirstStart() {
//    // Given
//    UserDefaults.standard.removeObject(forKey: UserDefaultsKeys.isFirstStart)
//
//    let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
//    let rootVC = (scene.keyWindow?.rootViewController as? UINavigationController)?.topViewController
//    let presentedVC = rootVC?.presentedViewController
//
//    // Then
//    XCTAssert(presentedVC is OnboardingViewController)
//  }
}
