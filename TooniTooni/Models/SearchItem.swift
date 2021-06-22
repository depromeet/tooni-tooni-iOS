//
//  SearchItem.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/07.
//

import Foundation

struct SearchItem: Codable {
    var query: String?
    var webtoons: [Webtoon]?
}
