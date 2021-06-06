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
  var randomRecommendWebtoons: [Webtoon]
}

struct Comment: Codable {
  var commentId: Int
  var content: String
  var writeDate: String
  var account: Account
}

struct TooniScore: Codable {
  var drawingScore: Int
  var storyScore: Int
  var totalScore: Int
}

struct RandomRecommendWebtoon: Codable {
  var id: Int
  var site: String
  var title: String
  var summary: String?
  var authors: [Author]?
  var thumbnail: String?
  var weekday: [String]?
  var url: String?
  var score: Double?
  var genres: [String]?
  var backgroundColor: String?
  var isComplete: Bool
}

struct Account: Codable {
  var accountId: Int
  var nickname: String
  var profileImage: String?
}
