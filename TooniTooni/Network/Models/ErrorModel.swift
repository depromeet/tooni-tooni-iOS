//
//  ErrorModel.swift
//  toonitooni
//
//  Created by buzz on 2021/05/11.
//

import Foundation

struct ErrorModel: Decodable {
    var status: Int
    var message: String
}
