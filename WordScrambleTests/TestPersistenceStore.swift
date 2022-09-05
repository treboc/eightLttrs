//
//  TestPersistenceStore.swift
//  WordScrambleTests
//
//  Created by Marvin Lee Kobert on 05.09.22.
//

import CoreData
@testable import WordScramble

class TestPersistenceStore: PersistenceStore {
  let shared = TestPersistenceStore(inMemory: true)
}
