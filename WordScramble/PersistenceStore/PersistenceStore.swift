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

  var persistentContainer: NSPersistentContainer
  let context: NSManagedObjectContext

  private init() {
    persistentContainer = NSPersistentContainer(name: "WordScramble")

    let description = NSPersistentStoreDescription()
    description.shouldAddStoreAsynchronously = true

    persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

    context = persistentContainer.viewContext

    persistentContainer.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved loadPersistentStores error \(error), \(error.userInfo)")
      }
    })
  }
}
