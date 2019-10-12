//
//  Bundle+extension.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import Foundation

extension Bundle {

    func decode<T>(_ type: T.Type,forResource name: String?, ofType ext: String?) -> T? where T : Decodable {
        
        if let path = Bundle.main.path(forResource: name, ofType: ext),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) {
            let decoder = JSONDecoder()
            
            do {
                let item = try decoder.decode(T.self, from: jsonData)
                return item
            } catch {
                print(error)
            }
            
        }
        return nil
    }
}

