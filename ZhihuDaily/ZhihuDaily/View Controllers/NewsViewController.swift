//
//  NewsViewController.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/2/14.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit
import Moya
import WebKit
import RealmSwift
import Kingfisher

class NewsViewController: UIViewController {

    let MAX_DROP_DOWN_OFFSET: CGFloat = -85
    @IBOutlet weak var webView: WKWebView!

    var story: Story? = nil
    var bannerView: BannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        layoutView()
        if story != nil && story!.html != nil {
            bannerView.story = story!
            webView.loadHTMLString(story!.html!, baseURL: nil)
        } else {
            loadData()
        }
    }

    func layoutView() {
        webView.scrollView.delegate = self
        webView.scrollView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        bannerView = BannerView(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        bannerView.showImageSource = true
        webView.scrollView.addSubview(bannerView)
    }

    func loadData() {
        guard let story = self.story else {
            return
        }
        let moya = MoyaProvider<ZhihuDailyService>()
        moya.request(.content(id: story.id)) { [unowned self] (result) in

            switch result {
            case let .success(moyaResponse):
                do {
                    if let jsonResponse = try moyaResponse.mapJSON() as? [String: Any] {

                        if let body = jsonResponse["body"] as? String,
                            let css = jsonResponse["css"] as? [String],
                            let source = jsonResponse["image_source"] as? String,
                            let image = jsonResponse["image"] as? String {
                            try! Realm().write {
                                story.html = self.generateHtml(with: body, and: css)
                                story.imageSource = source
                                story.image = image
                            }
                            self.bannerView.showImageSource = true
                            self.bannerView.story = story
                            self.webView.loadHTMLString(story.html!, baseURL: nil)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            default: break
            }
        }
    }

    private func generateHtml(with body: String, and cssURLs: [String]) -> String {
        var htmlString = "<html><head><meta http-equiv=\"content-type\" content=\"text/html;charset=utf-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum=1.0, user-scaler=no\">"

        for cssURL in cssURLs {
            htmlString += "<link rel=\"stylesheet\" href=\"" + cssURL + "\" type=\"text/css\">"
        }

        htmlString += "</head><body>" + body + "</body></html>"
        return htmlString
    }
}

extension NewsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset < 0 {
            if offset < MAX_DROP_DOWN_OFFSET {
                scrollView.contentOffset.y = MAX_DROP_DOWN_OFFSET
            }

			var rect = bannerView.frame
            rect.origin.y = offset
            rect.size.height -= offset
            bannerView.backgroundView.frame = rect
        }
    }
}
