//
//  CurrenciesListViewModelTests.swift
//  currencies-xrTests
//
//  Created by Ramūnas Jurgilas on 13/10/2019.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import XCTest
import CoreData
@testable import currencies_xr

class CurrenciesListViewModelTests: XCTestCase {

    func testInitWithParameter() {
        let model = CurrenciesListViewModel()
        XCTAssertNil(model.firstCurrency)
        XCTAssertNil(model.secondCurrency)
    }

    func testInitWithoutParameter() {
        let model = CurrenciesListViewModel(firstCurrency: "LTU")
        XCTAssertEqual(model.firstCurrency, "LTU")
        XCTAssertNil(model.secondCurrency)
    }

    func testTitleMustBeFirst() {
        let model = CurrenciesListViewModel()
        XCTAssertEqual(model.title, "1st Currency")
    }

    func testTitleMustBeSecond() {
        let model = CurrenciesListViewModel(firstCurrency: "LTU")
        XCTAssertEqual(model.title, "2nd Currency")
    }

    func testIsSetupDoneTrue() {
        let model = CurrenciesListViewModel(firstCurrency: "LTU")
        XCTAssertFalse(model.isSetupDone)
    }

    func testIsSetupDoneFalse() {
        let model = CurrenciesListViewModel(firstCurrency: "LTU")
        model.secondCurrency = "GBP"
        XCTAssertTrue(model.isSetupDone)
    }


    func testSetCurrencyAsFirst() {
        let model = CurrenciesListViewModel()
        model.set(currency: "LTU")
        XCTAssertEqual(model.firstCurrency, "LTU")
        XCTAssertNil(model.secondCurrency)
    }

    func testSetCurrencyAsSecond() {
        let model = CurrenciesListViewModel()
        model.set(currency: "LTU")
        model.set(currency: "GBP")
        XCTAssertEqual(model.firstCurrency, "LTU")
        XCTAssertEqual(model.secondCurrency, "GBP")
    }

    func testSaveAsCurrencyPairFail() {
        let context = CoreDataTestsHelper.shared.persistentContainer.viewContext
        let pairsCount = currencyPairs(in: context)!.count
        let model = CurrenciesListViewModel(firstCurrency: "GBP")
        model.save(in: context)

        XCTAssertEqual(pairsCount, currencyPairs(in: context)!.count)
    }

    func testSaveAsCurrencyPairSuccess() {
        let context = CoreDataTestsHelper.shared.persistentContainer.viewContext
        let pairs = currencyPairs(in: context)!
        let model = CurrenciesListViewModel(firstCurrency: "GBP")
        model.set(currency: "LTU")
        model.save(in: context)

        XCTAssertEqual(pairs.count + 1, currencyPairs(in: context)!.count)
        XCTAssertTrue(pairs.contains { $0.pair == "GBPLTU" })
    }


    func testShouldDisableButtonForCurrencyTrue() {
        let model = CurrenciesListViewModel(firstCurrency: "GBP")
        XCTAssertTrue(model.shouldDisableButtonFor(currency: "GBP"))
    }

    func testShouldDisableButtonForCurrencyFalseWhenNoCurrenciesSet() {
        let model = CurrenciesListViewModel()
        XCTAssertFalse(model.shouldDisableButtonFor(currency: "LTU"))
    }

    func testShouldDisableButtonForCurrencyFalseWhenCurrencySet() {
        let model = CurrenciesListViewModel(firstCurrency: "GBP")
        XCTAssertFalse(model.shouldDisableButtonFor(currency: "LTU"))
    }

    private func currencyPairs(in context: NSManagedObjectContext) -> [CurrencyPair]? {
        let fetchRequest: NSFetchRequest<CurrencyPair> = CurrencyPair.fetchRequest()
        return try? context.fetch(fetchRequest)
    }
}
