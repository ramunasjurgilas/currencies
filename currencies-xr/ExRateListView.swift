//
//  ExRateListView.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import SwiftUI

struct ExRateListView: View {
    var body: some View {
        VStack {
            Button(action: addCurrency) {
                VStack {
                    Image("plus-one")
                    Text("button_title_add_add_currency_pair")
                }
            }
            Text("text_info_choose_currency")
                .font(.caption)
                .foregroundColor(.gray)
        }.colorScheme(.dark)
    }
    
    private func addCurrency() {
        
    }
}

struct ExRateListView_Previews: PreviewProvider {
    static var previews: some View {
        ExRateListView().colorScheme(.dark)
    }
}
