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
        }
    }

    var method: Alamofire.HTTPMethod {
        switch self {
        case .home, .weekWebtoon, .webtoonDetail:
            return .get
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
        }
    }

    var headers: [String : String]? {
        return nil
    }

}
