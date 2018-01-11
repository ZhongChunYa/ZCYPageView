//
//  UnderlineFixedVC.swift
//  ZCYPageView
//
//  Created by 钟淳亚 on 2018/1/11.
//  Copyright © 2018年 钟淳亚. All rights reserved.
//

import UIKit

class UnderlineFixedVC: UIViewController {

    private var mPageTitleView: ZCYPageTitleView!
    private var mPageContentView: ZCYPageContentView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.gray
        let conf = ZCYPageTitleConfig()
        conf.titleViewStyle = .ZCYTitleViewStyleUnderLine
        conf.indicatorStyle = .ZCYIndicatorFixed
        conf.indictorWidth = 20
        
        var rect = CGRect(x: 0, y: 100, width: UIScreen.main.bounds.size.width, height: 60)
        let titleArr = ["哈哈哈", "哈哈哈", "哈哈哈", "哈哈哈哈", "哈哈哈哈", "哈哈哈", "哈哈哈", "哈哈哈", "哈哈哈哈", "哈哈哈哈"]
        
        mPageTitleView = ZCYPageTitleView(frame: rect, titleArr: titleArr, config: conf, delegate: self)
        mPageTitleView.backgroundColor = UIColor.white
        self.view.addSubview(mPageTitleView)
        
        let vc1 = UIViewController()
        vc1.view.backgroundColor = UIColor.blue
        let vc2 = UIViewController()
        vc2.view.backgroundColor = UIColor.brown
        let vc3 = UIViewController()
        vc3.view.backgroundColor = UIColor.red
        let vc4 = UIViewController()
        vc4.view.backgroundColor = UIColor.green
        let vc5 = UIViewController()
        vc5.view.backgroundColor = UIColor.orange
        let vc6 = UIViewController()
        vc6.view.backgroundColor = UIColor.blue
        let vc7 = UIViewController()
        vc7.view.backgroundColor = UIColor.brown
        let vc8 = UIViewController()
        vc8.view.backgroundColor = UIColor.red
        let vc9 = UIViewController()
        vc9.view.backgroundColor = UIColor.green
        let vc10 = UIViewController()
        vc10.view.backgroundColor = UIColor.orange
        
        rect = CGRect(x: 0, y: 200, width: UIScreen.main.bounds.size.width, height: 400)
        let arr = [vc1, vc2, vc3, vc4, vc5, vc6, vc7, vc8, vc9, vc10]
        mPageContentView = ZCYPageContentView(frame: rect, parentVC: self, childVCs: arr, delegate: self)
        self.view.addSubview(mPageContentView)
    }

}

extension UnderlineFixedVC: ZCYPageTitleViewDelegate {
    func selectPageTitleView(_ pageTitleView: ZCYPageTitleView, withIndex index: Int) {
        mPageContentView.setPageContentViewWithIndex(index)
    }
}

extension UnderlineFixedVC: ZCYPageContentViewDelegate {
    func scrollPageContentView(_ pageContentView: ZCYPageContentView, progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        mPageTitleView.setPageTitleViewWithProgress(progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
