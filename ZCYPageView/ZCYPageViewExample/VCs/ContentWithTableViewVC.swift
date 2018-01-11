//
//  ContentWithTableViewVC.swift
//  ZCYPageView
//
//  Created by 钟淳亚 on 2018/1/11.
//  Copyright © 2018年 钟淳亚. All rights reserved.
//

import UIKit

class ContentWithTableViewVC: UIViewController {
    
    private var mPageTitleView: ZCYPageTitleView!
    private var mPageContentView: ZCYPageContentView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.gray
        let conf = ZCYPageTitleConfig()
        
        var rect = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 60)
        let titleArr = ["哈哈哈", "哈哈哈", "哈哈哈", "哈哈哈", "哈哈哈", "哈哈哈"]
        
        mPageTitleView = ZCYPageTitleView(frame: rect, titleArr: titleArr, config: conf, delegate: self)
        mPageTitleView.backgroundColor = UIColor.white
        self.view.addSubview(mPageTitleView)
        
        rect = CGRect(x: 0, y: 124, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 124)
        let vc1 = TableViewController()
        vc1.view.frame = rect
        let vc2 = TableViewController()
        vc2.view.frame = rect
        let vc3 = TableViewController()
        vc3.view.frame = rect
        let vc4 = TableViewController()
        vc4.view.frame = rect
        let vc5 = TableViewController()
        vc5.view.frame = rect
        let vc6 = TableViewController()
        vc6.view.frame = rect
        
        
        let arr = [vc1, vc2, vc3, vc4, vc5, vc6]
        mPageContentView = ZCYPageContentView(frame: rect, parentVC: self, childVCs: arr, delegate: self)
        self.view.addSubview(mPageContentView)
    }

}

extension ContentWithTableViewVC: ZCYPageTitleViewDelegate {
    func selectPageTitleView(_ pageTitleView: ZCYPageTitleView, withIndex index: Int) {
        mPageContentView.setPageContentViewWithIndex(index)
    }
}

extension ContentWithTableViewVC: ZCYPageContentViewDelegate {
    func scrollPageContentView(_ pageContentView: ZCYPageContentView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        mPageTitleView.setPageTitleViewWithProgress(progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
