//
//  CurrencyDetailView.swift
//  CurrencyExchange
//
//  Created by Mradul Kumar on 17/09/24.
//

import SwiftUI

struct CurrencyDetailView: View {
    
    let cardWidth = UIScreen.main.bounds.width*0.8
    let cardHeight = 250.0
    
    let baseCurrency: CurrencyData
    let currency: CurrencyData
    let amount: Double
    
    @Binding var isShowingDetail: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                let title = "\(amount) \(baseCurrency.currencyCode) is euqal to \(currency.value) \(currency.currencyCode)"
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                
                Spacer()
                
                if amount != 1 {
                    let text = "* \(1) \(baseCurrency.currencyCode) is euqal to \(currency.value/(baseCurrency.value*amount)) \(currency.currencyCode)"
                    Text(text)
                        .multilineTextAlignment(.center)
                        .font(.body)
                        .padding()
                }
                
                Spacer()
            }
        }
        .frame(width: cardWidth, height: cardHeight, alignment: .center)
        .background(Color(.systemBackground))
        .cornerRadius(24.0)
        .shadow(radius: 40)
        .overlay(DismissButton(isShowingModel: $isShowingDetail), alignment: .topTrailing)
    }
}

struct AppetizerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyDetailView(baseCurrency: CurrencyData(currencyCode: "USD", value: 10),
                           currency: CurrencyData(currencyCode: "INR", value: 830.99),
                           amount: 10,
                           isShowingDetail: .constant(false))
    }
}

struct NutritionInfo: View {
    
    let title: String
    let value: Int
    
    var body: some View {
        VStack {
            Text(title)
                .font(.title2)
            
            Text("\(value)")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .italic()
        }
    }
}
