//
//  Loader.swift
//  ZhihuDaily
//
//  Created by Jin on 2017/2/23.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

class NavigationBarTitleView: UIView {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "今日热闻"
        label.textColor = .white
        label.font = UIFont(name: "PingFangSC-Semibold", size: 18)
        label.sizeToFit()
        return label
    }()

    var ratio: CGFloat = 0 {
        willSet {
            setNeedsDisplay()
        }
    }

    private var indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView.hidesWhenStopped = true
        return indicatorView
    }()

    var animating: Bool = false {
        willSet {
            if newValue {
                indicatorView.startAnimating()
            } else {
                indicatorView.stopAnimating()
            }
        }
    }

    override init(frame: CGRect) {
		super.init(frame: frame)
        backgroundColor = .clear
        titleLabel.center = center
        indicatorView.center = CGPoint(x: titleLabel.center.x - 50, y: titleLabel.center.y)
        addSubview(titleLabel)
        addSubview(indicatorView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }


        if !animating && ratio > 0.1 {
            context.addArc(center: indicatorView.center, radius: 9, startAngle: 0, endAngle: CGFloat(2 * M_PI), clockwise: false)
            context.setStrokeColor(UIColor.gray.cgColor)
            context.setLineWidth(2)
            context.strokePath()

            let angle = ratio * CGFloat(2 * M_PI) + CGFloat(M_PI_2)
            context.addArc(center: indicatorView.center, radius: 9, startAngle: CGFloat(M_PI_2), endAngle: angle, clockwise: false)
            context.setStrokeColor(UIColor.white.cgColor)
            context.setLineWidth(2)
            context.strokePath()
        }
    }
}
