//
//  MenuViewController.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/2/3.
//  Copyright © 2017年 Jin. All rights reserved.
//

import UIKit
import Moya
import RealmSwift

class MenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    var themes = try! Realm().objects(Theme.self)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.menuTableView.register(HomeCell.self, forCellReuseIdentifier: "HomeCell")
        self.menuTableView.register(MenuCell.self, forCellReuseIdentifier: "MenuCell")
        self.menuTableView.rowHeight = 50
        loadThemes()
    }

    func loadThemes() {
        let provider = MoyaProvider<ZhihuDailyService>()
        provider.request(.themes) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    if let jsonResponse = try moyaResponse.mapJSON() as? [String: Any] {
                        guard let themes = jsonResponse["others"] as? [[String: AnyObject]] else {
                            return
                        }

                        for t in themes {
                            if let desc = t["description"] as? String,
                                let name = t["name"] as? String,
                            	let id = t["id"] as? Int,
                            	let thumbnail = t["thumbnail"] as? String,
                                let color = t["color"] as? Int {
                                let theme = Theme()
                                theme.desc = desc
                                theme.name = name
                                theme.id = id
                                theme.thumbnail = thumbnail
                                theme.color = color

                                DispatchQueue(label: "com.zhihu.theme").async {
                                    let realm = try! Realm()
                                    try! realm.write {
                                        realm.add(theme, update: true)
                                    }
                                }
                            }
                        }
                        DispatchQueue.main.async {
                            self.menuTableView.reloadData()
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            default: break
            }

        }
    }
}

// MARK: - UITableViewDelegate/UITableViewDataSource
extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let homeCell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
            return homeCell
        } else {
            let menuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
            let theme = themes[indexPath.row-1]
            menuCell.theme = theme
            return menuCell
        }

    }
}
