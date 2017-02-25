//
//  LaunchView.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/1/10.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit

class LaunchView: UIView {
    let backgroundImageView: UIImageView = UIImageView()

    private let adHeightRatio: CGFloat = 13.5 / 100

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundImageView.frame = frame
        backgroundImageView.image = #imageLiteral(resourceName: "Splash_Image")
        let adHeight = frame.size.height * adHeightRatio
        let adView = ADView(frame: CGRect(x: 0, y: frame.size.height, width: frame.size.width, height: adHeight))
        adView.backgroundColor = UIColor.color(of: 0x17181a)
        adView.iconView.drawDoneClosure = { _ in
            UIView.animate(withDuration: 2, animations: {
                self.alpha = 0
            }) { (finished) in
                self.removeFromSuperview()
            }
        }
        addSubview(backgroundImageView)
        addSubview(adView)

        UIView.animate(withDuration: 0.5, animations: {
            adView.frame = CGRect(x: 0, y: frame.size.height - adHeight, width: frame.size.width, height: adHeight)
        }) { (finished) in
            adView.iconView.startDrawing()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ADView: UIView {
    var iconView: ZhihuIconView = ZhihuIconView()
    private var nameLabel: UILabel = UILabel()
    private var sloganLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "知乎日报"
        nameLabel.textColor = UIColor.color(of: 0xdadde2)
        nameLabel.font = UIFont.systemFont(ofSize: 19)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        sloganLabel.text = "每天三次，每次七分钟"
        sloganLabel.textColor = UIColor.color(of: 0x8b8c90)
        sloganLabel.font = UIFont.systemFont(ofSize: 13)
        sloganLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconView)
        addSubview(nameLabel)
        addSubview(sloganLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        let views: [String: UIView] = ["SuperView": self, "Icon": iconView, "Name": nameLabel, "Slogan": sloganLabel]
        let verticalCenterConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:[SuperView]-(<=1)-[Icon(46)]", options: .alignAllCenterY, metrics: nil, views: views)
        let horizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|-18-[Icon]-13-[Name]", options: .alignAllTop, metrics: nil, views: views)
        let labelConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[Name]-[Slogan]", options: .alignAllLeft, metrics: nil, views: views)
        let heightConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[Icon(46)]", options: .alignAllTop, metrics: nil, views: views)
        NSLayoutConstraint.activate(verticalCenterConstraint)
        NSLayoutConstraint.activate(horizontalConstraint)
        NSLayoutConstraint.activate(labelConstraint)
        NSLayoutConstraint.activate(heightConstraint)
    }

}

class ZhihuIconView: UIView {
    private var originalIconView: UIImageView = UIImageView(image: #imageLiteral(resourceName: "AD_Icon_Border"))
    private var maxCount: Int = 100
    private var currentCount: Int = 1
    private var timer = Timer()
    var drawDoneClosure: (() -> ())?

    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(originalIconView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func startDrawing() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(drawIcon), userInfo: nil, repeats: true)
    }

    func drawIcon() {
        if currentCount == maxCount {
            timer.invalidate()
            originalIconView.image = #imageLiteral(resourceName: "AD_Icon_iOS7")
            if let closure = drawDoneClosure {
                closure()
            }
            return
        } else {
            currentCount += 1
            setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
		context.clear(rect)

        context.addEllipse(in: CGRect(x: rect.size.width / 2 - 2.5, y: rect.size.height / 2 + 9.5, width: 5, height: 5))
        context.setFillColor(UIColor.color(of: 0xc7cacf).cgColor)
        context.fillPath()

        let angle = Double(currentCount) * ((M_PI * 3 / 2) / Double(maxCount)) + M_PI_2
        let radius: CGFloat = 12
        context.addArc(center: CGPoint(x: rect.size.width / 2, y: rect.size.height / 2), radius: radius, startAngle: CGFloat(M_PI_2), endAngle: CGFloat(angle), clockwise: false)

        context.setStrokeColor(UIColor.color(of: 0xc7cacf).cgColor)
        context.setLineJoin(CGLineJoin.round)
        context.setLineWidth(5 + 0.5)
        context.strokePath()

        if angle == 2 * M_PI {
            context.addEllipse(in: CGRect(x: rect.size.width / 2 + 9.5, y: rect.size.height / 2 - 2.5, width: 5, height: 5))
            context.fillPath()
        }
    }
}

