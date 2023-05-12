//
//  AthleteListViewController.swift
//  UFCAthleteListDemoTests
//
//  Created by 洪崧傑 on 2023/4/20.
//

import XCTest
@testable import UFCAthleteListDemo

final class AthleteListViewControllerTest: XCTestCase {
    var systemUnderTest: ViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        self.systemUnderTest = navigationController.topViewController as? ViewController
        
        UIApplication.shared.windows
            .filter { $0.isKeyWindow}
            .first!
            .rootViewController = self.systemUnderTest
        
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(self.systemUnderTest.view)
    }

    

    func testTableView_loadAthletes() throws {
        // Given
        let mockAthleteService = MockUFCService()
        let mockAthletes = [
            Athlete(named: "JON JONES", description: "27-1-0", image: "1"),
            Athlete(named: "ALEXANDER VOLKANOVSKI", description: "25-2-0", image: "2"),
            Athlete(named: "ISLAM MAKHACHEV", description: "24-1-0", image: "3"),
        ]
        mockAthleteService.mockAthletes = mockAthletes
        self.systemUnderTest.viewDidLoad()
        self.systemUnderTest.ufcService = mockAthleteService
        
        XCTAssertEqual(0, self.systemUnderTest.tableView.numberOfRows(inSection: 0))
        
        // When
        self.systemUnderTest.viewWillAppear(false)
        
        // Then
        XCTAssertEqual(mockAthletes.count, self.systemUnderTest.athletes.count)
        XCTAssertEqual(mockAthletes.count, self.systemUnderTest.tableView.numberOfRows(inSection: 0))
        
    }
    
    class MockUFCService: UFCService {
        var mockAthletes: [Athlete]?
        var mockError: Error?
        
        override func getAthletes(completion: @escaping ([Athlete]?, Error?) -> ()) {
            completion(mockAthletes, mockError)
        }
    }
}
