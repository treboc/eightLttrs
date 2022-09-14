//
//  GameAPITests.swift
//  eightLttrsTests
//
//  Created by Marvin Lee Kobert on 12.09.22.
//

@testable import eightLttrs
import CoreData
import XCTest

final class GameAPITests: XCTestCase {
  var sut: GameAPI!
  var moc: NSManagedObjectContext!

  override func setUpWithError() throws {
    sut = GameAPI()
    let store = PersistenceController(inMemory: true)
    moc = store.context
  }

  override func tearDownWithError() throws {
    sut = nil
    moc = nil
  }

  func test_startGame_withUnfinishedSession_shouldReturnThisSession() {
    // Arrange
    let session = Session(using: moc)
    session.isFinished = false
    session.id = UUID()
    try? moc.save()
    let id = session.id

    // Act
    let expectedSession = sut.startGame(.continueLastSession, in: moc)

    // Assert
    XCTAssertEqual(expectedSession.id, id)
  }

  func test_startGame_withoutUnfinishedSession_shouldReturnRndSession() {
    // Arrange
    let expectedSession = sut.startGame(in: moc)

    // Assert
    XCTAssertNotNil(expectedSession.baseword)
  }

  func test_startGame_withBaseword_shouldReturnSessionWithBaseword() {
    // Arrange
    let baseword = "Taubenei"
    let expectedSession = sut.startGame(.shared(baseword), in: moc)

    // Assert
    XCTAssertEqual(expectedSession.baseword, baseword)
    XCTAssertTrue(expectedSession.possibleWordsSet.isEmpty == false)
  }

  func test_submit_withValidInput_shouldPersistSession() {
    let session = Session.init(using: moc)
    session.isFinished = false
    session.baseword = "Taubenei"
    session.possibleWords = ["Taube"]

    try? sut.submit("Taube", session: session)

    let expectedUsedWordsCount = 1
    guard let loadedSession = SessionService.returnLastSession(in: moc) else {
      XCTFail()
      return
    }

    XCTAssertEqual(expectedUsedWordsCount, loadedSession.usedWords.count)
  }
}
