//
//  ZhihuDailyService.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/1/12.
//  Copyright © 2017年 Jin. All rights reserved.
//

import Foundation
import Moya

public enum ZhihuDailyService {
    case latest
    case launchImage(width: Int, height: Int)
    case themes
    case content(id: Int)
    case before(id: Int)
}

// MARK: - TargetType Protocol Implementation
extension ZhihuDailyService: TargetType {
    public var baseURL: URL { return URL(string: "http://news-at.zhihu.com/api/")! }
    public var path: String {
        switch self {
        case .launchImage(let width, let height):
            return "7/prefetch-launch-images/\(width)*\(height)"
        case .latest:
            return "4/news/latest"
        case .themes:
            return "7/themes"
        case .content(let id):
            return "7/news/\(id)"
        case .before(let id):
            return "4/news/before/\(id)"
        }
    }
    public var method: Moya.Method {
        return .get
//        switch self {
//        case .launchImage, .latest, .themes:
//            return .get
//        }
    }
    public var sampleData: Data {
        return "{\"creatives\": [{\"url\": \"https://pic4.zhimg.com/v2-2bb1b0a9e2b2015e9fd4a4ffe0f8f8c7.jpg\",\"text\":\"Élissa Algora\",\"start_time\": 1484276090,\"impression_tracks\": [\"https://sugar.zhihu.com/track?vs=1&ai=2978&ut=&cg=2&ts=1484276090.68&si=1f9d1817c6d747d2a98681202fe518a5&lu=0&hn=ad-engine.ad-engine.3341ba88&at=impression&pf=PC&az=11&sg=74d30497d6897361f7032b8abf62126f\"],\"type\": 0,\"id\": \"2978\"}]}".utf8Encoded;
    }
    public var parameters: [String: Any]? {
        return nil
    }
    public var task: Task {
        return .request
    }
    public var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return self.data(using: .utf8)!
    }
}
