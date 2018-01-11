//
//  ViewController.swift
//  ZCYPageView
//
//  Created by 钟淳亚 on 2018/1/5.
//  Copyright © 2018年 钟淳亚. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var titleList = ["静止", "滚动", "文字渐变", "文字缩放", "覆盖", "下划线", "下划线定长", "边框", "多效果", "Content含有tableView"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = titleList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(DefaultStaticVC(), animated: true)
        } else if indexPath.row == 1 {
            self.navigationController?.pushViewController(DefaultScrollVC(), animated: true)
        } else if indexPath.row == 2 {
            self.navigationController?.pushViewController(TitleGradientVC(), animated: true)
        } else if indexPath.row == 3 {
            self.navigationController?.pushViewController(TitleZoomVC(), animated: true)
        } else if indexPath.row == 4 {
            self.navigationController?.pushViewController(CoverVC(), animated: true)
        } else if indexPath.row == 5 {
            self.navigationController?.pushViewController(UnderlineVC(), animated: true)
        } else if indexPath.row == 6 {
            self.navigationController?.pushViewController(UnderlineFixedVC(), animated: true)
        } else if indexPath.row == 7 {
            self.navigationController?.pushViewController(BorderVC(), animated: true)
        } else if indexPath.row == 8 {
            self.navigationController?.pushViewController(AllEffectVC(), animated: true)
        } else if indexPath.row == 9 {
            self.navigationController?.pushViewController(ContentWithTableViewVC(), animated: true)
        }
    }
}

