//
//  MockNetworkManager.swift
//  CurrencyExchange
//
//  Created by Mradul Kumar on 16/09/24.
//

import Foundation

final class MockNetworkManager: MockableData {
    
    let filename: String
    
    init(filename: String) {
        self.filename = filename
    }
    
    func fetchExchangeRateData() async -> Result<ExchangeRateData, DataError> {
        return await loadJson(filename: filename,
                              extensionType: ".json",
                              responseModel: ExchangeRateData.self)
    }
}
