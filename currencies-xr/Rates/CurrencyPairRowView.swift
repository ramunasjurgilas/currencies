//
//  CurrencyPairRowView.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import SwiftUI
import CoreData

struct CurrencyPairRowView: View {
    
    let model: CurrencyPair
    let value: Double
    let exRate: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(model.firstCurrencyTitle(with: value))
                    .font(.title)
                Text(model.firstCurrencySubtitle)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(model.secondCurrencyTitle(with: value))
                    .font(.title)
                Text(model.secondCurrencySubtitle)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct CurrencyPairRowView_Previews: PreviewProvider {
    static let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {

        CurrencyPairRowView(model: CurrencyPairRowView_Previews.currencyPair(), value: 1500, exRate: 12)
    }
    
    static func currencyPair() -> CurrencyPair {
        let pair = CurrencyPair(context: context)

        pair.pair = "USDEUR"
        pair.added = Date()
        pair.exchangeRate = 0.7618
        
        return pair
    }
}
