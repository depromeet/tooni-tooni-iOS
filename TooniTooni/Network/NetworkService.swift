//
//  NetworkService.swift
//  toonitooni
//
//  Created by buzz on 2021/05/10.
//

import UIKit
import Moya
import Alamofire

protocol Networkable {
    associatedtype TooniRouter
    
    func request<T: Codable>(
        to router: TooniRouter,
        decoder: T.Type,
        completion: @escaping (NetworkDataResponse) -> Void
    )
}

class TooniNetworkService: Networkable {
    
    static let shared = TooniNetworkService()
    
    private let provider: MoyaProvider<TooniRouter>
    
    private init() {
        self.provider = MoyaProvider<TooniRouter>(
            endpointClosure: MoyaProvider.defaultEndpointMapping,
            requestClosure: MoyaProvider<TooniRouter>.defaultRequestMapping,
            stubClosure: MoyaProvider.neverStub,
            callbackQueue: nil,
            session: AlamofireSession.configuration,
            plugins: [NetworkLoggerPlugin()],
            trackInflights: false
        )
    }
    
    func request<T: Codable>(to router: TooniRouter, decoder: T.Type, completion: @escaping (NetworkDataResponse) -> Void) {
        provider.request(router) { response in
            switch response {
            case .success(let response):
                
                guard 200..<400 ~= response.statusCode else {
                    completion(NetworkError.transform(jsonData: response.data))
                    return
                }
                
                do {
                    let commonResponse = try JSONDecoder().decode(CommonResponse<T>.self, from: response.data)
                    if commonResponse.status == "OK" {
                        debug(commonResponse.data)
                        completion(NetworkDataResponse(json: commonResponse.data, result: .success, error: nil))
                    } else {
                        // Tooni server error
                        completion(NetworkDataResponse(json: nil, result: .failure, error: NetworkError(status: response.statusCode, message: commonResponse.message ?? "")))
                    }
                } catch {
                    // Decode error
                    completion(NetworkError.transform(jsonData: response.data))
                }
                
            case .failure(let error):
                completion(NetworkError.transform(jsonData: error.response?.data))
            }
        }
    }
}
