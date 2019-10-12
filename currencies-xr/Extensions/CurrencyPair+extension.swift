//
//  CurrencyPair+extension.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import CoreData

extension CurrencyPair {
    static func create(in managedObjectContext: NSManagedObjectContext, pair: String) {
        let newPair = self.init(context: managedObjectContext)
        newPair.pair = pair
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension CurrencyPair: Identifiable {
    
}
