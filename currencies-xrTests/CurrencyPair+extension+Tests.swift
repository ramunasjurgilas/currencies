//
//  CurrencyPair+extension+Tests.swift
//  currencies-xrTests
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import XCTest
import CoreData
@testable import currencies_xr

class CurrencyPairTests: XCTestCase {

    var currencyPair = CurrencyPairTests.currencyPair(with: "USDEUR", exchangeRate: 0.7618)

    func testFirstCurrency() {
        XCTAssertEqual(currencyPair.firstCurrency, "USD")
    }
    
    func testSecondCurrency() {
        XCTAssertEqual(currencyPair.secondCurrency, "EUR")
    }
    
    func testFirstCurrencyTitle() {
        XCTAssertEqual(currencyPair.firstCurrencyTitle(with: 100), "100 USD")
    }
    
    func testFirstCurrencySubtitle() {
        XCTAssertEqual(currencyPair.firstCurrencySubtitle, "US Dollar")
    }

    func testSecondCurrencyTitle() {
        XCTAssertEqual(currencyPair.secondCurrencyTitle(with: 1500), "1,142.70")
    }
    
    func testSecondCurrencySubtitle() {
        XCTAssertEqual(currencyPair.secondCurrencySubtitle, "Euro · EUR")
    }
    
    func testValueAfterExchange() {
        XCTAssertEqual(currencyPair.valueAfterExchange(with: 1500), 1142.7)
    }

    func testDelete() {
        CoreDataTestsHelper.shared.clearCoreDataStore()
        let context = CoreDataTestsHelper.shared.persistentContainer.viewContext
        CurrencyPair.create(in: context, pair: "LTUGBP")
        CurrencyPair.create(in: context, pair: "XXXXXX")
        CurrencyPair.create(in: context, pair: "LTUERU")

        let pairs = CoreDataTestsHelper.shared.currencyPairs()
        let index = pairs?.lastIndex(where: { (pair) -> Bool in
            pair.pair == "XXXXXX"
        })
        pairs?.delete(at: [index!], from: context)

        let pairsAfterDeletion = CoreDataTestsHelper.shared.currencyPairs()
        XCTAssertNil(pairsAfterDeletion?.first { $0.pair == "XXXXXX" } )
    }

    static func currencyPair(with pair: String, exchangeRate: Double = 0) -> CurrencyPair {
        let context = CoreDataTestsHelper.shared.persistentContainer.viewContext
        let currencyPair = CurrencyPair(context: context)
        currencyPair.pair = pair
        currencyPair.exchangeRate = exchangeRate
        
        return currencyPair
    }
}
