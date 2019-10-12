//
//  RatesRequest.swift
//  currencies-xr
//
//  Created by Ramunas Jurgilas on 2019-10-12.
//  Copyright © 2019 Ramūnas Jurgilas. All rights reserved.
//

import Foundation

class RatesRequest {
    
    var urlSession: URLSession
    
    init(session: URLSession = .shared) {
        self.urlSession = session
    }

    func start<T>(type: T.Type, url: URL, completion: @escaping (T?) -> Void) where T: Decodable {
        let task = urlSession.dataTask(with: url) { (data, urlResponse, error) in
            var result: T?
            defer {
                completion(result)
            }
            
            guard let data = data else { return }
            
            do {
                result = try JSONDecoder().decode(type, from: data)
            } catch {
                // For now doing nothing.
                // No API error handling.
            }
        }
        task.resume()
    }
}
