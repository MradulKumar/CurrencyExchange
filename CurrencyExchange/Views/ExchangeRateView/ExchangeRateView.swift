//
//  ExchangeRateView.swift
//  CurrencyExchanger
//
//  Created by Mradul Kumar on 12/09/24.
//

import SwiftUI

struct ExchangeRateView: View {
    
    var menuWdith: CGFloat = 150
    var buttonHeight: CGFloat = 50
    var maxItemDisplayed: Int = 10
    
    
    @State var showDropdown: Bool = false
    @State private var scrollPosition: Int?
    @State var girdItems: [GridItem] = [GridItem(.flexible(minimum: 50, maximum: 150)),
                                        GridItem(.flexible(minimum: 50, maximum: 150)),
                                        GridItem(.flexible(minimum: 50, maximum: 150))]
    
    @StateObject var viewModel = ExchangeRateViewModel()
    
    var body: some  View {
        ZStack {
            NavigationView {
                VStack {
                    
                    //text field
                    TextField(text_placeholderAmount, text: $viewModel.amount)
                        .textFieldStyle(.roundedBorder)
                        .frame(height: 45, alignment: .center)
                        .padding(.horizontal, 6.0)
                        .background(Color.gray.opacity(0.8).gradient)
                        .cornerRadius(4.0)
                        .submitLabel(.done)
                        .onSubmit {
                            viewModel.updateAmount()
                        }
                        .onTapGesture(perform: {
                            if showDropdown { showDropdown.toggle() }
                        })
                        .accessibilityIdentifier(AccessibilitiyIdentifiers.amountTextField)
                    
                    //space
                    Spacer()
                    
                    //picker
                    HStack {
                        Spacer()
                        VStack {
                            Button(action: {
                                withAnimation {
                                    showDropdown.toggle()
                                }
                            }, label: {
                                HStack(spacing: nil) {
                                    Text(viewModel.selectedCurrency?.currencyCode ?? "---")
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                        .rotationEffect(.degrees((showDropdown ?  -180 : 0)))
                                }
                            })
                            .padding(.horizontal, 16.0)
                            .frame(width: menuWdith, height: buttonHeight, alignment: .trailing)
                            .accessibilityIdentifier(AccessibilitiyIdentifiers.currencySelectionButton)
                            
                            // selection menu
                            if (showDropdown) {
                                
                                let scrollViewHeight: CGFloat = viewModel.currencyList.count > maxItemDisplayed ? (buttonHeight*CGFloat(maxItemDisplayed)) : (buttonHeight*CGFloat(viewModel.currencyList.count))
                                
                                ScrollView {
                                    LazyVStack(spacing: 0) {
                                        ForEach(viewModel.currencyList) { currency in
                                            Button(action: {
                                                withAnimation {
                                                    viewModel.updateSelectedCurrency(currency)
                                                    showDropdown.toggle()
                                                }
                                            }, label: {
                                                HStack {
                                                    Text(currency.currencyCode)
                                                    Spacer()
                                                    if (currency.currencyCode == viewModel.selectedCurrency?.currencyCode) {
                                                        Image(systemName: "checkmark.circle.fill")
                                                    }
                                                }
                                            })
                                            .padding(.horizontal, 20)
                                            .frame(width: menuWdith, height: buttonHeight, alignment: .leading)
                                            .accessibilityIdentifier(viewModel.accessibilityIdentifierFor(currency))
                                        }
                                    }
                                    .scrollTargetLayout()
                                }
                                .frame(width: menuWdith)
                                .scrollPosition(id: $scrollPosition)
                                .scrollDisabled(viewModel.currencyList.count <=  2)
                                .scrollIndicatorsFlash(onAppear: true)
                                .frame(height: scrollViewHeight)
                                .accessibility(identifier: AccessibilitiyIdentifiers.currencyListScrollView)
                            }
                        }
                        .font(.title2)
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .background(RoundedRectangle(cornerRadius: 4.0).fill(Color.gray.opacity(0.8).gradient))
                    }
                    .frame(height: buttonHeight, alignment: .top)
                    .zIndex(1)
                    
                    //space
                    Spacer()
                    
                    //currencies
                    ScrollView {
                        LazyVGrid(columns: girdItems, alignment: .center, spacing: 8.0, content: {
                            ForEach(viewModel.currencyList) { currency in
                                let valueText = String(format: "%0.2f", (currency.value))
                                CurrencyGridCell(currencyCode: currency.currencyCode, currencyValue: valueText)
                                    .onTapGesture {
                                        viewModel.detailViewCurrency = currency
                                        viewModel.isShowingDetail = true
                                    }
                            }
                        })
                    }
                    .cornerRadius(4.0)
                    .refreshable {
                        viewModel.refreshExchangeRateData()
                    }
                    .onTapGesture {
                        if showDropdown { showDropdown.toggle() }
                    }
                    .accessibilityIdentifier(AccessibilitiyIdentifiers.currencyConversionScrollView)
                    
                }
                .padding()
                .navigationTitle(text_navigationTitle)
            }
            .onAppear {
                viewModel.getExchangeRateData()
            }
            
            if viewModel.isLoadingFirstTime {
                LoadingView()
                    .accessibilityIdentifier(AccessibilitiyIdentifiers.loadingView)
            }
            
            if viewModel.noInternet {
                NoInternetView(viewModel: viewModel)
                    .accessibilityIdentifier(AccessibilitiyIdentifiers.noInternetView)
            }
            
            if viewModel.isShowingDetail {
                CurrencyDetailView(baseCurrency: viewModel.selectedCurrency ?? sampleCurrency,
                                   currency: viewModel.detailViewCurrency ?? sampleCurrency,
                                   amount: viewModel.getAmount(),
                                   isShowingDetail: $viewModel.isShowingDetail)
            }
        }
        .alert(item: $viewModel.alertItem) { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        }
    }
}
