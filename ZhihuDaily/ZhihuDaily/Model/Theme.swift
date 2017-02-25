//
//  Theme.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/2/6.
//  Copyright © 2017年 Jin. All rights reserved.
//

// 主题日报

import Foundation
import RealmSwift

class Theme: Object {
    dynamic var color: Int = 0
    dynamic var desc: String = ""
	dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var thumbnail: String = ""
    dynamic var isAdded: Bool = false

    override static func primaryKey() -> String? {
		return "id"
    }
}
