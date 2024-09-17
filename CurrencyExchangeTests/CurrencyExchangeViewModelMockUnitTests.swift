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
    
    private var viewModel: ExchangeRateViewModel?
    private var mockNetwork: MockNetworkManager?
    private let mockDataFileName: String = "ExchangeRateSample"
    
    override class func setUp() {
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        viewModel = ExchangeRateViewModel()
        mockNetwork = MockNetworkManager(filename: mockDataFileName)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        viewModel = nil
        mockNetwork = nil
    }
    
    func initializeMockData() async throws {
        //getting data from the mock network file
        let result = await mockNetwork?.fetchExchangeRateData()
        switch result {
        case .some(.success(let data)):
            // initializing data in view model
            viewModel?.exchangeRateData = data
        case .failure, .none:
            XCTAssert(false, "Error in loading sample data file.")
        }
    }
    
    func testMockData() async throws {
        
        print("testMockData - Start")
        
        //initialize Mock Data
        try await initializeMockData()
        
        //testing view model values & methods -
        // exchangeRateData
        XCTAssertNotNil(viewModel?.exchangeRateData, "ViewModel - ExchangeRateData should not be NIL")
        
        // currencyList
        XCTAssertNotNil(viewModel?.currencyList != nil, "Currency List should not be Nil if data is present.")
        XCTAssert(viewModel?.currencyList.isEmpty == false, "Currency List should not be empty if data is present.")
        
        // selectedCurrency
        XCTAssertNotNil(viewModel?.selectedCurrency != nil, "SelectedCurrency should not be nil if data is present.")
        
        //flags
        XCTAssert(viewModel?.isLoadingFirstTime == false, "Loading should be set false, data is there")
        XCTAssert(viewModel?.isRefreshing == false, "Refreshing should be set false, data is there")
        
        print("testMockData - Done - Success")
    }
    
    func testUpdatingAmount() async throws {
        print("testUpdatingAmount - Start")
        
        //initialize Mock Data
        try await initializeMockData()
        
        let oldCurrencyData = viewModel?.currencyList[0]
        
        //update amount
        viewModel?.amount = "10"
        
        // check if amount updated
        XCTAssert(viewModel?.amount == "10", "Amount not updated")
        
        //check if currency updated
        let newCurrencyData = viewModel?.currencyList[0]
        
        XCTAssert((newCurrencyData?.value ?? 1)/(oldCurrencyData?.value ?? 1) == 10.0, "Success - updating the amount")
        
        print("testUpdatingAmount - Done - Success")
    }
    
    func testUpdatingSelectedCurrencyAndConversion() async throws {
        print("testUpdatingSelectedCurrency - Start")
        
        //initialize Mock Data
        try await initializeMockData()
        
        if let count = viewModel?.currencyList.count, count <= 1 {
            XCTAssert(true, "Not enough data to update currency")
            return
        }
        
        let usdollar = viewModel?.currencyList.first(where: { $0.currencyCode == AccessibilitiyIdentifiers.usDollar})
        let inrupee = viewModel?.currencyList.first(where: { $0.currencyCode == AccessibilitiyIdentifiers.inRupee})
        let ratio = (inrupee?.value ?? 1)/(usdollar?.value ?? 1)
        
        let oldSelectedCurrency = viewModel?.selectedCurrency
        let newSelectedCurrency = viewModel?.currencyList.first(where: { $0.currencyCode != usdollar?.currencyCode && $0.currencyCode != inrupee?.currencyCode })
        
        //update amount
        viewModel?.selectedCurrency = newSelectedCurrency
        
        // check if amount updated
        XCTAssert(viewModel?.selectedCurrency?.currencyCode != oldSelectedCurrency?.currencyCode, "New Selected Currency Should be updated.")
        
        //check if currency updated
        let usdollarNew = viewModel?.currencyList.first(where: { $0.currencyCode == AccessibilitiyIdentifiers.usDollar})
        let inrupeeNew = viewModel?.currencyList.first(where: { $0.currencyCode == AccessibilitiyIdentifiers.inRupee})
        let ratioNew = (inrupeeNew?.value ?? 1)/(usdollarNew?.value ?? 1)
        
        XCTAssert((ratio == ratioNew), "Success - currency updation, updated the other subsequent currencies respectively.")
        
        print("testUpdatingSelectedCurrency - Done - Success")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measureAsync(for: {
            let _ = await self.mockNetwork?.fetchExchangeRateData()
        })
    }
}

extension XCTestCase {
    
    func measureAsync(
        timeout: TimeInterval = 2.0,
        for block: @escaping () async throws -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        measureMetrics(
            [.wallClockTime],
            automaticallyStartMeasuring: true
        ) {
            let expectation = expectation(description: "finished")
            Task { @MainActor in
                do {
                    try await block()
                    expectation.fulfill()
                } catch {
                    XCTFail(error.localizedDescription, file: file, line: line)
                    expectation.fulfill()
                }
            }
            wait(for: [expectation], timeout: timeout)
        }
    }
}
