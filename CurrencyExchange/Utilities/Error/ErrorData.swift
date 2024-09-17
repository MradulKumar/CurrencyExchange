//
//  ErrorData.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 13/09/24.
//

import Foundation

// API/Network error codes
enum NetworkError: Error {
    case invalidURL
    case unableToComplete
    case invalidResponse
    case invalidData
}

// Data error codes
enum DataError: Error {
    case unknown
    case invalidURL
    case unableToEncode
    case unableToDecode
    case unableToConvertToJson
}
