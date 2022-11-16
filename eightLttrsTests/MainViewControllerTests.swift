//
//  MainViewControllerTests.swift
//  eightLttrsTests
//
//  Created by Marvin Lee Kobert on 13.09.22.
//

import XCTest
@testable import eightLttrs

final class MainViewControllerTests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func test_viewDidLoad_shouldPresentOnboarding_ifIsFirstStart() {
    // Arrange
    UserDefaults.standard.removeObject(forKey: UserDefaults.Keys.isFirstStart)

    // Act

    // Assert
  }

}
