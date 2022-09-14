//
//  SessionServiceTests.swift
//  eightLttrsTests
//
//  Created by Marvin Lee Kobert on 11.09.22.
//

@testable import eightLttrs
import CoreData
import XCTest

final class SessionServiceTests: XCTestCase {
  var container: NSPersistentContainer!
  var context: NSManagedObjectContext {
    return container.viewContext
  }

  override func setUpWithError() throws {
    container = NSPersistentContainer(name: "eightLttrs")
    container.persistentStoreDescriptions[0].url = URL(fileURLWithPath: "/dev/null")
    container.loadPersistentStores { (description, error) in
      XCTAssertNil(error)
    }
  }

  override func tearDownWithError() throws {
    container = nil
  }

  func test_allObjects_shouldReturn3_when3ObjectsInstantiated() {
    // Arrange
    for _ in 0..<3 {
      let _ = Session(using: context)
    }

    // Act
    let expectedSession = 3
    let allSessions = SessionService.allObjects(Session.self, in: context).count

    // Assert
    XCTAssertEqual(expectedSession, allSessions)
  }

  func test_allObjects_shouldReturn0_whenNoObjectsInstantiated() {
    // Arrange
    let expectedSession = 0

    // Act
    let allSessions = SessionService.allObjects(Session.self, in: context).count

    // Assert
    XCTAssertEqual(expectedSession, allSessions)
  }

  func test_loadHighscores_shouldOnlyReturnFinishedSessions() {
    // Arrange
    for i in 0..<10 {
      let session = Session(using: context)
      if i.isMultiple(of: 2) { session.isFinished = true }
    }

    // Act
    let expectedFinishedSessions = 5
    let finishedSessions = SessionService.loadHighscores(in: context).count

    // Assert
    XCTAssertEqual(expectedFinishedSessions, finishedSessions)
  }

  func test_returnLastSession_shouldReturnUnfinishedSession() {
    // Arrange
    var unfinishedSessionID: UUID!

    for i in 0..<3 {
      let session = Session(using: context)
      session.id = UUID()
      if i.isMultiple(of: 2) {
        session.isFinished = true
      } else {
        session.isFinished = false
        unfinishedSessionID = session.id
      }
    }

    // Act
    let expectedSession = SessionService.returnLastSession(in: context)

    // Assert
    XCTAssertEqual(unfinishedSessionID, expectedSession?.id)
  }

  func test_returnLastSession_shouldDeleteAllOtherUnfinishedSessions() {
    // Arrange
    for _ in 0..<3 {
      let session = Session(using: context)
      session.isFinished = false
    }

    // Act
    let _ = SessionService.returnLastSession(in: context)
    let sessionCount = SessionService.allObjects(Session.self, in: context).count
    let expectedSessionCount = 1

    // Assert
    XCTAssertEqual(sessionCount, expectedSessionCount)
  }

  func test_lastOpenSessionHasWords_given3Words_shouldReturnTrue() {
    // Arrange
    let session = Session(using: context)
    session.usedWords = ["Taube", "Taubenei", "taub"]
    session.isFinished = false

    // Act
    let expected = SessionService.lastOpenSessionHasWords(in: context)

    // Assert
    XCTAssertTrue(expected)
  }

  func test_persistFinished_shouldSetName_whenGivenThomas() {
    // Arrange
    let session = Session(using: context)

    // Act
    SessionService.persistFinished(session: session, forPlayer: "Thomas")

    // Assert
    XCTAssertTrue(session.isFinished)
    XCTAssertEqual("Thomas", session.unwrappedName)
  }

  func test_persist_shouldSaveSession() {
    // Arrange
    let session = Session(using: context)
    session.usedWords.append("Hello")
    session.isFinished = false

    // Act
    SessionService.persist(session: session)
    XCTAssert(session.usedWords.count == 1)

    // Assert
    let savedSession = SessionService.returnLastSession(in: context)
    XCTAssertNotNil(savedSession)
  }
}
