//
//  WordServiceTests.swift
//  WordServiceTests
//
//  Created by Marvin Lee Kobert on 11.08.22.
//

import XCTest
@testable import eightLttrs

final class WordServiceTests: XCTestCase {
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

  func test_getNewBaseordWith_GermanLocale_shouldSetGermanBaseWord() {
    // Arrange
    var testBaseword: String = ""
    let allBasewords = WordService.loadBasewords(.DE)

    // Act
    let (baseword, _, _) = WordService.getNewBasewordWith(.DE)
    testBaseword = baseword

    // Assert
    XCTAssertTrue(allBasewords.contains(testBaseword))
  }

  func test_getNewBaseordWith_EnglishLocale_shouldSetEnglishBaseWord() {
    // Arrange
    var testBaseword: String = ""
    let allBasewords = WordService.loadBasewords(.EN)

    // Act
    let (baseword, _, _) = WordService.getNewBasewordWith(.EN)
    testBaseword = baseword

    // Assert
    XCTAssertTrue(allBasewords.contains(testBaseword))
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

  func test_getLocale_forHolzzaun_shouldReturn_DE() {
    // Arrange
    let baseword = "Holzzaun"
    let storedLocale: WSLocale = .EN
    storedLocale.persistWSLocale()

    // Act
    let locale = WordService.getLocale(for: baseword)

    // Assert
    XCTAssertEqual(locale, .DE)
  }

  func test_getLocale_fordDemeaned_shouldReturn_DE() {
    // Arrange
    let baseword = "demeaned"
    let storedLocale: WSLocale = .DE
    storedLocale.persistWSLocale()

    // Act
    let locale = WordService.getLocale(for: baseword)

    // Assert
    XCTAssertEqual(locale, .EN)
  }

  func test_getAllPossibleWords_forTaubenei_shouldContain_Taube() {
    // Arrange
    let baseword = "Taubenei"
    var possibleWords = Set<String>()

    // Act
    let (list, _) = WordService.getAllPossibleWords(for: baseword)
    possibleWords = list

    // Assert
    XCTAssertTrue(possibleWords.contains("Taube"))
  }

  func test_getAllPossibleWords_forDemeaned_shouldContain_mean() {
    // Arrange
    let baseword = "demeaned"
    var possibleWords = Set<String>()

    // Act
    let (list, _) = WordService.getAllPossibleWords(for: baseword)
    possibleWords = list

    // Assert
    XCTAssertTrue(possibleWords.contains("mean"))
  }

  func test_getAllPossibleWordsFor_shouldReturnWordsAndScore() {
    // Given
    let input = "Taubenei"

    // When
    let expectation = self.expectation(description: "LoadingWords")
    var expectedWords: Set<String> = []
    var expectedScore: Int = 0

    WordService.getAllPossibleWordsFor(input, withLocale: .DE) { words, score in
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
