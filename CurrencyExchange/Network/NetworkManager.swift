//
//  NetworkManager.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 13/09/24.
//

import Foundation
import UIKit
import SwiftUI

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let appId = "5a35ac2fa9c94b7a9b31265a99200879"
    private let baseURL = "https://openexchangerates.org/api/latest.json"
    
    private init() { }
    
    private func getExchangeRateUrl(with baseCurrencyCode: String? = nil) -> String {
        var exchangeRateUrl = baseURL + "?app_id=" + appId
        if let base = baseCurrencyCode {
            exchangeRateUrl = exchangeRateUrl + "&base=" + base
        }
        return exchangeRateUrl
    }
    
    func getExchangeRateData(with baseCurrencyCode: String? = nil, completion: @escaping(Result<ExchangeRateData, NetworkError>) -> Void) {
        
        let apiUrlString = getExchangeRateUrl(with: baseCurrencyCode)
        print("Network Request URL: \(apiUrlString)")
        
        guard let url = URL(string: apiUrlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .returnCacheDataElseLoad
        urlRequest.timeoutInterval = 15.0
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let _ = error {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                //storing data
                StorageManager.shared.saveData(data, forKey: UserDefaultKeys.apiResponseKey)
                
                //data to model
                let exchangeRateData = try data.decodeTo(ExchangeRateData.self)
                completion(.success(exchangeRateData))
            } catch {
                completion(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
}
