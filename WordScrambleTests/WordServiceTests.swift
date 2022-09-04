//
//  WordServiceTests.swift
//  WordServiceTests
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import XCTest
@testable import WordScramble

final class WordServiceTests: XCTestCase {
  override func setUpWithError() throws {
  }

  override func tearDownWithError() throws {
  }

  func test_loadBasewords_withGermanLocale_shouldReturnBasewords() {
    // Arrange
    let regionCode: WSLocale = .DE
    let testWord = "Taubenei"

    // Act
    let basewords = WordService.loadBasewords(regionCode)

    // Assert
    XCTAssert(basewords.contains(testWord))
  }

  func test_loadBasewords_withEnglishLocale_shouldReturnBasewords() {
    // Arrange
    let regionCode: WSLocale = .EN
    let testWord = "candying"

    // Act
    let basewords = WordService.loadBasewords(regionCode)

    // Assert
    XCTAssert(basewords.contains(testWord))
  }

  func test_loadpossibleWords_withGermanLocale_shouldReturnBasewords() {
    // Arrange
    let regionCode: WSLocale = .DE
    let testWord = "Taubenei"

    // Act
    let basewords = WordService.loadPossibleWords(regionCode)

    // Assert
    XCTAssert(basewords.contains(testWord))
  }

  func test_loadpossibleWords_withEnglishLocale_shouldReturnBasewords() {
    // Arrange
    let regionCode: WSLocale = .EN
    let testWord = "candying"

    // Act
    let basewords = WordService.loadPossibleWords(regionCode)

    // Assert
    XCTAssert(basewords.contains(testWord))
  }

  func test_loadBaseAndPossibleWords_withGermanLocale_shouldReturnAllWords() {
    // Arrange
    let regionCode: WSLocale = .DE
    let testBaseword = "Taubenei"
    let testPossibleWord = "Tauben"

    // Act
    let (basewords, possibleWords) = WordService.loadAllWords(regionCode)

    // Assert
    XCTAssert(basewords.contains(testBaseword))
    XCTAssert(possibleWords.contains(testPossibleWord))
  }

  func test_isValidBaseword_withTaubenei_returnsTrue() {
    // Arrange
    let baseword = "Taubenei"
    let basewords: Set<String> = ["Taubenei"]

    // Act
    let isValidBaseword = WordService.isValidBaseword(baseword, in: basewords)

    // Assert
    XCTAssertTrue(isValidBaseword)
  }

  func test_isValidBaseword_withABCDEFGH_returnsFalse() {
    // Arrange
    let baseword = "ABCDEFGH"
    let basewords: Set<String> = ["Taubenei"]

    // Act
    let isValidBaseword = WordService.isValidBaseword(baseword, in: basewords)

    // Assert
    XCTAssertFalse(isValidBaseword)
  }

  func test_validate_withInputHE_throwsError_tooShort() throws {
    // Given
    let input = "He"
    let baseword = "Helium"

    // When
    XCTAssertThrowsError(try WordService.validate(input, baseword: baseword, usedWords: [], possibleWords: Set<String>())) { error in
      XCTAssertEqual(error as! WordError, WordError.tooShort)
    }
  }

  func test_validate_withInputHelium_throwsError_notOriginal() throws {
    // Given
    let input = "Helium"
    let baseword = "Helium"

    // When
    XCTAssertThrowsError(try WordService.validate(input, baseword: baseword, usedWords: [], possibleWords: Set<String>())) { error in
      XCTAssertEqual(error as! WordError, WordError.notOriginal)
    }
  }

  func test_validate_withInputHeliam_throwsError_notPossible() throws {
    // Given
    let input = "Heliam"
    let baseword = "Helium"

    // When
    XCTAssertThrowsError(try WordService.validate(input, baseword: baseword, usedWords: [], possibleWords: Set<String>())) { error in
      XCTAssertEqual(error as! WordError, WordError.notPossible(word: baseword))
    }
  }

  func test_validate_withInputHeliam_throwsError_notReal() throws {
    // Given
    let input = "Hel"
    let possibleWords: Set<String> = []

    // When
    XCTAssertThrowsError(try WordService.validate(input, baseword: "Helium", usedWords: [], possibleWords: possibleWords)) { error in
      XCTAssertEqual(error as! WordError, WordError.notReal)
    }
  }

  func test_getAllPossibleWordsFor_shouldReturnWordsAndScore() {
    // Given
    let input = "Taubenei"
    let wordList: Set<String> = ["Taube", "Taub", "taub"]

    // When
    let expectation = self.expectation(description: "LoadingWords")
    var expectedWords: Set<String> = []
    var expectedScore: Int = 0

    WordService.getAllPossibleWordsFor(input, basedOn: wordList) { words, score in
      expectedWords = words
      expectedScore = score
      expectation.fulfill()
    }

    // Then
    waitForExpectations(timeout: 2, handler: nil)
    XCTAssert(expectedWords.count > 0)
    XCTAssert(expectedScore > 0)
  }
}
