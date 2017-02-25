//
//  TableHeaderView.swift
//  ZhihuDaily
//
//  Created by Jin on 2017/2/23.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

class TableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!

    var text: String? = nil {
        willSet {
            titleLabel.text = newValue
        }
    }
}
