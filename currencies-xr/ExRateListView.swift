//
//  ExRateListView.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import SwiftUI

struct ExRateListView: View {
    @Environment(\.managedObjectContext)
    var viewContext
    
    @State var isCurrencyPickerPresented: Bool = false
    
    var body: some View {
        VStack {
            Button(action: addCurrency) {
                VStack {
                    Image(systemName: "plus.circle.fill")
                    Text("button_title_add_add_currency_pair")
                }
            }
            Text("text_info_choose_currency")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .navigationBarTitle("ExRates")
        .sheet(isPresented: self.$isCurrencyPickerPresented) {
            NavigationView {
                CurrenciesListView(model: CurrenciesListViewModel(), isPresented: self.$isCurrencyPickerPresented).environment(\.managedObjectContext, self.viewContext)
            }
        }
    }
    
    private func addCurrency() {
        isCurrencyPickerPresented.toggle()
    }
}

struct ExRateListView_Previews: PreviewProvider {
    static var previews: some View {
        ExRateListView().colorScheme(.dark)
    }
}
