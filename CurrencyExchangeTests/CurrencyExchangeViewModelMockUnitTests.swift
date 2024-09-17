//
//  CurrencyExchangeViewModelMockUnitTests.swift
//  CurrencyExchangeTests
//
//  Created by Mradul Kumar on 17/09/24.
//

import XCTest
import Combine
@testable import CurrencyExchange

final class CurrencyExchangeViewModelMockUnitTests: XCTestCase {
    
    private var viewModel: ExchangeRateViewModel!
    private var mockNetwork: MockNetworkManager!
    private let mockDataFileName: String = "ExchangeRateSample"
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewModel = ExchangeRateViewModel()
        mockNetwork = MockNetworkManager(filename: mockDataFileName)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func initializeMockData() async throws {
        //getting data from the mock network file
        let result = await mockNetwork.fetchExchangeRateData()
        switch result {
        case .success(let data):
            // initializing data in view model
            viewModel.exchangeRateData = data
        case .failure:
            XCTAssert(false, "Error in loading sample data file.")
        }
    }
    
    func testMockData() async throws {
        
        print("testMockData - Start")
        
        //initialize Mock Data
        try await initializeMockData()
        
        //testing view model values & methods -
        // exchangeRateData
        XCTAssertNotNil(viewModel.exchangeRateData, "ViewModel - ExchangeRateData should not be NIL")
        
        // currencyList
        XCTAssertNotNil(viewModel.currencyList, "Currency List should not be Nil if data is present.")
        XCTAssert(!viewModel.currencyList.isEmpty, "Currency List should not be empty if data is present.")
        
        // selectedCurrency
        XCTAssertNotNil(viewModel.selectedCurrency, "SelectedCurrency should not be nil if data is present.")
        
        //flags
        XCTAssert(!viewModel.isLoadingFirstTime, "Loading should be set false, data is there")
        XCTAssert(!viewModel.isRefreshing, "Refreshing should be set false, data is there")
        
        print("testMockData - Done - Success")
    }
    
    func testUpdatingAmount() async throws {
        print("testUpdatingAmount - Start")

        //initialize Mock Data
        try await initializeMockData()
        
        let oldCurrencyData = viewModel.currencyList[0]
        
        //update amount
        viewModel.amount = "10"
        
        // check if amount updated
        XCTAssert(viewModel.amount == "10", "Amount not updated")
        
        //check if currency updated
        let newCurrencyData = viewModel.currencyList[0]
     
        XCTAssert(newCurrencyData.value/oldCurrencyData.value == 10.0, "Success - updating the amount")

        print("testUpdatingAmount - Done - Success")
    }
    
    func testUpdatingSelectedCurrency() async throws {
        print("testUpdatingSelectedCurrency - Start")

        //initialize Mock Data
        try await initializeMockData()
        
        let oldCurrencyData = viewModel.currencyList[0]
        
        let selectedCurrency = viewModel.selectedCurrency
        let newSelectedCurrency = viewModel.currencyList[0]

        //update amount
        viewModel.amount = "10"
        
        // check if amount updated
        XCTAssert(viewModel.amount == "10", "Amount not updated")
        
        //check if currency updated
        let newCurrencyData = viewModel.currencyList[0]
     
        XCTAssert(newCurrencyData.value/oldCurrencyData.value == 10.0, "Success - updating the amount")

        print("testUpdatingSelectedCurrency - Done - Success")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
