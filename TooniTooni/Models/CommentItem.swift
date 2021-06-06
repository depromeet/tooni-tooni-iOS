//
//  CommentItem.swift
//  TooniTooni
//
//  Created by buzz on 2021/06/07.
//

import Foundation

struct CommentItem: Codable {
  var isLastComment: Bool
  var lastCommentId: Int?
  var commentResponse: [Comment]?
}
