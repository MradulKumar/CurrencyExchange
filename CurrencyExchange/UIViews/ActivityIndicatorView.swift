//
//  ActivityIndicatorView.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 15/09/24.
//

import UIKit
import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = UIColor.darkGray
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {}
    
    
    typealias UIViewType = UIActivityIndicatorView
}

