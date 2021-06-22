//
//  UserItem.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/05.
//

import Foundation

struct User: Codable {
    var id: Int?
    var nickname: String?
    var loginToken: String?
    var profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "accountId"
        case nickname
        case loginToken
        case profileImage
    }
}
