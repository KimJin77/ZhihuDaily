//
//  ArticleCell.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/1/17.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class ArticleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var thumbnailView: UIImageView!
    @IBOutlet weak var morePicIndicatorView: UIImageView!
    var observableKeys: Set<String> = Set<String>()
    var story: Story? {
        didSet {
            guard let s = story else {
                return
            }
			self.titleLabel.text = s.title
            if !s.multiPic {
				morePicIndicatorView.isHidden = true
            }
            let url = URL(string: (story?.images.first)!)
            self.thumbnailView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Image_Preview"), options: nil, progressBlock: nil, completionHandler: nil)

            if s.read {
                self.titleLabel.textColor = UIColor.color(of: 0x6a6a6a)
            } else {
                self.titleLabel.textColor = .black
            }
        }
    }
}
