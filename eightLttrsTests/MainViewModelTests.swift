//
//  MainViewModelTests.swift
//  eightLttrsTests
//
//  Created by Marvin Lee Kobert on 12.09.22.
//

import Combine
import CoreData
import XCTest
@testable import eightLttrs

final class MainViewModelTests: XCTestCase {
  var sut: MainViewModel!
  var persistenceStore: PersistenceController!

  var context: NSManagedObjectContext {
    return persistenceStore.context
  }

  override func setUpWithError() throws {
    persistenceStore = PersistenceController(inMemory: true)
    let session = makeTestSession(in: context)
    sut = MainViewModel()
    sut.session = session
  }

  override func tearDownWithError() throws {
    sut = nil
    persistenceStore = nil
  }

  func test_submit_validInput_shouldPass() {
    // Arrange
    sut.input.value = "Taube"
    var testPassed = false

    // Act
    sut.submit {
      testPassed = true
    }

    // Assert
    XCTAssertTrue(testPassed)
  }

  func test_submit_withInvalidInput_shouldSetError() {
    // Arrange
    sut.input.value = "Tau"
    var testPassed = true

    _ = sut.error
      .map { $0 != nil }
      .sink { bool in
        testPassed = bool
      }

    // Act
    sut.submit {}

    // Assert
    XCTAssertFalse(testPassed)
  }

  func test_startNewSession_shouldOverwriteCurrentSession() {
    // Arrange
    let idOldSession = sut.session.id

    // Act
    sut.startNewSession()

    // Assert
    let idNewSession = sut.session.id
    XCTAssertNotEqual(idOldSession, idNewSession)
  }
}

fileprivate extension MainViewModelTests {
  func makeTestSession(in context: NSManagedObjectContext) -> Session {
    let session = Session(using: context)
    session.id = UUID()
    session.isFinished = false
    session.baseWord = "Taubenei"
    session.possibleWords = ["Taube", "Tauben", "Taub"]
    return session
  }
}
