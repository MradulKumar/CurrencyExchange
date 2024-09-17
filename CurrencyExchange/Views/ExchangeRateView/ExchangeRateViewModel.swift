//
//  ExchangeRateViewModel.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 12/09/24.
//

import Foundation
import SwiftUI

final class ExchangeRateViewModel: ObservableObject {
    
    
    @Published var exchangeRateData: ExchangeRateData = ExchangeRateData() {
        didSet {
            updateCurrencyListFromExchangeData()
            updateSelectedCurrencyFirstTime()
        }
    }
    @Published var currencyList: [CurrencyData] = []
    @Published var selectedCurrency: CurrencyData? {
        didSet {
            refreshExchangeRateAsPerSelectedCurrency(oldValue)
        }
    }
    @Published var amount: String = "1" {
        didSet {
            updateCurrencyListAsPerAmountUpdated()
        }
    }
    
    @Published var alertItem: AlertItem?
    @Published var isLoadingFirstTime: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var noInternet: Bool = false
    
    
    func getExchangeRateData() {
        //showing a progress view on top of everything
        //while fetching the rates for the first time
        isLoadingFirstTime = true
        //setting no internet flag false before request
        noInternet = false
        //fetching data
        fetchExchangeData { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                //hide progressview
                self.isLoadingFirstTime = false
                //processing data
                self.processExchangeRateData(result: result)
            }
        }
    }
    
    func refreshExchangeRateData() {
        //showing a progress view on refresh
        isRefreshing = true
        //setting no internet flag false before request
        noInternet = false
        //fetching data
        fetchExchangeData(with: selectedCurrency?.currencyCode) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                //hide progressview
                self.isRefreshing = false
                //processing data
                self.processExchangeRateData(result: result)
            }
        }
    }
    
    func fetchExchangeData(with baseCurrencyCode: String? = nil,
                           completion: @escaping(Result<ExchangeRateData, NetworkError>) -> Void) {
        NetworkManager.shared.getExchangeRateData(with: baseCurrencyCode) { result in
            completion(result)
        }
    }
    
    func updateSelectedCurrency(_ currency: CurrencyData?) {
        selectedCurrency = currency
    }
    
    func getAmount() -> Double {
        guard let amountNum = Double(amount), amountNum > 0 else {
            amount = "1"
            return 1
        }
        return amountNum
    }
    
    func updateAmount() {
        updateCurrencyListAsPerLocalAvailableData()
    }
    
    func refreshAgain() {
        getExchangeRateData()
    }
    
    func accessibilityIdentifierFor(_ currency: CurrencyData) -> String {
        switch currency.currencyCode {
        case "USD":
            return AccessibilitiyIdentifiers.USDButton
        case "AED":
            return AccessibilitiyIdentifiers.AEDButton
        default:
            return ""
        }
    }
}

private extension ExchangeRateViewModel {
    
    func refreshExchangeRateAsPerSelectedCurrency(_ previousValue: CurrencyData?) {
        if previousValue == nil || previousValue?.currencyCode == selectedCurrency?.currencyCode { return }
        refreshExchangeRateData()
    }
    
    func processExchangeRateData(result: Result<ExchangeRateData, NetworkError>) {
        switch result {
        case .success(let exchangeData):
            exchangeRateData = exchangeData
        case .failure(let error):
            switch error {
            case .invalidURL:
                alertItem = AlertItemCases.invalidURL
            case .invalidResponse:
                alertItem = AlertItemCases.invalidResponse
            case .invalidData:
                alertItem = AlertItemCases.invalidData
            case .unableToComplete:
                alertItem = AlertItemCases.unableToComplete
                noInternet = true
            }
            updateCurrencyListAsPerLocalAvailableData()
        }
    }
    
    func updateCurrencyListFromExchangeData() {
        
        guard let rateList = exchangeRateData.rates, !rateList.isEmpty else {
            alertItem = AlertItemCases.invalidData
            return
        }
        
        let newCurrencyList = rateList.map { (currencyCode, value) in
            let amount = value * getAmount()
            let currency = CurrencyData(currencyCode: currencyCode, value: amount)
            return currency
        }
        
        //sorting currency list
        currencyList = newCurrencyList.sorted(by: { $0.currencyCode < $1.currencyCode})
    }
    
    func updateSelectedCurrencyFirstTime() {
        if let currency = currencyList.first(where: { $0.currencyCode == exchangeRateData.base }) {
            updateSelectedCurrency(currency)
        }
    }
    
    func exchangeRateFrom(currency: CurrencyData, to target: CurrencyData) -> Double {
        guard let baseRate = exchangeRateData.rates?.first(where: { key, value in key == exchangeRateData.base }) else {
            return currency.value
        }
        
        let dollar = CurrencyData(currencyCode: baseRate.key, value: baseRate.value)
        let rate = currency.value*(dollar.value/target.value)*getAmount()
        return rate
    }
    
    func updateCurrencyListAsPerLocalAvailableData() {
        if var target = selectedCurrency {
            
            guard let rateList = exchangeRateData.rates, !rateList.isEmpty else {
                alertItem = AlertItemCases.invalidData
                return
            }
            
            if let targetCurrencyRate = rateList.first(where: { key, value in key == target.currencyCode }) {
                target = CurrencyData(currencyCode: targetCurrencyRate.key, value: targetCurrencyRate.value)
            }
            
            let newCurrencyList = rateList.map { (currencyCode, value) in
                let currency = CurrencyData(currencyCode: currencyCode, value: value)
                let exchangeRate = exchangeRateFrom(currency: currency, to: target)
                return CurrencyData(currencyCode: currencyCode, value: exchangeRate)
            }
            
            currencyList = newCurrencyList.sorted(by: { $0.currencyCode < $1.currencyCode})
        }
    }
    
    func updateCurrencyListAsPerAmountUpdated() {
        updateCurrencyListAsPerLocalAvailableData()
    }
}
