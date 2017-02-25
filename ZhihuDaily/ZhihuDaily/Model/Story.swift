//
//  Story.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/2/7.
//  Copyright © 2017年 Jin. All rights reserved.
//

import Foundation
import RealmSwift

class RealmString: Object {
    dynamic var stringValue = ""
}

class Story: Object {
    dynamic var title = ""
    dynamic var gaPrefix = ""
    dynamic var id = 0
    dynamic var type = 0
    dynamic var read = false
	dynamic var imageSource: String? = nil
    dynamic var html: String? = nil
    dynamic var image: String? = nil
    dynamic var copyright: String? = nil
    dynamic var multiPic = false
    let _images = List<RealmString>()

    var images: [String] {
        get {
            return _images.map { $0.stringValue }
        }
        set {
            _images.removeAll()
            _images.append(objectsIn: newValue.map { RealmString(value: [$0])})
        }
    }

    override static func primaryKey() -> String {
        return "id"
    }

    override static func ignoredProperties() -> [String] {
        return ["images"]
    }
}

// MARK: - TopStory(热点文章)
class TopStory: Story {

}
