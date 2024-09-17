//
//  FileManager+Ext.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 12/09/24.
//

import Foundation

enum FileManagerError: Error {
    case fileNotFound
    case fileNotReadable
}

extension FileManager {
    
    func getFilePathFor(fileName: String, ofType type: String) throws -> String {
        guard let path = Bundle.main.path(forResource: fileName, ofType: type) else { throw FileManagerError.fileNotFound }
        return path
    }
    
    func getDataFrom(fileName: String, ofType type: String) throws -> Data {
        do {
            let sampleFilePath = try getFilePathFor(fileName: fileName, ofType: type)
            guard let data = FileManager.default.contents(atPath: sampleFilePath) else { throw FileManagerError.fileNotReadable }
            return data
        } catch {
            throw FileManagerError.fileNotFound
        }
    }
}
