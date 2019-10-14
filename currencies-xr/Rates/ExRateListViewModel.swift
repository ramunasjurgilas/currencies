//
//  ExRateListViewModel.swift
//  currencies-xr
//
//  Created by Ramūnas Jurgilas on 14/10/2019.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import UIKit
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
