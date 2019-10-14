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

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWhenCurrencyPariesExist() {

    }

    func testWhenNoCurrencyPariesEntered() {
    //    CoreDataTestsHelper.shared.clearCoreDataStore()
        let app = XCUIApplication()

        XCTAssertEqual(app.buttons["Add currency pair"].value as! String, "0")
        let addButton = app.buttons["Add currency pair"]
        addButton.tap()
        XCTAssertEqual(app.buttons["Add currency pair"].value as! String, "1")
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["AUD\nAustralian Dollar"]/*[[".cells.buttons[\"AUD\\nAustralian Dollar\"]",".buttons[\"AUD\\nAustralian Dollar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["CHF\nSwiss Franc"]/*[[".cells.buttons[\"CHF\\nSwiss Franc\"]",".buttons[\"CHF\\nSwiss Franc\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .table).element.swipeUp()


    }

    func testDelete() {

    }



}


class CoreDataTestsHelper {
    static let shared = CoreDataTestsHelper()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "currencies_xr")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func currencyPairs() -> [CurrencyPair]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CurrencyPair")
      //  let fetchRequest: NSFetchRequest<CurrencyPair> = CurrencyPair.fetchRequest()
        return try? persistentContainer.viewContext.fetch(fetchRequest) as! [CurrencyPair]
    }

//    func clean() {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CurrencyPair.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//        _ = try? persistentContainer.viewContext.execute(deleteRequest)
//        do {
//            try persistentContainer.viewContext.save()
//        } catch let error {
//            print("Error on cleaning", error)
//        }
//    }
//
//    func clearCoreDataStore() {
//        let entities = persistentContainer.managedObjectModel.entities
//        for entity in entities {
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name!)
//            let deleteReqest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//            do {
//                try persistentContainer.viewContext.execute(deleteReqest)
//            } catch {
//                print(error)
//            }
//        }
//    }
}
