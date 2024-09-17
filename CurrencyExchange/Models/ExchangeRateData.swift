//
//  ExchangeRateData.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 12/09/24.
//

import Foundation

///
struct ExchangeRateData: Codable {
    var disclaimer: String?
    var license: String?
    var timestamp: TimeInterval?
    var base: String?
    var rates: [String: Double]?
    
    init() {
        disclaimer = nil
        license = nil
        timestamp = nil
        base = nil
        rates = nil
    }
}

struct CurrencyData: Identifiable {
    var id = UUID()
    var currencyCode: String
    var value: Double
}
