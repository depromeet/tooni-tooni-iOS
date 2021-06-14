//
//  NetworkError.swift
//  toonitooni
//
//  Created by buzz on 2021/05/10.
//

import Foundation

//MARK: TODO - Error 형식 나오고 결정

struct NetworkError {
    
    let status: Int
    let message: String
    
    static func transform(jsonData: Data?) -> NetworkDataResponse {
        do {
            let result = try JSONDecoder().decode(ErrorModel.self, from: jsonData ?? Data())
            
            debug(result)
            
            return NetworkDataResponse(
                json: nil,
                result: .failure,
                error: NetworkError(status: result.status, message: result.message)
            )
        } catch {
            debug("Decodable Error")
            
            return NetworkDataResponse(
                json: nil,
                result: .failure,
                error: NetworkError(status: 0, message: "Decodable Error")
            )
        }
    }
    
}

