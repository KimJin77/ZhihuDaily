//
//  HomeViewController.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/1/17.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit
import Moya
import RealmSwift

class HomeViewController: UIViewController {

    fileprivate let ARTICLE_CELL_IDENTIFIER = "Article"
    fileprivate let HEADER_VIEW_IDENTIFIER = "TableHeaderView"
    fileprivate let BANNER_TAG = 1001
    fileprivate let MAX_DROP_DOWN_OFFSET: CGFloat = -100
    fileprivate let BANNER_HEIGHT: CGFloat = 200
    fileprivate let ROW_HEIGHT: CGFloat = 92

    var tableView: UITableView = UITableView()
    let tableHeaderView = UIView()
    let customNavigationItem = UINavigationItem()
    let indicatorView = UIActivityIndicatorView()
    let bannerScrollView = UIScrollView()
    var pageControl = UIPageControl()
    var titleView = NavigationBarTitleView(frame: CGRect(x: 0, y: 0, width: 120, height: 80))

    var realm: Realm {
		return try! Realm()
    }
    var topStories: Results<TopStory>? {
        return try! Realm().objects(TopStory.self)
    }
    var dateStories: Results<DateStory>? {
        return try! Realm().objects(DateStory.self).sorted(byKeyPath: "date", ascending: false)
    }

    let navigationBar = UINavigationBar()
    var timer: Timer?
    var didTappedMenuItem: (()->())? = nil

    var currentSection = 0
    var lastContentOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        loadData(before: nil)
        layoutTableView()
        layoutNavigationBar()
    }

    func layoutNavigationBar() {
        navigationBar.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        navigationBar.shadowImage = UIImage()

        customNavigationItem.titleView = titleView

        let menuButton = UIButton(type: .custom)
        menuButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        menuButton.setImage(#imageLiteral(resourceName: "Home_Icon"), for: .normal)
        menuButton.setImage(#imageLiteral(resourceName: "Home_Icon_Highlight"), for: .highlighted)
        menuButton.addTarget(self, action: #selector(showMenu(_:)), for: .touchUpInside)
        let menuItem = UIBarButtonItem(customView: menuButton)
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = 15
        customNavigationItem.leftBarButtonItems = [spaceItem, menuItem]
        navigationBar.items = [customNavigationItem]
        view.addSubview(navigationBar)
    }

    func layoutTableView() {
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = ROW_HEIGHT
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: ARTICLE_CELL_IDENTIFIER)
        tableView.separatorStyle = .none

        func layoutTableHeaderView() {
            let scrollViewWidth = view.bounds.size.width
            let scrollViewHeight: CGFloat = BANNER_HEIGHT//CGFloat(Int(view.bounds.size.height * 0.33))
            tableHeaderView.frame = CGRect(x: 0, y: 0, width: scrollViewWidth, height: scrollViewHeight)
            bannerScrollView.frame = tableHeaderView.frame
            bannerScrollView.tag = BANNER_TAG
            bannerScrollView.showsHorizontalScrollIndicator = false
            bannerScrollView.showsVerticalScrollIndicator = false
            bannerScrollView.isPagingEnabled = true
            bannerScrollView.delegate = self

            let tap = UITapGestureRecognizer(target: self, action: #selector(tapBanner))
			bannerScrollView.addGestureRecognizer(tap)

            tableHeaderView.addSubview(bannerScrollView)
            tableHeaderView.addSubview(pageControl)
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            let views = ["PageControl": pageControl]
            let pageControlHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "H:|[PageControl]|", options: .alignAllCenterX, metrics: nil, views: views)
            let pageControlVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: "V:[PageControl(20)]-10-|", options: .alignAllCenterX, metrics: nil, views: views)
            NSLayoutConstraint.activate(pageControlVerticalConstraint)
            NSLayoutConstraint.activate(pageControlHorizontalConstraint)
        }

        func layoutTableFooterView() -> UIView {
			let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
            indicatorView.activityIndicatorViewStyle = .gray
            indicatorView.frame = CGRect(x: 0, y: 20, width: 20, height: 20)
            indicatorView.center = CGPoint(x: footerView.frame.size.width / 2, y: indicatorView.center.y)
            indicatorView.hidesWhenStopped = true
            footerView.addSubview(indicatorView)
            return footerView
        }

        layoutTableHeaderView()

        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = layoutTableFooterView()
		tableView.register(UINib.init(nibName: "TableHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: HEADER_VIEW_IDENTIFIER)
        view.addSubview(tableView)
    }

    func showMenu(_ item: UIBarButtonItem) {
        if let closure = didTappedMenuItem {
            closure()
        }
    }

    func loadData(before id: String?) {
        let moya = MoyaProvider<ZhihuDailyService>()
        if id == nil {
            moya.request(.latest) { [unowned self] (result) in

                switch result {
                case let .success(moyaResponse):
                    do {
                        if let response = try moyaResponse.mapJSON() as? [String: Any] {
                            self.handle(response)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                default: break
                }
            }
        } else {
            moya.request(.before(id: Int(id!)!)) { [unowned self] (result) in

                switch result {
                case let .success(moyaResponse):
                    do {
                        if let jsonResponse = try moyaResponse.mapJSON() as? [String: Any] {
							self.handle(jsonResponse)
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                default:
                    self.tableView.reloadData()
                    self.indicatorView.stopAnimating()
                }
            }
        }
    }

    // MARK: - Banner
    func tapBanner() {
        guard let stories = topStories else {
            return
        }
		let index = pageControl.currentPage
        let story = stories[index]
        let newsViewController = NewsViewController(nibName: "NewsViewController", bundle: nil)
        newsViewController.story = story

        if let appDelegate = UIApplication.shared.delegate {
            if let rootViewController = appDelegate.window!?.rootViewController! as? UINavigationController {
                rootViewController.pushViewController(newsViewController, animated: true)
            }
        }

    }

    func updateBanner() {
        guard let data = topStories else {
            return
        }
        removeTimer()
        for subview in bannerScrollView.subviews {
			subview.removeFromSuperview()
        }
        if data.count > 3 {
            let width = bannerScrollView.frame.size.width
            let height = bannerScrollView.frame.size.height
            bannerScrollView.contentSize = CGSize(width: width * CGFloat(3), height: height)

            pageControl.numberOfPages = topStories!.count

            for index in 0..<3 {
                let bannerView = BannerView(frame: CGRect(x: width * CGFloat(index), y: 0, width: width, height: height))
                switch index {
                case 0: bannerView.story = data.last
                case 1: bannerView.story = data.first
                case 2: bannerView.story = data[1]
                default: break
                }
                bannerScrollView.addSubview(bannerView)
            }
            bannerScrollView.contentOffset = CGPoint(x: width, y: 0)
            addTimer()
        }
    }

    func previousBanner() {
        guard let topStories = topStories else {
            return
        }
        if pageControl.currentPage == 0 {
            pageControl.currentPage = topStories.count - 1
        } else {
            pageControl.currentPage -= 1
        }

        bannerScrollView.setContentOffset(.zero, animated: true)
    }

    func nextBanner() {
        guard let topStories = topStories else {
            return
        }

        if pageControl.currentPage == topStories.count - 1 {
            pageControl.currentPage = 0
        } else {
			pageControl.currentPage += 1
        }
        bannerScrollView.setContentOffset(CGPoint(x: view.frame.size.width * 2, y: 0), animated: true)
    }

    func reloadBanners() {
        guard let topStories = topStories else {
            return
        }

        let currentIndex = pageControl.currentPage
        let previousIndex = (currentIndex + topStories.count - 1) % topStories.count
        let nextIndex = (currentIndex + 1) % topStories.count

		(bannerScrollView.subviews[0] as! BannerView).story = topStories[previousIndex]
		(bannerScrollView.subviews[1] as! BannerView).story = topStories[currentIndex]
        (bannerScrollView.subviews[2] as! BannerView).story = topStories[nextIndex]
    }

    // MARK: Timer
    func addTimer() {
        timer = Timer(timeInterval: 2.0, target: self, selector: #selector(nextBanner), userInfo: nil, repeats: true)
        guard let timer = timer else {
			return
        }
        RunLoop.current.add(timer, forMode: .commonModes)
    }

    func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// MARK: - UITableViewDelegate/UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dateStories == nil ? 0 : dateStories!.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateStories == nil ? 0 : dateStories![section].stories.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let dateStories = self.dateStories,
        	let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HEADER_VIEW_IDENTIFIER) as? TableHeaderView else {
            return nil
        }

        let date = Date.date(from: dateStories[section].date).dateInfo()
        if let month = date.0, let day = date.1, let weekday = date.2 {
			view.text = month + "月" + day + "日 星期" + weekday
        }
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 38
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ARTICLE_CELL_IDENTIFIER, for: indexPath) as! ArticleCell
        cell.story = dateStories == nil ? nil : dateStories![indexPath.section].stories[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let dateStories = self.dateStories {
            let newsViewController = NewsViewController(nibName: "NewsViewController", bundle: nil)
            let story = dateStories[indexPath.section].stories[indexPath.row]
        	self.realm.beginWrite()
            story.read = true
			try! self.realm.commitWrite()
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.endUpdates()
            newsViewController.story = story

            if let appDelegate = UIApplication.shared.delegate {
                if let rootViewController = appDelegate.window!?.rootViewController! as? UINavigationController {
                    rootViewController.pushViewController(newsViewController, animated: true)
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let dateStories = self.dateStories else {
            return
        }

        let dateStory = dateStories[indexPath.section]
        if indexPath.row == dateStory.stories.count - 2 {
			let date = dateStory.date
            let yesterday = Date.date(from: date).yesterdayString()
            if !dateStories.contains(where: { (obj) -> Bool in
                return obj.date == yesterday
            }) {
				loadData(before: date)
            }
        }
    }
}

// MARK: - UIScrollViewDelegate
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.tag != BANNER_TAG {

            let offsetY = scrollView.contentOffset.y
            if (offsetY < 0) {
                if (offsetY < MAX_DROP_DOWN_OFFSET) {
                    scrollView.contentOffset.y = MAX_DROP_DOWN_OFFSET
                }

                titleView.ratio = offsetY / MAX_DROP_DOWN_OFFSET

                var rect = tableHeaderView.frame
                rect.origin.y = offsetY
                rect.size.height -= offsetY
                for view in bannerScrollView.subviews {
                    if let view = view as? BannerView {
                        view.backgroundView.frame = rect
                    }
                }
                bannerScrollView.clipsToBounds = false
            } else {
                navigationBar.backgroundColor = UIColor.color(of: 0x028fd6, withAlpha: offsetY / BANNER_HEIGHT)

                guard let dateStories = dateStories else {
                    return
                }

                func changeNavigationItemTitle() {
                    if currentSection == 0 {
                        customNavigationItem.titleView = titleView
                    } else {
                        if currentSection < 0 {
                            return
                        }
                        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
                        label.textAlignment = .center
                        label.font = UIFont(name: "PingFangSC-Regular", size: 17)
                        label.textColor = .white
                        let date = Date.date(from: dateStories[currentSection].date).dateInfo()
                        if let month = date.0, let day = date.1, let weekday = date.2 {
                            label.text = month + "月" + day + "日 星期" + weekday
                        }
                        label.sizeToFit()
                        customNavigationItem.titleView = label
                    }
                }

                if lastContentOffset < offsetY {
                    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: currentSection + 1)) {
                        let cellRect = tableView.convert(cell.frame, to: tableView.superview)
                        if cellRect.origin.y <= 60 {
                            currentSection += 1
							changeNavigationItemTitle()
                        }
                    }
                } else {
                    if let cell = tableView.cellForRow(at: IndexPath(row: 0, section: currentSection)) {
                        let cellRect = tableView.convert(cell.frame, to: tableView.superview)

                        if cellRect.origin.y >= 54.5 {
                            currentSection -= 1
                            changeNavigationItemTitle()
                        }
                    }
                }
            }
            lastContentOffset = scrollView.contentOffset.y
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.tag != BANNER_TAG {
            lastContentOffset = scrollView.contentOffset.y
            return
        }

        removeTimer()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.tag != BANNER_TAG {
            if scrollView.contentOffset.y <= MAX_DROP_DOWN_OFFSET {
                titleView.animating = true
                loadData(before: nil)
            } else {
                titleView.ratio = 0
            }
        } else {
            addTimer()
            if scrollView.contentOffset.x < scrollView.frame.size.width {
                previousBanner()
            } else {
                nextBanner()
            }
        }
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.tag != BANNER_TAG {
            return
        }
        reloadBanners()
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width, y: 0), animated: false)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.tag != BANNER_TAG {
            let endOfTable = (scrollView.contentSize.height - scrollView.contentOffset.y <= scrollView.frame.size.height)
            if endOfTable {
                guard let id = dateStories?.last?.date else {
                    return
                }

                loadData(before: id)
                indicatorView.startAnimating()
            }
        }
    }
}

// MARK: Response Handler
extension HomeViewController {
    func handle(_ response: [String: Any]) {
        guard let date = response["date"] as? String,
            let stories = response["stories"] as? [[String: Any]],
        	let currentDateStories = self.dateStories else {
                return
        }

        if titleView.animating {
            titleView.animating = false
        }

        if let top = response["top_stories"] as? [[String: Any]] {
            try! self.realm.write {
				self.realm.delete(self.realm.objects(TopStory.self))
            }
            for object in top {
                guard let title = object["title"] as? String,
                    let prefix = object["ga_prefix"] as? String,
                    let id = object["id"] as? Int,
                    let image = object["image"] as? String,
                    let type = object["type"] as? Int else {
                        break
                }
                let story = TopStory(value: ["title": title, "gaPrefix": prefix, "id": id, "type": type, "image": image])

                try! self.realm.write {
                    self.realm.add(story)
                }
            }
            self.updateBanner()
        }

        if (currentDateStories.count == 0) || (currentDateStories.first!.date != date) {
			// 不存在当日数据
            let dateStory = DateStory(value: ["date": date])
            for object in stories {
                guard let title = object["title"] as? String,
                	let prefix = object["ga_prefix"] as? String,
                	let id = object["id"] as? Int,
                	let images = object["images"] as? [String],
                	let type = object["type"] as? Int else {
                    break
                }
                let story = Story(value: ["title": title, "gaPrefix": prefix, "id": id, "type": type])
                story.images = images

                if object.keys.contains("multipic") {
                    story.multiPic = true
                }
                dateStory.stories.append(story)
            }

            DispatchQueue(label: "com.zhihu.latest").async { [unowned self] in

                try! self.realm.write {
                    self.realm.add(dateStory, update: true)
                }

                DispatchQueue.main.async {
                    let realm = try! Realm()
                    realm.refresh()
                    self.tableView.reloadData()
                }
            }
        } else {
            guard let dateStory = currentDateStories.filter("date = '\(date)'").first else {
                return
            }

            for object in stories {
                guard let id = object["id"] as? Int else {
                    break
                }
                if let _ = realm.objects(Story.self).filter("id = \(id)").first {

                } else {
                    guard let title = object["title"] as? String,
                        let prefix = object["ga_prefix"] as? String,
                        let images = object["images"] as? [String],
                        let type = object["type"] as? Int else {
                            break
                    }

                    let story = Story(value: ["title": title, "gaPrefix": prefix, "id": id, "type": type])
                    story.images = images

                    if object.keys.contains("multipic") {
                        story.multiPic = true
                    }
                    self.realm.beginWrite()
                    dateStory.stories.insert(story, at: 0)
                    try! self.realm.commitWrite()
                }
            }
            self.tableView.reloadData()
        }
    }
}
