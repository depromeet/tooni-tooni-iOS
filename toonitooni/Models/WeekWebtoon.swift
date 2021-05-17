//
//  WeekWebtoon.swift
//  toonitooni
//
//  Created by buzz on 2021/05/11.
//

import UIKit

struct WeekWebtoon: Codable {
  var sites: [Site] = []
  var webtoons: [WebToon] = []
}

struct Site: Codable {
  let site: String
  let thumbnail: String
}

struct WebToon: Codable {
  let id: Int
  let site: String
  let title: String
  let author: [String]
  let popularity: Int
  let thumbnail: String
}
//
//struct Author: Codable {
//
//}
