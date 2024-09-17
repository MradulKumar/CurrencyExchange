//
//  NoInternetView.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 15/09/24.
//

import Foundation
import SwiftUI

struct NoInternetView: View {
    
    @State var viewModel: ExchangeRateViewModel
    
    init(viewModel: ExchangeRateViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                if viewModel.noInternet {
                    Text(text_noNetworkMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                        .accessibilityIdentifier(AccessibilitiyIdentifiers.noInternetMessage)
                }
                
                if viewModel.isLoadingFirstTime || viewModel.isRefreshing {
                    ActivityIndicator()
                        .accessibilityIdentifier(AccessibilitiyIdentifiers.loadingIndicator)
                }
                
                Button {
                    viewModel.refreshAgain()
                } label: {
                    Text(text_refresh)
                        .font(.title2)
                }
                .padding()
                .accessibilityIdentifier(AccessibilitiyIdentifiers.noInternetRefreshButton)
            }
        }
    }
}
