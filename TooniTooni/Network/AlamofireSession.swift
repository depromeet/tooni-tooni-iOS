//
//  AlamofireSession.swift
//  toonitooni
//
//  Created by buzz on 2021/05/10.
//

import Alamofire
import Foundation

public class AlamofireSession: Alamofire.Session {
    
    public static let configuration: Alamofire.Session = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = HTTPHeaders.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 20
        configuration.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
        return Alamofire.Session(configuration: configuration)
    }()
    
}
