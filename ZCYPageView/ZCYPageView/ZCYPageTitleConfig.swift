//
//  ZCYPageTitleConfig.swift
//  ZCYPageView
//
//  Created by 钟淳亚 on 2018/1/6.
//  Copyright © 2018年 钟淳亚. All rights reserved.
//

import UIKit

// TitleView的样式
public enum ZCYTitleViewStyle {
    case ZCYTitleViewStyleDefault       // 默认样式，无下划线，无边框，无覆盖
    case ZCYTitleViewStyleCover         // 覆盖样式
    case ZCYTitleViewStyleBorder        // 边框样式
    case ZCYTitleViewStyleUnderLine     // 下划线样式
}

// ContentView滚动时TitleView的样式（仅在Cover,Frame,UnderLine时有效）
public enum ZCYTitleViewScrollStyle {
    case ZCYTitleViewScrollStyleDefault     // 默认样式，跟随内容滚动
    case ZCYTitleViewScrollStyleHalf        // 滑动到一半改变位置
    case ZCYTitleViewScrollStyleEnded       // 滑动结束改变位置
}

// 指示器样式，仅在ZCYTitleViewStyleUnderLine样式时有效
public enum ZCYIndicatorStyle {
    case ZCYIndicatorDefault        // 默认样式，与title等长
    case ZCYIndicatorFixed          // 固定长度，水平中心与title中心相等
}

public class ZCYPageTitleConfig: NSObject {
    
    public var isNeedBounces: Bool = true
    public var isNeedBottomSeparator: Bool = false
    
    // 颜色渐变
    public var titleGradientSwitch: Bool = false
    // 缩放渐变
    public var titleZoomSwitch: Bool = false
    
    // title间距
    public var titleSpacing: CGFloat = 20.0
    // titleView大小
    public var titleViewSize: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
    
    // title颜色的设置需要使用RGB值来设置，在颜色渐变时才有效
    // title默认颜色
    public var titleColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    // title选中颜色
    public var titleSelectedColor: UIColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    // title字体大小
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    public var titleViewStyle: ZCYTitleViewStyle = .ZCYTitleViewStyleDefault
    public var titleViewScrollStyle: ZCYTitleViewScrollStyle = .ZCYTitleViewScrollStyleDefault
    
    // 指示器样式
    public var indicatorStyle: ZCYIndicatorStyle = .ZCYIndicatorDefault
    // 指示器长度，fixed样式下需要设置
    public var indictorWidth: CGFloat = 0
    
    // 下划线高度
    public var underlineHeight: CGFloat = 2.0
    // 下划线颜色
    public var underlineColor: UIColor = UIColor.red
    
    // 覆盖颜色
    public var coverColor: UIColor = UIColor.clear
    
    // 边框宽度
    public var borderWidth: CGFloat = 0.0
    // 边框颜色
    public var borderColor: UIColor = UIColor.clear
    // 边框圆角
    public var borderCornerRadius: CGFloat = 0.0
}
