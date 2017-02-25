//
//  BannerView.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/1/22.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit
import Kingfisher

class BannerView: UIView {
    let scrollView = UIScrollView()
    let backgroundView = UIImageView()
    let titleLabel = BannerLabel()
    let copyrightLabel = UILabel()
    var showImageSource = false {
        didSet {
            copyrightLabel.isHidden = !showImageSource
        }
    }
    var story: Story? = nil {
        didSet {
            if story!.image != nil {
				backgroundView.kf.setImage(with: URL(string: story!.image!), placeholder: #imageLiteral(resourceName: "Field_Mask_Bg"), options: nil, progressBlock: nil, completionHandler: nil)
                if story!.imageSource != nil && showImageSource == true {
					copyrightLabel.text = "图片：" + story!.imageSource!
                }

            } else {
                if let image = story!.images.first {
					backgroundView.kf.setImage(with: URL(string: image), placeholder: #imageLiteral(resourceName: "Field_Mask_Bg"), options: nil, progressBlock: nil, completionHandler: nil)
                }
            }

            let shadow: NSShadow = NSShadow()
            shadow.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadow.shadowColor = UIColor.black
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = 0.9
            let attributedString = NSMutableAttributedString(string: story!.title, attributes: [NSShadowAttributeName: shadow, NSFontAttributeName: UIFont(name: "PingFangSC-Semibold", size: 20)!, NSParagraphStyleAttributeName: paragraphStyle])
            titleLabel.attributedText = attributedString
        }
    }

    override init(frame: CGRect) {
		super.init(frame: frame)
        layoutSubview()
    }

    func layoutSubview() {
        backgroundView.frame = bounds
        backgroundView.contentMode = .scaleAspectFill
        backgroundView.clipsToBounds = true
        addSubview(backgroundView)

        titleLabel.numberOfLines = 2
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)

        copyrightLabel.textColor = .white
        copyrightLabel.font = UIFont(name: "PingFangSC-Regular", size: 10)
        copyrightLabel.textAlignment = .right
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(copyrightLabel)

        let views = ["Title": titleLabel, "CopyRight": copyrightLabel]
        let titleHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[Title]-16-|", options: .alignAllCenterX, metrics: nil, views: views)
        let titleVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[Title]-28-|", options: .alignAllBottom, metrics: nil, views: views)
        let copyrightHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[CopyRight]-16-|", options: .alignAllCenterX, metrics: nil, views: views)
        let copyrightVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[CopyRight]-10-|", options: .alignAllBottom, metrics: nil, views: views)
        NSLayoutConstraint.activate(titleHorizontalConstraint)
        NSLayoutConstraint.activate(titleVerticalConstraint)
        NSLayoutConstraint.activate(copyrightHorizontalConstraint)
        NSLayoutConstraint.activate(copyrightVerticalConstraint)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateUI() {
        
    }
}

class BannerLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: -5, left: 0, bottom: 0, right: 0)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += 5
            contentSize.width += 0
            return contentSize
        }
    }
}
