//
//  ZCYPageContentView.swift
//  ZCYPageView
//
//  Created by 钟淳亚 on 2018/1/6.
//  Copyright © 2018年 钟淳亚. All rights reserved.
//

import UIKit

@objc protocol ZCYPageContentViewDelegate: NSObjectProtocol {
    // 滚动contentView时改变titleView状态
    func scrollPageContentView(_ pageContentView: ZCYPageContentView, progress: CGFloat, originalIndex: Int, targetIndex: Int)
    // 获取contentView和offet，可不实现
    @objc optional func getPageContentView(_ pageContentView: ZCYPageContentView, offsetX: CGFloat)
}

class ZCYPageContentView: UIView {
    
    // 判断contentView是否可以滚动
    var mScrollSwitch: Bool
    
    private let mContentViewDelegate: ZCYPageContentViewDelegate?
    
    private let mParentVC: UIViewController
    private let mChildVCs: [UIViewController]
    
    private var mScrollView: UIScrollView!
    
    private var mCurrentOffsetX: CGFloat = 0
    
    // 判断是否点击title来滚动页面
    private var mIsClickTitle: Bool = false
    
    init(frame: CGRect, parentVC: UIViewController, childVCs: [UIViewController], delegate: ZCYPageContentViewDelegate?, scrollSwitch: Bool = true) {
        mScrollSwitch = scrollSwitch
        if delegate == nil && scrollSwitch == true {
            mScrollSwitch = false
        }
        mContentViewDelegate = delegate
        mParentVC = parentVC
        mChildVCs = childVCs
        
        super.init(frame: frame)
        initScrollView()
        initContent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private func initScrollView() {
        mScrollView = UIScrollView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        mScrollView.showsVerticalScrollIndicator = false
        mScrollView.showsHorizontalScrollIndicator = false
        mScrollView.alwaysBounceHorizontal = true
        mScrollView.isPagingEnabled = true
        mScrollView.bounces = false
        mScrollView.delegate = self
        mScrollView.contentSize = CGSize(width: mScrollView.frame.width * CGFloat(mChildVCs.count), height: mScrollView.frame.size.height)
        if !mScrollSwitch {
            mScrollView.isScrollEnabled = false
        }
        addSubview(mScrollView)
    }
    
    private func initContent() {
        var tempX: CGFloat = 0
        for vc in mChildVCs {
            mParentVC.addChildViewController(vc)
            vc.view.frame = CGRect(origin: CGPoint(x: tempX, y: 0), size: self.frame.size)
            mScrollView.addSubview(vc.view)
            tempX += self.frame.size.width
        }
    }
}

// MARK: - Public
extension ZCYPageContentView {
    func setPageContentViewWithIndex(_ index: Int) {
        mIsClickTitle = true
        weak var weakSelf = self
        let offset = CGFloat(index) * mScrollView.frame.size.width
        UIView.animate(withDuration: 0.2, animations: {
            weakSelf?.mScrollView.contentOffset = CGPoint(x: offset, y: 0)
        }) { (_) in
            if let delegate = weakSelf?.mContentViewDelegate {
                if delegate.responds(to: #selector(ZCYPageContentViewDelegate.getPageContentView(_:offsetX:))) {
                    delegate.getPageContentView!(weakSelf!, offsetX: offset)
                }
            }
        }
    }
}

// MARK: - UIScrollView Delagate
extension ZCYPageContentView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        mIsClickTitle = false
        mCurrentOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if mContentViewDelegate!.responds(to: #selector(ZCYPageContentViewDelegate.getPageContentView(_:offsetX:))) {
            mContentViewDelegate!.getPageContentView!(self, offsetX: scrollView.contentOffset.x)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if mIsClickTitle {
            return
        }
        
        var progress: CGFloat = 0
        var originalIndex: Int = 0
        var targetIndex: Int = 0
        
        let curOffsetX = scrollView.contentOffset.x
        let scrollViewW = mScrollView.frame.size.width
        
        if curOffsetX > mCurrentOffsetX { // left
            
            progress = curOffsetX / scrollViewW - floor(curOffsetX / scrollViewW)
            originalIndex = Int(floor(curOffsetX / scrollViewW))
            targetIndex = originalIndex + 1
            if targetIndex >= mChildVCs.count {
                progress = 1
                targetIndex = mChildVCs.count - 1
            }
            if curOffsetX - mCurrentOffsetX == scrollViewW {
                progress = 1
                targetIndex = originalIndex
            }
        } else {    // right
            progress = 1 - (curOffsetX / scrollViewW - floor(curOffsetX / scrollViewW))
            targetIndex = Int(floor(curOffsetX / scrollViewW))
            originalIndex = targetIndex + 1
            if originalIndex >= mChildVCs.count {
                originalIndex = mChildVCs.count - 1
            }
        }
        
        mContentViewDelegate?.scrollPageContentView(self, progress: progress, originalIndex: originalIndex, targetIndex: targetIndex)
    }
}
