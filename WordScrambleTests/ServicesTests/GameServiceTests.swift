//
//  GameServiceTests.swift
//  WordScrambleTests
//
//  Created by Marvin Lee Kobert on 06.09.22.
//

import XCTest
@testable import WordScramble

final class GameServiceTests: XCTestCase {


  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func test_initWithRandomWord() {
    // Given
    let gameService = GameService()

    // Then
    XCTAssert(!gameService.baseword.isEmpty, "no baseword set")
  }

}
