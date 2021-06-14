//
//  DataExtensions.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/24.
//

import Foundation

extension Data {
    
    func decode<T>(_ type: T.Type, decoder: JSONDecoder? = nil) throws -> T where T: Decodable {
        let decoder = decoder ?? JSONDecoder()
        return try decoder.decode(type, from: self)
    }
    
}

