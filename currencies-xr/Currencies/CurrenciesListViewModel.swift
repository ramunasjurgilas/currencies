//
//  CurrenciesListViewModel.swift
//  currencies-xr
//
//  Created by Ramūnas Jurgilas on 13/10/2019.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import Foundation
import CoreData
import SwiftUI

class CurrenciesListViewModel {
    var firstCurrency: String?
    var secondCurrency: String?

    var title: String {
        NSLocalizedString(firstCurrency == nil ? "title_1st_currency" : "title_2nd_currency", comment: "")
    }

    var isSetupDone: Bool {
        (firstCurrency != nil && secondCurrency != nil)
    }

    init(firstCurrency: String? = nil) {
        self.firstCurrency = firstCurrency
    }

    func set(currency: String?) {
        if firstCurrency == nil {
            firstCurrency = currency
        } else {
            secondCurrency = currency
        }
    }

    func save(in managedObjectContext: NSManagedObjectContext) {
        guard let first = firstCurrency, let second = secondCurrency else { return }
        let pair = first + second

        CurrencyPair.create(in: managedObjectContext, pair: pair)
    }

    func shouldDisableButtonFor(currency: String) -> Bool {
        return firstCurrency == currency
    }
}
