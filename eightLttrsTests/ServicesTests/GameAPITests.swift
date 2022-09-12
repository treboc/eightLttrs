//
//  GameAPITests.swift
//  eightLttrsTests
//
//  Created by Marvin Lee Kobert on 12.09.22.
//

@testable import eightLttrs
import XCTest

final class GameAPITests: XCTestCase {
  var sut: MainViewModel!

  override func setUpWithError() throws {
    sut = MainViewModel()
  }

  override func tearDownWithError() throws {
    sut = nil
  }

  func test_startGame_withLastSession
}
