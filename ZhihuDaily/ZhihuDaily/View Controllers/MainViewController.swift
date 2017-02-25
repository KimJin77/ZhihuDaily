//
//  MainViewController.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/1/10.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit
import Moya
import Alamofire

class MainViewController: UIViewController {
    let home = HomeViewController()
    let menu = MenuViewController(nibName: "MenuViewController", bundle: Bundle(for: MenuViewController.self))
    let menuViewWidthRatio: CGFloat = 0.6
    var menuViewWidth: CGFloat = 0

    var menuView: UIView!
    var mainView: UIView!

    var tap: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
		menuView = menu.view
        menuViewWidth = view.frame.size.width * menuViewWidthRatio
		menuView.frame = CGRect(x: -menuViewWidth, y: 0, width: menuViewWidth, height: view.frame.size.height)
        view.addSubview(menuView)

        mainView = home.view
        home.didTappedMenuItem = {[weak self] in
            if let strongSelf = self {
                if strongSelf.menuView.frame.origin.x < 0 {
					strongSelf.showMenuView()
                } else {
                    strongSelf.showMainView()
                }
            }
        }
        view.addSubview(mainView)
        addGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panView(_:)))
        view.addGestureRecognizer(pan)

        tap = UITapGestureRecognizer(target: self, action: #selector(showMainView))
    }
}

// MARK: - Gesture
extension MainViewController {
    var menuViewOffset: CGFloat {
        return menuView.frame.origin.x
    }
    var mainViewMaxCenterX: CGFloat {
        return mainView.frame.size.width * 1.1
    }

    var mainViewMinCenterX: CGFloat {
		return mainView.frame.size.width / 2
    }

    var menuViewMaxCenterX: CGFloat {
        return menuViewWidth / 2
    }

    var menuViewMinCenterX: CGFloat {
        return -menuViewWidth / 2
    }

    func panView(_ recognizer: UIPanGestureRecognizer) {
        let distance = recognizer.translation(in: view).x

        if (distance > 0 && menuViewOffset <= 0) {
            let mainViewCenterX = mainView.center.x + distance > mainViewMaxCenterX ? mainViewMaxCenterX : mainView.center.x + distance
            let leftViewCenterX = menuView.center.x + distance > menuViewMaxCenterX ? menuViewMaxCenterX : menuView.center.x + distance
            UIView.animate(withDuration: 0.1, animations: {
                self.mainView.center = CGPoint(x: mainViewCenterX, y: self.mainView.center.y)
                self.menuView.center = CGPoint(x: leftViewCenterX, y: self.menuView.center.y)
            })
        } else {
            let mainViewCenterX = mainView.center.x + distance < mainViewMinCenterX ? mainViewMinCenterX : mainView.center.x + distance
            let leftViewCenterX = menuView.center.x + distance < menuViewMinCenterX ? menuViewMinCenterX : menuView.center.x + distance
            if (menuViewOffset != -menuViewWidth) {
                UIView.animate(withDuration: 0.1, animations: {
                    self.mainView.center = CGPoint(x: mainViewCenterX, y: self.mainView.center.y)
                    self.menuView.center = CGPoint(x: leftViewCenterX, y: self.menuView.center.y)
                })
            }
        }

        if (recognizer.state == .ended) {
            if (-menuViewOffset <= menuViewWidth * 0.82) {
                showMenuView()
            } else {
				showMainView()
            }
        }
        recognizer.setTranslation(CGPoint.zero, in: view)
    }

    func showMenuView() {
		UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.mainView.center = CGPoint(x: self.mainView.frame.size.width * 1.1, y: self.mainView.center.y)
            self.menuView.center = CGPoint(x: self.menuView.frame.size.width / 2, y: self.menuView.center.y)
        }) { (finished) in
			self.mainView.addGestureRecognizer(self.tap)
        }
    }

    func showMainView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.mainView.center = self.view.center
            self.menuView.center = CGPoint(x: -self.menuView.frame.size.width / 2, y: self.menuView.center.y)
        }) { (finished) in
			self.mainView.removeGestureRecognizer(self.tap)
        }
    }
}
