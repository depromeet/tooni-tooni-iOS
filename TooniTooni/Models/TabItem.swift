//
//  TabItem.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit

enum TabType: Int {
    case home
    case weekday
    case favorite
    case settings
}

struct TabItem {
    var storyBoard: String!
    var viewController: String!
    var title: String?
    var iconImage: String?
    var type: TabType!
    
    init(storyBoard: String!, viewController: String!, title: String? = nil, iconImage: String? = nil, type: TabType!) {
        self.storyBoard = storyBoard
        self.viewController = viewController
        self.title = title
        self.iconImage = iconImage
        self.type = type
    }
}
