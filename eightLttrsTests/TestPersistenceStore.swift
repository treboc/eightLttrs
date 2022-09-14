//
//  TestPersistenceStore.swift
//  eightLttrsTests
//
//  Created by Marvin Lee Kobert on 13.09.22.
//

import CoreData

class TestPersistenceStore {
  var container: NSPersistentContainer
  let context: NSManagedObjectContext

  init() {
    container = NSPersistentContainer(name: "eightLttrs")
    context = container.viewContext

    container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")

    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved loadPersistentStores error \(error), \(error.userInfo)")
      }
    })
  }
}
