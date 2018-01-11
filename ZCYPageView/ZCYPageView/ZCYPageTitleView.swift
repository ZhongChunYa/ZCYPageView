//
//  ZCYPageTitleView.swift
//  ZCYPageView
//
//  Created by 钟淳亚 on 2018/1/6.
//  Copyright © 2018年 钟淳亚. All rights reserved.
//

import UIKit

protocol ZCYPageTitleViewDelegate: NSObjectProtocol {
    // 点击title按钮调用代理，滚动contentView
    func selectPageTitleView(_ pageTitleView: ZCYPageTitleView, withIndex index: Int)
}

class ZCYPageTitleView: UIView {
    
    // 当前选中title下标
    private var mSelectedIndex: Int
    // 当前选中按钮
    private var mSelectedBtn: UIButton?
    
    private let mTitleConfig: ZCYPageTitleConfig
    private let mTitleViewDelegate: ZCYPageTitleViewDelegate
    
    // 存储所有title文本
    private let mTitleArr: [String]
    // 存储所有btn的宽度
    private var mBtnWidthArr = [CGFloat]()
    // 存储所有btn
    private var mBtnArr = [UIButton]()
    
    // 指示器
    private var mIndicatorView: UIView?
    private var mScrollView: UIScrollView!
    // scrollview内容总长度
    private var mContentWidth: CGFloat = 0.0
    
    // 颜色渐变
    private var mStartColor: (r: CGFloat, g: CGFloat, b: CGFloat)!
    private var mEndColor: (r: CGFloat, g: CGFloat, b: CGFloat)!
    
    init(frame: CGRect, titleArr: [String], config: ZCYPageTitleConfig, delegate: ZCYPageTitleViewDelegate, selectedIndex: Int = 0) {
        mTitleArr = titleArr
        mTitleConfig = config
        mTitleViewDelegate = delegate
        if selectedIndex >= titleArr.count
        || selectedIndex < 0 {
            mSelectedIndex = 0
        } else {
            mSelectedIndex = selectedIndex
        }
        
        super.init(frame: frame)
        initTitleView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    private func initTitleView() {
        if mTitleConfig.isNeedBottomSeparator {
            initBottomSeparator()
        }
        initScrollView()
        setupColors()
        initTitles()
        switch mTitleConfig.titleViewStyle {
        case .ZCYTitleViewStyleDefault:
            break
        case .ZCYTitleViewStyleUnderLine:
            initUnderLine()
        case .ZCYTitleViewStyleBorder:
            initBorder()
        case .ZCYTitleViewStyleCover:
            initCover()
        }
    }
    
    private func initBottomSeparator() {
        let bottom = UIView(frame: CGRect.init(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
        self.addSubview(bottom)
        bottom.backgroundColor = UIColor.lightGray
    }
    
    private func initScrollView() {
        mScrollView = UIScrollView(frame: CGRect(origin: CGPoint.zero, size: self.frame.size))
        mScrollView.showsVerticalScrollIndicator = false
        mScrollView.showsHorizontalScrollIndicator = false
        mScrollView.alwaysBounceHorizontal = true
        if !mTitleConfig.isNeedBounces {
            mScrollView.bounces = false
        }
        addSubview(mScrollView)
    }
    
    private func setupColors() {
        mStartColor = getRGBWithColor(mTitleConfig.titleColor)
        mEndColor = getRGBWithColor(mTitleConfig.titleSelectedColor)
    }
    
    private func initTitles() {
        for title in mTitleArr {
            let w = widthWithString(title, font: mTitleConfig.titleFont) + mTitleConfig.titleSpacing
            mBtnWidthArr.append(w)
            mContentWidth += w
        }
        
        var tempX: CGFloat = 0
        var btnH = mScrollView.frame.size.height
        if mTitleConfig.titleViewStyle == .ZCYTitleViewStyleUnderLine {
            btnH -= mTitleConfig.underlineHeight
        }
        if mContentWidth < mScrollView.frame.size.width {
            mScrollView.contentSize = mScrollView.frame.size
            mContentWidth = mScrollView.frame.size.width
            
            let tempW = mContentWidth / CGFloat(mTitleArr.count)
            for (index, value) in mTitleArr.enumerated() {
                mScrollView.addSubview(createBtn(frame: CGRect(x: tempX, y: 0, width: tempW, height: btnH), index: index, value: value))
                tempX += tempW
            }
        } else {
            mScrollView.contentSize = CGSize(width: mContentWidth, height: mScrollView.frame.size.height)
            
            for (index, value) in mTitleArr.enumerated() {
                mScrollView.addSubview(createBtn(frame: CGRect(x: tempX, y: 0, width: mBtnWidthArr[index], height: btnH), index: index, value: value))
                tempX += mBtnWidthArr[index]
            }
        }
    }
    
    private func initUnderLine() {
        var w: CGFloat = mBtnArr[0].frame.size.width
        if mTitleConfig.indicatorStyle == .ZCYIndicatorFixed {
            if mTitleConfig.indictorWidth <= 0 {
                mTitleConfig.indicatorStyle = .ZCYIndicatorDefault
            } else {
                w = mTitleConfig.indictorWidth
            }
        }
        mIndicatorView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - mTitleConfig.underlineHeight, width: w, height: mTitleConfig.underlineHeight))
        mScrollView.insertSubview(mIndicatorView!, at: 0)
        mIndicatorView?.center = CGPoint(x: mBtnArr[0].center.x, y: mIndicatorView!.center.y)
        mIndicatorView?.backgroundColor = mTitleConfig.underlineColor
    }
    
    private func initCover() {
        if mTitleConfig.indicatorStyle == .ZCYIndicatorFixed {
            mTitleConfig.indicatorStyle = .ZCYIndicatorDefault
        }
        let btnF = mBtnArr[0].frame
        mIndicatorView = UIView(frame: CGRect(origin: btnF.origin, size: btnF.size))
        mScrollView.insertSubview(mIndicatorView!, at: 0)
        mIndicatorView?.backgroundColor = mTitleConfig.coverColor
    }
    
    private func initBorder() {
        if mTitleConfig.indicatorStyle == .ZCYIndicatorFixed {
            mTitleConfig.indicatorStyle = .ZCYIndicatorDefault
        }
        let btnF = mBtnArr[0].frame
        mIndicatorView = UIView(frame: CGRect(origin: btnF.origin, size: btnF.size))
        mScrollView.insertSubview(mIndicatorView!, at: 0)
        mIndicatorView?.layer.borderWidth = mTitleConfig.borderWidth
        mIndicatorView?.layer.borderColor = mTitleConfig.borderColor.cgColor
        mIndicatorView?.layer.cornerRadius = mTitleConfig.borderCornerRadius
    }
    
    // MARK: - 修改按钮选中状态
    private func changeSelectedBtn(_ sender: UIButton) {
        if mSelectedBtn != sender {
            if mTitleConfig.titleZoomSwitch {
                mSelectedBtn?.transform = CGAffineTransform(scaleX: 1, y: 1)
                sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            mSelectedBtn?.setTitleColor(mTitleConfig.titleColor, for: .normal)
            sender.setTitleColor(mTitleConfig.titleSelectedColor, for: .normal)
            
            mSelectedBtn = sender
            mSelectedIndex = sender.tag
        }
    }
    
    // MARK: - 按钮滚动到中心处理
    private func scrollBtnToCenter(sender: UIButton) {
        if mContentWidth <= self.frame.size.width {
            return
        }
        
        var offsetX = sender.center.x - self.frame.size.width * 0.5
        if offsetX < 0 {
            offsetX = 0
        }
        
        let maxOffset = mContentWidth - self.frame.size.width
        if offsetX > maxOffset {
            offsetX = maxOffset
        }
        
        mScrollView.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
    }
    
    // MARK: - title颜色渐变处理
    private func titleGradientWithProgress(_ progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {
        
        let r = mEndColor.r - mStartColor.r
        let g = mEndColor.g - mStartColor.g
        let b = mEndColor.b - mStartColor.b
        
        let targetColor = UIColor(red: mStartColor.r + r * progress, green: mStartColor.g + g * progress, blue: mStartColor.b + b * progress, alpha: 1)
        let originalColor = UIColor(red: mEndColor.r - r * progress, green: mEndColor.g - g * progress, blue: mEndColor.b - b * progress, alpha: 1)
        
        originalBtn.titleLabel?.textColor = originalColor
        targetBtn.titleLabel?.textColor = targetColor
    }
    
    // MARK: - 指示器位置滑动处理
    private func setIndicatorViewTransformWithTargetBtn(_ targetBtn: UIButton) {
        weak var weakSelf = self
        if weakSelf?.mTitleConfig.indicatorStyle == .ZCYIndicatorFixed {
            UIView.animate(withDuration: 0.2) {
                weakSelf?.mIndicatorView?.center.x = targetBtn.center.x
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                weakSelf?.mIndicatorView?.frame.origin.x = targetBtn.frame.origin.x
                weakSelf?.mIndicatorView?.frame.size.width = targetBtn.frame.size.width
            }
        }
    }
    
    private func setIndicatorViewTransformWithProgress(_ progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {
        switch mTitleConfig.titleViewScrollStyle {
        case .ZCYTitleViewScrollStyleDefault:
            indicatorTransDefaultWithProgress(progress, originalBtn: originalBtn, targetBtn: targetBtn)
        case .ZCYTitleViewScrollStyleHalf:
            indicatorTransHalfWithProgress(progress, originalBtn: originalBtn, targetBtn: targetBtn)
        case .ZCYTitleViewScrollStyleEnded:
            indicatorTransEndedWithProgress(progress, originalBtn: originalBtn, targetBtn: targetBtn)
        }
    }
    
    private func indicatorTransDefaultWithProgress(_ progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {
        switch mTitleConfig.indicatorStyle {
        case .ZCYIndicatorDefault:
            let totalOffset = targetBtn.center.x - originalBtn.center.x
            let diff = targetBtn.frame.size.width - originalBtn.frame.size.width
            mIndicatorView?.center.x = originalBtn.center.x + totalOffset * progress
            mIndicatorView?.frame.size.width = originalBtn.frame.size.width + diff * progress
        case .ZCYIndicatorFixed:
            let totalOffset = targetBtn.center.x - originalBtn.center.x
            mIndicatorView?.center.x = originalBtn.center.x + totalOffset * progress
        }
    }
    
    private func indicatorTransHalfWithProgress(_ progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {
        weak var weakSelf = self
        switch mTitleConfig.indicatorStyle {
        case .ZCYIndicatorDefault:
            if progress >= 0.5 {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.frame.origin.x = targetBtn.frame.origin.x
                    weakSelf?.mIndicatorView?.frame.size.width = targetBtn.frame.size.width
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.frame.origin.x = originalBtn.frame.origin.x
                    weakSelf?.mIndicatorView?.frame.size.width = originalBtn.frame.size.width
                })
            }
        case .ZCYIndicatorFixed:
            if progress >= 0.5 {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.center.x = targetBtn.center.x
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.center.x = originalBtn.center.x
                })
            }
        }
    }
    
    private func indicatorTransEndedWithProgress(_ progress: CGFloat, originalBtn: UIButton, targetBtn: UIButton) {
        weak var weakSelf = self
        switch mTitleConfig.indicatorStyle {
        case .ZCYIndicatorDefault:
            if progress == 1.0 {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.frame.origin.x = targetBtn.frame.origin.x
                    weakSelf?.mIndicatorView?.frame.size.width = targetBtn.frame.size.width
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.frame.origin.x = originalBtn.frame.origin.x
                    weakSelf?.mIndicatorView?.frame.size.width = originalBtn.frame.size.width
                })
            }
        case .ZCYIndicatorFixed:
            if progress == 1.0 {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.center.x = targetBtn.center.x
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    weakSelf?.mIndicatorView?.center.x = originalBtn.center.x
                })
            }
        }
    }

    // MARK: - 创建title
    private func createBtn(frame: CGRect, index: Int, value: String) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.frame = frame
        mBtnArr.append(btn)
        btn.tag = index
        btn.setTitle(value, for: .normal)
        btn.setTitleColor(mTitleConfig.titleColor, for: .normal)
        btn.titleLabel?.font = mTitleConfig.titleFont
        btn.addTarget(self, action: #selector(onBtnClicked(_:)), for: .touchUpInside)
        
        if mSelectedIndex == index {
            mSelectedBtn = btn
            btn.setTitleColor(mTitleConfig.titleSelectedColor, for: .normal)
            if mTitleConfig.titleZoomSwitch {
                btn.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        }
        return btn
    }
    
    @objc private func onBtnClicked(_ sender: UIButton) {
        changeSelectedBtn(sender)
        scrollBtnToCenter(sender: sender)
        if mTitleConfig.titleViewStyle != .ZCYTitleViewStyleDefault {
            setIndicatorViewTransformWithTargetBtn(sender)
        }
        mTitleViewDelegate.selectPageTitleView(self, withIndex: mSelectedIndex)
    }
}

// MARK: - Public
extension ZCYPageTitleView {
    func setPageTitleViewWithProgress(_ progress: CGFloat, originalIndex: Int, targetIndex: Int) {
        let originalBtn = mBtnArr[originalIndex]
        let targetBtn = mBtnArr[targetIndex]
        
        scrollBtnToCenter(sender: targetBtn)
        
        if progress > 0.6 {
            changeSelectedBtn(targetBtn)
        }
        
        if mTitleConfig.titleZoomSwitch {
            originalBtn.transform = CGAffineTransform(scaleX: (1 - progress) * 0.2 + 1, y: (1 - progress) * 0.2 + 1)
            targetBtn.transform = CGAffineTransform(scaleX: progress * 0.2 + 1, y: progress * 0.2 + 1)
        }
        
        if mTitleConfig.titleGradientSwitch {
            titleGradientWithProgress(progress, originalBtn: originalBtn, targetBtn: targetBtn)
        }
        
        if mTitleConfig.titleViewStyle != .ZCYTitleViewStyleDefault {
            setIndicatorViewTransformWithProgress(progress, originalBtn: originalBtn, targetBtn: targetBtn)
        }
    }
    
    func resetPageTitleViewTitle(_ title: String, ofIndex index: Int) {
        if index < mTitleArr.count {
            let btn = mBtnArr[index]
            btn.setTitle(title, for: .normal)
        }
    }
}

// MARK: -
extension ZCYPageTitleView {
    private func widthWithString(_ str: String, font: UIFont) -> CGFloat {
        return str.boundingRect(with: CGSize.zero, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size.width
    }
    
    private func heightWithString(_ str: String, font: UIFont) -> CGFloat {
        return str.boundingRect(with: CGSize.zero, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil).size.height
    }
    
    private func getRGBWithColor(_ color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r, g, b)
    }
}
