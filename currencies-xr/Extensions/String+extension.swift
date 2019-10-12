//
//  File.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import Foundation

extension String {

    var localizedCurrencyName: String? {
        return NSLocale.current.localizedString(forCurrencyCode: self)
    }
}
