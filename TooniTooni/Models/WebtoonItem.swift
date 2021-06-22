//
//  WebtoonItem.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

struct Genre: Codable {
    var genre: String?
    var top20Webtoons: [Webtoon]?
}

struct WebtoonDetail: Codable {
    var webtoon: Webtoon?
    var comments: [Comment]?
    var randomRecommendWebtoons: [Webtoon]?
}

struct WeekWebtoon: Codable {
    var sites: [Site]?
    var webtoons: [Webtoon]?
}

struct Site: Codable {
    let site: String?
    let thumbnail: String?
}

struct Author: Codable {
    var id: Int?
    var name: String?
    var authorImage: String?
}

struct Webtoon: Codable {
    var id: Int?
    var site: String?
    var title: String?
    var authors: [Author]?
    var popularity: Int?
    var thumbnail: String?
    var backgroundColor: String?
    var genres: [String]?
    var score: Double?
    var isComplete: Bool?
    var weekday: [String]?
    var summary: String?
    var url: String?
}

