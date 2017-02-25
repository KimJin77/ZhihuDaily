//
//  File.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/2/7.
//  Copyright © 2017年 Jin. All rights reserved.
//

import Foundation
import RealmSwift

class DateStory: Object {
    dynamic var date = ""
//    let topStories = List<TopStory>()
    let stories = List<Story>()

    override static func primaryKey() -> String? {
        return "date"
    }
}
