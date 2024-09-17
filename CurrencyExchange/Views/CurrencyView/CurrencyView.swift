//
//  CurrencyView.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 13/09/24.
//

import SwiftUI

struct CurrencyView: View {
    
    let currencyCode: String
    let currencyValue: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(currencyCode)
                .font(.title2)
                .fontWeight(.none)
                .scaledToFit()
                .minimumScaleFactor(0.5)

            Text(currencyValue)
                .font(.title2)
                .fontWeight(.semibold)
                .scaledToFit()
                .minimumScaleFactor(0.5)
        }
        .padding()
        .cornerRadius(4.0)
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView(currencyCode: "USD", currencyValue: "1.2345")
    }
}
