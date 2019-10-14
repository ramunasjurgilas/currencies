//
//  ExRateListViewTests.swift
//  currencies-xrUITests
//
//  Created by Ramūnas Jurgilas on 14/10/2019.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import XCTest
import CoreData
@testable import currencies_xr

class ExRateListViewTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        deleteAllCellsFromTable()

    }

    func testAddCurrencyPairWhenListEmptyExistAndCheckLabels() {
        let app = XCUIApplication()
        let tablesQuery = app.tables

        app.buttons["Add currency pair"].tap()

        tablesQuery.buttons["AUD"].tap()
        tablesQuery.buttons["BGN"].tap()

        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        // For some reason needs to do expectation with delay.
        let predicate = NSPredicate(format: "isHittable == true")
        expectation(for: predicate, evaluatedWith: cell.staticTexts["1 AUD"])
        waitForExpectations(timeout: 2)

        XCTAssert(cell.staticTexts["1 AUD"].isHittable)
        XCTAssert(cell.staticTexts["Australian Dollar"].isHittable)
        XCTAssert(cell.staticTexts["Bulgarian Lev · BGN"].isHittable)
    }

    func testAddCurrencyPairWhenListNoneEmptyExist() {
        let app = XCUIApplication()
        let tablesQuery = app.tables

        app.buttons["Add currency pair"].tap()

        tablesQuery.buttons["AUD"].tap()
        tablesQuery.buttons["BGN"].tap()

        app.buttons["Add currency pair"].tap()

        tablesQuery.buttons["GBP"].tap()
        tablesQuery.buttons["EUR"].tap()

        // For some reason needs to do expectation with delay.
        let predicate = NSPredicate(format: "count == 2")
        expectation(for: predicate, evaluatedWith: app.tables.children(matching: .cell))
        waitForExpectations(timeout: 2)

        XCTAssertEqual(app.tables.children(matching: .cell).count, 2)
    }

    func testDeleteCurrencyPairs() {
        let app = XCUIApplication()
        let tablesQuery = XCUIApplication().tables

        app.buttons["Add currency pair"].tap()

        tablesQuery.buttons["AUD"].tap()
        tablesQuery.buttons["BGN"].tap()

        app.navigationBars["Rates & converter"].buttons["Edit"].tap()

        while app.tables.children(matching: .cell).count > 0 {
            let deleteButton = tablesQuery.children(matching: .cell).element(boundBy: 0).buttons["Delete "]

            print("👍", deleteButton.isEnabled)
            deleteButton.tap()

            let deleteButton2 = tablesQuery.children(matching: .cell).element(boundBy: 0).buttons["trailing0"]
            deleteButton2.tap()
        }

        app.navigationBars["Rates & converter"].buttons["Done"].tap()

        XCTAssert(app.staticTexts["Choose a currency pair to compare their live rates"].isHittable)
    }

    func deleteAllCellsFromTable() {
        let app = XCUIApplication()
        let tablesQuery = app.tables

        app.navigationBars["Rates & converter"].buttons["Edit"].tap()

        let predicate = NSPredicate(format: "isHittable == true")
        expectation(for: predicate, evaluatedWith: app.tables.firstMatch)
        waitForExpectations(timeout: 2)


        while app.tables.children(matching: .cell).count > 0 {
            let deleteButton = tablesQuery.children(matching: .cell).element(boundBy: 0).buttons["Delete "]

            let predicate = NSPredicate(format: "isEnabled == true")
            expectation(for: predicate, evaluatedWith: deleteButton)
            waitForExpectations(timeout: 2)

            deleteButton.tap()

            let deleteButton2 = tablesQuery.children(matching: .cell).element(boundBy: 0).buttons["trailing0"]
            deleteButton2.tap()
        }

        app.navigationBars["Rates & converter"].buttons["Done"].tap()
    }

}
