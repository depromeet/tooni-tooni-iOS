//
//  CommonResponse.swift
//  toonitooni
//
//  Created by buzz on 2021/05/10.
//

import Foundation

struct CommonResponse<T: Codable>: Codable {
    let status: String?
    let message: String?
    let data: T?
}
