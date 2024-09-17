//
//  DismissButton.swift
//  CurrencyExchange
//
//  Created by Mradul Kumar on 17/09/24.
//

import SwiftUI

struct DismissButton: View {
    
    @Binding var isShowingModel: Bool
    
    var body: some View {
        HStack {
            Spacer()
            Button {
                isShowingModel = false
            } label: {
                ZStack {
                    Circle()
                        .frame(width: 40, height: 40, alignment: .center)
                        .foregroundColor(.black)
                        .opacity(0.4)
                    
                    Image(systemName: "xmark")
                        .foregroundColor(Color.white)
                        .imageScale(.large)
                }
                .padding(8)
            }
        }
    }
}

struct DismissButton_Previews: PreviewProvider {
    static var previews: some View {
        DismissButton(isShowingModel: .constant(false))
    }
}
