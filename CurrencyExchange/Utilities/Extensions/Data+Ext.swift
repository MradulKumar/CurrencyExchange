//
//  Data+Ext.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 15/09/24.
//

import Foundation

extension Data {
    
    func toJson() throws -> Any {
        guard let json = try JSONSerialization.jsonObject(with: self,
                                                          options: [.allowFragments]) as? [String: Any] else { throw DataError.unableToDecode }
        return json
    }
    
    func decodeTo<T: Codable>(_ value: T.Type) throws -> T {
        do {
            let values = try JSONDecoder().decode(value, from: self)
            return values as T
        } catch {
            throw error
        }
    }
}
