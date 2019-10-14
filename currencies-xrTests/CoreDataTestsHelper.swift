//
//  CoreDataTestsHelper.swift
//  currencies-xrTests
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import Foundation
import CoreData
@testable import currencies_xr

class CoreDataTestsHelper {
    static let shared = CoreDataTestsHelper()
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "currencies_xr")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func currencyPairs() -> [CurrencyPair]? {
        let fetchRequest: NSFetchRequest<CurrencyPair> = CurrencyPair.fetchRequest()
        return try? persistentContainer.viewContext.fetch(fetchRequest)
    }

    func clean() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CurrencyPair.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? persistentContainer.viewContext.execute(deleteRequest)
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print("Error on cleaning", error)
        }
    }

    func clearCoreDataStore() {
        let entities = persistentContainer.managedObjectModel.entities
        for entity in entities {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
            let deleteReqest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try persistentContainer.viewContext.execute(deleteReqest)
            } catch {
                print(error)
            }
        }
    }
}
