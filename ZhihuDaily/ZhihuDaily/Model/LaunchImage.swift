//
//  LaunchImage.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/1/13.
//  Copyright © 2017年 Jin. All rights reserved.
//

import Foundation

struct LaunchImage {
    public var id: String?
    public var owner: String?
    public var url: String?
    public var startTime: Int?

    public init(id: String, owner: String, url: String, startTime: Int) {
        self.id = id
        self.owner = owner
        self.url = url
        self.startTime = startTime
    }

    public init(dictionary: Dictionary<String, Any>) {
		id = dictionary["id"] as? String
        owner = dictionary["owner"] as? String
        url = dictionary["url"] as? String
		startTime = dictionary["startTime"] as? Int
    }

    public func encode() -> Dictionary<String, Any> {
        var dictionary : Dictionary = Dictionary<String, Any>()
        dictionary["id"] = id
        dictionary["owner"] = owner
        dictionary["url"] = url
		dictionary["startTime"] = startTime
        return dictionary
    }
}
