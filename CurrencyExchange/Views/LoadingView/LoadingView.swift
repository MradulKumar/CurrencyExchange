//
//  LoadingView.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 13/09/24.
//

import Foundation
import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            ActivityIndicator()
                .accessibilityIdentifier(AccessibilitiyIdentifiers.loadingIndicator)
        }
    }
}
