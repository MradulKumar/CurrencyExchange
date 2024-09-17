//
//  CurrencyExchangeApiIntegrationTest.swift
//  CurrencyExchangeTests
//
//  Created by Mradul Kumar on 17/09/24.
//

import XCTest
@testable import CurrencyExchange

final class CurrencyExchangeAPIIntegrationTest: XCTestCase {
    
    private var networkManager: NetworkManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        networkManager = NetworkManager.shared
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        networkManager = nil
    }
    
    func test_getExchangeRateData_API_Success() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        Task {
            networkManager.getExchangeRateData { result in
                switch result {
                case .success:
                    XCTAssert(true)
                case .failure:
                    XCTAssert(false)
                }
            }
        }
    }
    
    func test_getExchangeRateData_API_failure() throws {
        Task {
            networkManager.getExchangeRateData(with: "INR") { result in
                switch result {
                case .success:
                    XCTAssert(true)
                case .failure:
                    XCTAssert(false)
                }
            }
        }
    }
}
