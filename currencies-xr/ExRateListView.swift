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
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CurrencyPair.added, ascending: true)],
        animation: .default)
    var currencyPairs: FetchedResults<CurrencyPair>
    
    @State var isCurrencyPickerPresented: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if currencyPairs.count > 0 {
                Button(action: {
                    self.isCurrencyPickerPresented.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .padding(16)
                    Text("button_title_add_add_currency_pair")
                }
                List(currencyPairs) { _ in
                    Text("ko")
                }
            } else {
                Button(action: addCurrency) {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44, alignment: .center)
                        Text("button_title_add_add_currency_pair")
                    }
                }
                Text("text_info_choose_currency")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    
        .navigationBarTitle("ExRates", displayMode: .inline)
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
