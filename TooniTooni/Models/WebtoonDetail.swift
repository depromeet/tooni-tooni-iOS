//
//  WebtoonDetail.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/28.
//

import Foundation

struct WebtoonDetail: Codable {
  var webtoon: Webtoon?
  var toonieScore: TooniScore
  var comments: [Comment]
}

struct Comment: Codable {
  var accountNickName: String
  var comment: String
}

struct TooniScore: Codable {
  var drawingScore: Int
  var storyScore: Int
  var totalScore: Int
}
