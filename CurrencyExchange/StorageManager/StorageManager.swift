//
//  StorageManager.swift
//  CurrencyExchange
//
//  Created by Mradul Kumar on 23/09/24.
//

import Foundation

enum StorageManagerError: Error {
    case saveDataError(String)
    case fetchDataError(String)
}

final class StorageManager {
    static let shared = StorageManager()
    private init() { }
}

extension StorageManager {
    
    func saveData(_ data: Data, forKey key: String) {
        UserDefaults.standard.setValue(data, forKey: key)
    }
    
    func fetchData(forKey key: String) throws -> Data {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
            throw StorageManagerError.fetchDataError("No Data")
        }
        return data
    }
}

extension StorageManager {
    
    func getSavedExchangeData() throws -> ExchangeRateData {
        do {
            let data = try self.fetchData(forKey: UserDefaultKeys.apiResponseKey)
            let exchangeRateData = try data.decodeTo(ExchangeRateData.self)
            return exchangeRateData
        } catch {
            throw error
        }
    }
}

