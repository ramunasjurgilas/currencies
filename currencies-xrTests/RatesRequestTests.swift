//
//  RatesRequestTests.swift
//  currencies-xrTests
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import XCTest
@testable import currencies_xr

class RatesRequestTests: XCTestCase {

    var mockDataFail: Data { Data("koko".utf8) }
    var mockDataOk: Data {
        Data("""
            {"GBPUSD":1.2934,"USDGBP":0.7875}
            """.utf8)
    }

    func testExecuteGenericsSuccess() {
        let session = URLSessionMock()
        session.data = mockDataOk
        let request = RatesRequest(session: session)
        
        let successExpectation = expectation(description: "On success")
        let url = URL(string: "https://revolut.com")!
        request.start(type: [String: Double].self, url: url) { (result) in
            XCTAssertNotNil(result)
            successExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }

    func testExecuteGenericsFail() {
        let session = URLSessionMock()
        session.data = mockDataFail
        let request = RatesRequest(session: session)
        
        let successExpectation = expectation(description: "On fail")
        let url = URL(string: "https://revolut.com")!
        request.start(type: [String: Double].self, url: url) { (result) in
            XCTAssertNil(result)
            successExpectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
}

