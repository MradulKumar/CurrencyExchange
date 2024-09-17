//
//  AlertItem.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 13/09/24.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertItemCases {
    //MARK: - Network Alerts
    static let invalidURL = AlertItem(title: Text("URL Error"),
                                      message: Text("There was an issue in contacting the server. Please check your internet connection. Locally available data is displayed."),
                                      dismissButton: Alert.Button.default(Text("Ok")))
    
    static let invalidResponse = AlertItem(title: Text("Server Error"),
                                           message: Text("Invalid response from the server. Exchange rates will be processed on the basis of local available data.\n\nThe Test API doesn't allow base currency in API request to be changed."),
                                           dismissButton: Alert.Button.default(Text("Ok")))
    
    static let invalidData = AlertItem(title: Text("Server Error"),
                                       message: Text("The data received is invalid. Please try again later or contact support."),
                                       dismissButton: Alert.Button.default(Text("Ok")))
    
    static let unableToComplete = AlertItem(title: Text("Server Error"),
                                            message: Text("Unable to complete your request at this time. Please check your internet connection or contact support."),
                                            dismissButton: Alert.Button.default(Text("Ok")))
}
