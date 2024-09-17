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
    
    @AppStorage("cachedResponseTTL") private var cachedResponseTTL: TimeInterval?
    
    private init() {
        setUpURLCache()
    }
    
    private func setUpURLCache() {
        let memoryCapacity = 5 * 1024 * 1024 // 5 MB
        let diskCapacity = 20 * 1024 * 1024 // 20 MB
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myCache")
        URLCache.shared = urlCache
    }
    
    private func getExchangeRateUrl(with baseCurrencyCode: String? = nil) -> String {
        var exchangeRateUrl = baseURL + "?app_id=" + appId
        if let base = baseCurrencyCode {
            exchangeRateUrl = exchangeRateUrl + "?base=" + base
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
        
        //check for TTL and response
        //if there is cached response available then
        //return data from cached response
        let currentTimeInterval = Date.timeIntervalSinceReferenceDate
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest),
           (currentTimeInterval < (cachedResponseTTL ?? 0)) {
            if let exchangeRateData = try? cachedResponse.data.decodeTo(ExchangeRateData.self) {
                completion(.success(exchangeRateData))
                return
            }
        }
        
        //remove if there is any cached data for that particular url request
        URLCache.shared.removeCachedResponse(for: urlRequest)
        
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
                let exchangeRateData = try data.decodeTo(ExchangeRateData.self)
                
                let ttl: TimeInterval = 30*60 // 30 Min - 1800 Seconds
                self.cachedResponseTTL = Date.timeIntervalSinceReferenceDate + ttl
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
                
                completion(.success(exchangeRateData))
            } catch {
                completion(.failure(.invalidData))
                return
            }
        }
        
        task.resume()
    }
}
