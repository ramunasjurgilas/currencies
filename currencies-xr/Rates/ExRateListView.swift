//
//  ExRateListView.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import SwiftUI
import CoreData

struct ExRateListView: View {
    @Environment(\.managedObjectContext)
    var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CurrencyPair.added, ascending: true)],
        animation: .default)

    var currencyPairs: FetchedResults<CurrencyPair>
    let model = ExRateListViewModel()

    @State var isCurrencyPickerPresented: Bool = false
    @State var amount: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                if currencyPairs.count > 0 {
                    Button(action: {
                        self.model.stop()
                        self.isCurrencyPickerPresented.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .padding(16)
                        Text("button_title_add_add_currency_pair")
                    }
                    VStack(alignment: .center) {
                        TextField("placeholder_enter_amount", text: self.$amount)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                    }


                    List {
                        ForEach(self.currencyPairs) { pair in
                            CurrencyPairRowView(model: pair, value: self.amountToConvert(), exRate: pair.exchangeRate)
                        }.onDelete { indices in
                            self.currencyPairs.delete(at: indices, from: self.viewContext)
                        }
                    }
                    .onAppear {
                        self.model.start()
                    }
                    .onDisappear {
                        self.model.stop()
                    }
                } else {
                    VStack(alignment: .center) {
                        Button(action: {
                            self.isCurrencyPickerPresented.toggle()
                        }) {
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
            }
            .navigationBarItems(leading: EditButton())
            .navigationBarTitle("title_rate_converter", displayMode: .inline)
            .sheet(isPresented: self.$isCurrencyPickerPresented) {
                NavigationView {
                    CurrenciesListView(model: CurrenciesListViewModel(), isPresented: self.$isCurrencyPickerPresented).environment(\.managedObjectContext, self.viewContext)
                    
                }
                .onDisappear {
                    self.model.start()
                }
            }
        }
    }

    private func amountToConvert() -> Double {
        return Double(amount) ?? 1
    }
}

struct ExRateListView_Previews: PreviewProvider {
    static var previews: some View {
        ExRateListView().colorScheme(.dark)
    }
}
