//
//  MenuCell.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/2/3.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    var accessoryImageView = UIImageView(image: #imageLiteral(resourceName: "Menu_Follow"))
    var theme: Theme {
        didSet {
			self.textLabel?.text = theme.name
        }
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        theme = Theme()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = UIColor.color(of: 0x232a30)
        self.textLabel?.text = "日常心理学"
        self.textLabel?.textColor = UIColor.color(of: 0x92979b)
        self.textLabel?.font = UIFont(name: "PingFangSC-Regular", size: 15)

        self.addSubview(accessoryImageView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
		accessoryImageView.frame = CGRect(x: self.frame.size.width * 0.82 - #imageLiteral(resourceName: "Menu_Follow").size.width/2, y: self.frame.size.height / 2 - #imageLiteral(resourceName: "Menu_Follow").size.height/2, width: #imageLiteral(resourceName: "Menu_Follow").size.width, height: #imageLiteral(resourceName: "Menu_Follow").size.height)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if (selected) {
            self.backgroundColor = UIColor.color(of: 0x1b232a)
        }
    }
}

class HomeCell: MenuCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.imageView?.image = #imageLiteral(resourceName: "Menu_Icon_Home_Highlight")
        self.textLabel?.text = "首页"
        self.textLabel?.textColor = UIColor.white
        accessoryImageView.image = #imageLiteral(resourceName: "Menu_Enter")
        self.isSelected = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        accessoryImageView.frame = CGRect(x: self.frame.size.width * 0.82 - #imageLiteral(resourceName: "Menu_Enter").size.width/2, y: self.frame.size.height / 2 - #imageLiteral(resourceName: "Menu_Enter").size.height/2, width: #imageLiteral(resourceName: "Menu_Enter").size.width, height: #imageLiteral(resourceName: "Menu_Enter").size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
