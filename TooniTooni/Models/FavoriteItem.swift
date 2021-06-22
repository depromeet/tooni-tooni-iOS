//
//  File.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import Foundation

struct FavoriteItem: Codable {
    var webtoons: [Webtoon] = []
}

struct RecentItem: Codable {
    var webtoons: [Webtoon] = []
}
