//
//  AthleteTest.swift
//  UFCAthleteListDemoTests
//
//  Created by 洪崧傑 on 2023/4/20.
//

import XCTest
@testable import UFCAthleteListDemo

final class AthleteTest: XCTestCase {

    func testAthleteDebugDescription() throws {
        let subjectUnderTest = Athlete(
            named: "Conor",
            description: "0-0-0",
            image: "0"
        )
        
        let actualValue = subjectUnderTest.description
        
        let expectedValue = "0-0-0"
        XCTAssertEqual(actualValue, expectedValue)
    }

}
