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
    case home
    case weekWebtoon(String)
    case webtoonDetail(String)
    case login(String)
    case writeComment(Int, String)
    case readComment(String, String)
    case deleteComment(Int)
}

extension TooniRouter: TargetType {

    var baseURL: URL {
        return URL(string: "https://webtoon.chandol.net/api/v1/")!
    }

    var path: String {
        switch self {
        case .home:
            return "home"
        case let .weekWebtoon(day):
            return "webtoons/weekday/\(day)"
        case .webtoonDetail:
            return "webtoons/detail"
        case .login:
            return "login"
        case .writeComment, .deleteComment:
            return "comment"
        case .readComment:
            return "comment/list"
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .home, .weekWebtoon, .webtoonDetail, .readComment:
            return .get
        case .login, .writeComment:
            return .post
        case .deleteComment:
            return .delete
        }
    }

    var sampleData: Data {
        return "".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case .home, .weekWebtoon:
            return .requestPlain
        case let .webtoonDetail(id):
          return .requestParameters(parameters: ["id": id], encoding: URLEncoding.default)
        case let .login(token):
          return .requestParameters(parameters: ["loginToken": token], encoding: JSONEncoding.default)
        case let .writeComment(id, content):
          return .requestParameters(parameters: ["webtoonId": id, "content": content], encoding: JSONEncoding.default)
        case let .readComment(id, pageSize):
          return .requestParameters(parameters: ["webtoonId": id, "pageSize": pageSize], encoding: URLEncoding.default)
        case let .deleteComment(id):
          return .requestParameters(parameters: ["commentId": id], encoding: URLEncoding.default)
        }
    }

    var headers: [String : String]? {
        return [
          "Content-Type": "application/json",
//          "Authorization": "Bearer \(String(describing: UserDefaults.standard.string(forKey: kUD_TOKEN)))"
          "Authorization": "Bearer testToken"
        ]
    }

}
