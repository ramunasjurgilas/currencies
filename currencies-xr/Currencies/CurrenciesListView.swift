//
//  CurrenciesListView.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import SwiftUI
import Combine
import CoreData

struct CurrenciesListView: View {
    @Environment(\.managedObjectContext)
    var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Currency.name, ascending: true)],
        animation: .default)
    var currencies: FetchedResults<Currency>
    
    var model: CurrenciesListViewModel
    
    @State var shouldPresent2ndCurrency = false
    @Binding var isPresented: Bool
    
    var body: some View {
        List {
            ForEach(currencies, id: \.self) { currency in
                Button(action: {
                    self.model.set(currency: currency.name)
                    if self.model.isSetupDone {
                        self.model.save(in: self.viewContext)
                        self.isPresented.toggle()
                    } else {
                        self.shouldPresent2ndCurrency.toggle()
                    }
                }, label: {
                    HStack {
                        Image(currency.name!.lowercased())
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24, alignment: .center)
                        Text(currency.name!)
                            .foregroundColor(.gray)
                        Text(currency.name!.localizedCurrencyName ?? "")

                    }
                })
                    .accessibility(identifier: currency.name!)
                    .disabled(self.model.shouldDisableButtonFor(currency: currency.name!))
            }
        }
        .navigationBarItems(leading: NavigationLink(destination: currenciesListView(), isActive: self.$shouldPresent2ndCurrency) {
            EmptyView()
        })
            .navigationBarTitle(model.title)
            .onAppear {
                self.loadCurrencies()
        }
    }

    private func currenciesListView() -> CurrenciesListView {
        let model = CurrenciesListViewModel(firstCurrency: self.model.firstCurrency)
        return CurrenciesListView(model: model, isPresented: self.$isPresented)
    }
    
    private func loadCurrencies() {
        guard currencies.count == 0 else { return }
        
        let currencies = Bundle.main.decode([String].self, forResource: "currencies", ofType: "json")
        self.viewContext.perform {
            currencies?.forEach { name in
                Currency.create(in: self.viewContext, name: name)
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
    }
}

extension Currency {
    
    static func create(in managedObjectContext: NSManagedObjectContext, name: String) {
        let newEvent = self.init(context: managedObjectContext)
        newEvent.name = name
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
}

struct CurrenciesListView_Previews: PreviewProvider {
    static var model = CurrenciesListViewModel()
    static var previews: some View {
        CurrenciesListView(model: model, isPresented: .constant(false))
    }
}
