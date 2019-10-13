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

class CurrenciesListViewModel {
    var firstCurrency: String?
    var secondCurrency: String?
    
    var title: String {
        firstCurrency == nil ? "1st Currency" : "2nd Currency"
    }
    
    var isSetupDone: Bool {
        (firstCurrency != nil && secondCurrency != nil)
    }
    
    init(firstCurrency: String? = nil) {
        self.firstCurrency = firstCurrency
    }
    
    func set(currency: String?) {
        if firstCurrency == nil {
            firstCurrency = currency
        } else {
            secondCurrency = currency
        }
    }
    
    func save(in managedObjectContext: NSManagedObjectContext) {
        guard let first = firstCurrency, let second = secondCurrency else { return }
        let pair = first + second
        
        CurrencyPair.create(in: managedObjectContext, pair: pair)
    }
    
    func shouldDisableButtonFor(currency: String) -> Bool {
        return firstCurrency == currency
    }
}

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
                        Image(currency.name!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24, alignment: .center)
                        Text(currency.name!)
                        Text(currency.name!.localizedCurrencyName ?? "")
                    }
                })
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
            do {
                try self.viewContext.save()
            } catch let error {
                print(error)
            }
        }
    }
}

extension Currency {
    
    static func create(in managedObjectContext: NSManagedObjectContext, name: String) {
        let newEvent = self.init(context: managedObjectContext)
        newEvent.name = name
        
        do {
            try  managedObjectContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}

struct CurrenciesListView_Previews: PreviewProvider {
    static var model = CurrenciesListViewModel()
    static var previews: some View {
        CurrenciesListView(model: model, isPresented: .constant(false))
    }
}
