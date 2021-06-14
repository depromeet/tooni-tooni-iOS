//
//  CommentItem.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/30.
//

import Foundation

struct CommentData: Codable {
    var commentResponse: [Comment]?
    var isLastComment: Bool?
    var lastCommentId: Int?
}

struct Comment: Codable {
    var id: Int?
    var account: User?
    var content: String?
    var writeDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "commentId"
        case account
        case content
        case writeDate
    }

}
