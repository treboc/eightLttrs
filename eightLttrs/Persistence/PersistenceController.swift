//
//  PersistenceController.swift
//  WordScramble
//
//  Created by Marvin Lee Kobert on 21.08.22.
//

import Foundation
import CoreData

struct PersistenceController {
  static let shared = PersistenceController()

  var container: NSPersistentContainer
  let context: NSManagedObjectContext

  init(inMemory: Bool = false) {
    container = NSPersistentContainer(name: "eightLttrs")

    if inMemory {
      container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved loadPersistentStores error \(error), \(error.userInfo)")
      }
    })

    context = container.viewContext
    context.automaticallyMergesChangesFromParent = true
    context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

  }

  func chieldViewContext() -> NSManagedObjectContext {
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.parent = container.viewContext
    return context
  }

  func copyForEditing<T: NSManagedObject>(of object: T,
                                          in context: NSManagedObjectContext) -> T {
    guard let object = (try? context.existingObject(with: object.objectID)) as? T else {
      fatalError("Requested copy of a managed object that does not exist.")
    }

    return object
  }

  func persist(_ object: NSManagedObject) throws {
    try object.managedObjectContext?.save()

    if let parent = object.managedObjectContext?.parent {
      try parent.save()
    }
  }
}

// SwiftUI Previews
extension PersistenceController {
  static var preview: PersistenceController = {
    let store = PersistenceController(inMemory: true)
    for i in 0..<10 {
      let session = Session(context: store.context)
      session.id = UUID()
      session.playerName = "Brunhilde"
      session.baseword = "Sandsack"
      session.usedWords = ["Sand", "Sack", "Sacke", "Sacken", "Sandsack", "Sandsac"]
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
    return .newSession(with: "Taubenei")
  }
}
