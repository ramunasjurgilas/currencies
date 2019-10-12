//
//  CurrencyPair+extension.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import CoreData

extension CurrencyPair: Identifiable { }

extension CurrencyPair {
    static func create(in managedObjectContext: NSManagedObjectContext, pair: String, exchangeRate: Double = 0) {
        let newPair = self.init(context: managedObjectContext)
        newPair.pair = pair
        newPair.added = Date()
        newPair.exchangeRate = exchangeRate
        
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

extension Collection where Element == CurrencyPair, Index == Int {
    func delete(at indices: IndexSet, from managedObjectContext: NSManagedObjectContext) {
        indices.forEach { managedObjectContext.delete(self[$0]) }
        
        do {
            try managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

extension CurrencyPair {
    var firstCurrency: String {
        // Exclamation mark, because in CoreData this field must be set.
        return String(pair!.prefix(3))
    }

    var secondCurrency: String {
        // Exclamation mark, because in CoreData this field must be set.
        return String(pair!.suffix(3))
    }
    
    var firstCurrencySubtitle: String {
        return firstCurrency.localizedCurrencyName ?? "NA"
    }
    
    var secondCurrencySubtitle: String {
        return (secondCurrency.localizedCurrencyName ?? "") + " · " + secondCurrency
    }
    
    func firstCurrencyTitle(with value: Double) -> String {
        let formatter = NumberFormatter()
        let amount = formatter.string(from: NSNumber(value: value)) ?? "NA"
        return "\(amount) \(firstCurrency)"
    }
    
    func secondCurrencyTitle(with value: Double) -> String {
        let afterExchange = valueAfterExchange(with: value)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: afterExchange)) ?? "NA"
    }

    func valueAfterExchange(with value: Double) -> Double {
        return value * exchangeRate
    }
}
