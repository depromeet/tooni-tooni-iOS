//
//  TooniRouter.swift
//  toonitooni
//
//  Created by buzz on 2021/05/10.
//

import UIKit
import Moya
import Alamofire

enum TooniRouter {
    case sign(loginToken: String)
    case home
    case webtoonDetail(String)
    case weekWebtoon(String)
    case commentList(String)
    case writeComment(String, String)
    case deleteComment(String)
    case genre(String)
    case author(String)
    case random
    case search(String)
}

extension TooniRouter: TargetType {
   
    var baseURL: URL {
        return URL(string: "https://webtoon.chandol.net/api/v1/")!
    }
    
    var path: String {
        switch self {
        case .sign:
            return "login"
        case .home:
            return "home"
        case .webtoonDetail:
            return "webtoons/detail"
        case let .weekWebtoon(day):
            return "webtoons/weekday/\(day)"
        case .commentList:
            return "comment/list"
        case .writeComment:
            return "comment"
        case .deleteComment:
            return "comment"
        case let .genre(genre):
            return "webtoons/\(genre)"
        case let .author(author):
            return "webtoons/author/\(author)"
        case .random:
            return "webtoons/random"
        case .search:
            return "webtoons/search"
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .sign:
            return .post
        case .home:
            return .get
        case .webtoonDetail:
            return .get
        case .weekWebtoon:
            return .get
        case .commentList:
            return .get
        case .writeComment:
            return .post
        case .deleteComment:
            return .delete
        case .genre:
            return .get
        case .author:
            return .get
        case .random:
            return .get
        case .search:
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case let .sign(loginToken):
            return .requestParameters(parameters: ["loginToken" : loginToken], encoding: JSONEncoding.default)
        case .home:
            return .requestPlain
        case let .webtoonDetail(id):
            return .requestParameters(parameters: ["id" : id], encoding: URLEncoding.queryString)
        case .weekWebtoon:
            return .requestPlain
        case let .commentList(id):
            return .requestParameters(parameters: ["webtoonId": id, "pageSize": 30], encoding: URLEncoding.queryString)
        case let .writeComment(id, content):
            return .requestParameters(parameters: ["webtoonId": id, "content": content], encoding: JSONEncoding.default)
        case let .deleteComment(id):
            return .requestParameters(parameters: ["commentId": id], encoding: URLEncoding.queryString)
        case .genre:
            return .requestPlain
        case .author:
            return .requestPlain
        case .random:
            return .requestPlain
        case let .search(text):
            return .requestParameters(parameters: ["query": text], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        let loginToken = GeneralHelper.sharedInstance.loginToken() ?? ""
        return [
            "Content-type": "application/json",
            "Authorization": "Bearer \(loginToken)"
        ]
    }
    
}
