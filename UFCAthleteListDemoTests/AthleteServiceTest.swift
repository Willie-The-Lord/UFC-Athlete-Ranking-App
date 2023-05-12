//
//  AthleteServiceTest.swift
//  UFCAthleteListDemoTests
//
//  Created by 洪崧傑 on 2023/4/20.
//

import XCTest
@testable import UFCAthleteListDemo

final class AthleteServiceTest: XCTestCase {
    var systemUnderTest: UFCService!
    

    override func setUpWithError() throws {
        self.systemUnderTest = UFCService()
    }

    override func tearDownWithError() throws {
        self.systemUnderTest = nil
    }

    func testAPI_returnsSuccessfulResult() throws {
        // Given
        var athletes: [Athlete]!
        var error: Error?
        
        let promise = expectation(description: "Completion handler is invoked")
        
        // When
        self.systemUnderTest.getAthletes(completion: { data, shouldntHappen in
            athletes = data
            error = shouldntHappen
            promise.fulfill()
        })
        wait(for: [promise], timeout: 5)
        
        // Then
        XCTAssertNotNil(athletes)
        XCTAssertNil(error)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
