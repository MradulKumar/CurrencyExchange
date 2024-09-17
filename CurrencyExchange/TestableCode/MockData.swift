//
//  MockData.swift
//  CurrencyExchange
//
//  Created by Mradul Kumar on 16/09/24.
//

import Foundation

protocol MockableData: AnyObject {
    var bundle: Bundle { get }
    func loadJson<T: Decodable>(filename: String,
                                extensionType: String,
                                responseModel: T.Type) async -> Result<T, DataError>  where T : Decodable
}

extension MockableData {
    var bundle: Bundle {
        Bundle(for: type(of: self))
    }
    
    func loadJson<T: Decodable>(filename: String,
                                extensionType: String,
                                responseModel: T.Type) async -> Result<T, DataError> {
        guard let path = bundle.url(forResource: filename,
                                    withExtension: extensionType) else {
            return .failure(.invalidURL)
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(.unknown)
        }
    }
}

extension MockableData {
    func getSampleData() async throws -> Result<ExchangeRateData, DataError>  {
        return await loadJson(filename: "ExchangeRateSample", extensionType: ".json", responseModel: ExchangeRateData.self)
    }
}
