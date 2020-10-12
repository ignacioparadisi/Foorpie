//
//  URL+Extension.swift
//  Foorpie
//
//  Created by Ignacio Paradisi on 10/12/20.
//  Copyright © 2020 Ignacio Paradisi. All rights reserved.
//

import Foundation

extension URL {
    
    func appendingQueryItem(_ name: String, value: String?) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else { return nil }
        var queryItems = urlComponents.queryItems ?? []
        let queryItem = URLQueryItem(name: name, value: value)
        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
