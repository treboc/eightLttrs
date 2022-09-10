//
//  PersistenceStore.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//

import Foundation
import CoreData

class PersistenceStore {
  static let shared = PersistenceStore()

  var container: NSPersistentContainer
  let context: NSManagedObjectContext

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "WordScramble")
    context = container.viewContext

    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }

    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved loadPersistentStores error \(error), \(error.userInfo)")
      }
    })
  }
}

// SwiftUI Previews
extension PersistenceStore {
  static var preview: PersistenceStore = {
    let store = PersistenceStore(inMemory: true)
    for i in 0..<10 {
      let session = Session(context: store.context)
      session.id = UUID()
      session.playerName = "Brunhilde"
      session.baseword = "Sandsack"
      session.usedWords = ["Sand", "Sack"]
      session.score = 20
      session.possibleWords = Array(repeating: session.usedWords.randomElement()!, count: 3)
      session.maxPossibleWordsOnBaseWord = 62
      session.maxPossibleScoreOnBaseWord = 231
      session.localeIdentifier = "DE"
      session.isFinished = true
    }
    return store
  }()

  fileprivate static func makePreviewSession() -> Session {
    return .newSession()
  }
}
