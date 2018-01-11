//
//  DefaultStaticVC.swift
//  ZCYPageView
//
//  Created by 钟淳亚 on 2018/1/5.
//  Copyright © 2018年 钟淳亚. All rights reserved.
//

import UIKit

class DefaultStaticVC: UIViewController {
    
    private var mPageTitleView: ZCYPageTitleView!
    private var mPageContentView: ZCYPageContentView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        let conf = ZCYPageTitleConfig()
        
        var rect = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 60)
        let titleArr = ["哈哈哈", "哈哈哈", "哈哈哈"]
        
        mPageTitleView = ZCYPageTitleView(frame: rect, titleArr: titleArr, config: conf, delegate: self)
        mPageTitleView.backgroundColor = UIColor.white
        self.view.addSubview(mPageTitleView)
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.blue
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.brown
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.red
        
        rect = CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 400)
        let arr = [vc1, vc2, vc3]
        mPageContentView = ZCYPageContentView(frame: rect, parentVC: self, childVCs: arr, delegate: self)
        self.view.addSubview(mPageContentView)
    }
}

extension DefaultStaticVC: ZCYPageTitleViewDelegate {
    func selectPageTitleView(_ pageTitleView: ZCYPageTitleView, withIndex index: Int) {
        mPageContentView.setPageContentViewWithIndex(index)
    }
}

extension DefaultStaticVC: ZCYPageContentViewDelegate {
    func scrollPageContentView(_ pageContentView: ZCYPageContentView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        mPageTitleView.setPageTitleViewWithProgress(progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
