//
//  ExRateListView.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import SwiftUI
import CoreData

class ExRateListViewModel {
    private var timer: Timer?
    private var shouldStop = false
    private let ratesRequest = RatesRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func start() {
        shouldStop = false
        execute()
    }
    
    func stop() {
        shouldStop = true
        timer?.invalidate()
    }
    
    func execute() {
        guard shouldStop == false,
            let currencyPairs = currencyPairs(),
            let url = currencyPairs.ratesUrl() else {
                return
        }

        ratesRequest.start(type: [String: Double].self, url: url) { (rates) in
            guard self.shouldStop == false, let rates = rates else { return }
            
            currencyPairs.update(rates: rates, from: self.context)
            DispatchQueue.main.async { [weak self] in
                self?.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
                    self?.execute()
                })
            }
        }
    }
    
    func currencyPairs() -> [CurrencyPair]? {
        let fetchRequest: NSFetchRequest<CurrencyPair> = CurrencyPair.fetchRequest()
        return try? context.fetch(fetchRequest)
    }
}

struct ExRateListView: View {
    @Environment(\.managedObjectContext)
    var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CurrencyPair.added, ascending: true)],
        animation: .default)
    var currencyPairs: FetchedResults<CurrencyPair>
    
    @State var isCurrencyPickerPresented: Bool = false

    let model = ExRateListViewModel()
    
    var body: some View {
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
                List {
                    ForEach(self.currencyPairs) { pair in
                        CurrencyPairRowView(model: pair, value: 1, exRate: pair.exchangeRate)
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

        .navigationBarTitle("Rates & converter", displayMode: .inline)
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

struct ExRateListView_Previews: PreviewProvider {
    static var previews: some View {
        ExRateListView().colorScheme(.dark)
    }
}