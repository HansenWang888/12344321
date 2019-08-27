//
//  ChatExtension.swift
//  Project
//
//  Created by 汤姆 on 2019/8/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import Foundation
import UIKit
///APP设置
let appModel = AppModel.shareInstance()
/// 屏幕宽
let kScreenWidth = UIScreen.main.bounds.width
///屏幕高
let kScreenHeight = UIScreen.main.bounds.height
/// 状态栏高
let kStatusHeight = UIApplication.shared.statusBarFrame.height
///底部Bar高
let kbottomBarHeight : CGFloat = kStatusHeight == 20 ? 0 : 34
/// 打印日志
func kLog<T>(_ message: T,
              file: String = #file,
//              method: String = #function,
              line: Int = #line)
{
    #if DEBUG
    print("\((file as NSString).lastPathComponent)(\(line)行): \(message)")
    #endif
    
}
///获取当前版本号
let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
extension UIColor {
    static func RGB(r:CGFloat,g:CGFloat,b:CGFloat, alpha: CGFloat = 1.0) -> UIColor{
        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
    }
    convenience init(_ hexString: String, alpha: Double = 1.0) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(255 * alpha) / 255)
    }
    ///背景颜色
    static var baseBackgroundColor:UIColor{
        return UIColor("#e3e3e3")
    }
    ///线的颜色
    static var kLineColor:UIColor {
        return UIColor("#cccccc")
    }
    ///文字颜色
    static var kTextColor:UIColor {
        return UIColor.RGB(r: 102, g: 102, b: 102)
    }
    
}
/// 按钮图片和文字对齐方式
enum TitleStyle {
    //    ///图片在左，文字在右，整体居中
    //    case Default
    ///图片在左，文字在右，整体居中
    case Left
    ///图片在右，文字在左，整体居中。
    case Right
    ///图片在上，文字在下，整体居中
    case Top
    ///图片在下，文字在上，整体居中
    case Bottom
    ///图片居中，文字在图片下面。
    case CenterTop
    ///图片居中，文字在图片上面面
    case CenterBottom
    ///图片居中，文字在上距离按钮顶部。
    case CenterUp
    ///图片居中，文字在按钮下边。
    case CenterDown
    ///图片在右，文字在左，距离按钮两边边距
    case RightLeft
    ///图片在左，文字在右，距离按钮两边边距
    case LeftRight
}
extension UIButton{
    /// 按钮图片和文字的排版
    ///
    /// - Parameters:
    ///   - style: 类型
    ///   - padding: 距离大小
    /// - Returns: 按钮
    func kButtonImageTitleStyle(_ style: TitleStyle, padding: CGFloat){
        if imageView?.image != nil && titleLabel?.text != nil {
            //先还原
            titleEdgeInsets = .zero
            imageEdgeInsets = .zero
            
            let imageRect: CGRect = imageView!.frame
            let titleRect: CGRect = titleLabel!.frame
            let totalHeight: CGFloat = (imageRect.size.height) + padding + (titleRect.size.height)
            let selfHeight = frame.size.height
            let selfWidth = frame.size.width
            switch style {
            case .Left:
                if padding != 0 {
                    titleEdgeInsets = UIEdgeInsets(top: 0, left: padding / 2, bottom: 0, right: -padding / 2)
                    
                    imageEdgeInsets = UIEdgeInsets(top: 0, left: -padding / 2, bottom: 0, right: padding / 2)
                }
                
                break
            case .Right:
                //图片在右，文字在左
                titleEdgeInsets = UIEdgeInsets(top: 0, left: -((imageRect.size.width) + padding / 2), bottom: 0, right: ((imageRect.size.width) + padding / 2))
                
                imageEdgeInsets = UIEdgeInsets(top: 0, left: ((titleRect.size.width) + padding / 2), bottom: 0, right: -((titleRect.size.width) + padding / 2))
                
                break
            case .Top:
                //图片在上，文字在下
                //图片在上，文字在下
                titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y),
                                               left: (selfWidth/2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: -((selfHeight - totalHeight) / 2 + imageRect.size.height + padding - titleRect.origin.y),
                                               right: -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 - imageRect.origin.y),
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: -((selfHeight - totalHeight)/2 - imageRect.origin.y),
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                break
            case .Bottom:
                //图片在下，文字在上。
                titleEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 - titleRect.origin.y),
                                               left: (selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: -((selfHeight - totalHeight) / 2 - titleRect.origin.y),
                                               right: -(selfWidth / 2 - titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: ((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y),
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: -((selfHeight - totalHeight) / 2 + titleRect.size.height + padding - imageRect.origin.y),
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                break
            case .CenterTop:
                titleEdgeInsets = UIEdgeInsets(top: -(titleRect.origin.y - padding),
                                               left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: (titleRect.origin.y - padding),
                                               right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: 0,
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                break
            case .CenterBottom:
                titleEdgeInsets = UIEdgeInsets(top: (selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                               left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: -(selfHeight - padding - titleRect.origin.y - titleRect.size.height),
                                               right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: 0,
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                break
            case .CenterUp:
                titleEdgeInsets = UIEdgeInsets(top: -(titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                               left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: (titleRect.origin.y + titleRect.size.height - imageRect.origin.y + padding),
                                               right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: 0,
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                break
            case .CenterDown:
                titleEdgeInsets = UIEdgeInsets(top: (imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                               left: (selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2,
                                               bottom: -(imageRect.origin.y + imageRect.size.height - titleRect.origin.y + padding),
                                               right: -(selfWidth / 2 -  titleRect.origin.x - titleRect.size.width / 2) - (selfWidth - titleRect.size.width) / 2)
                
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2),
                                               bottom: 0,
                                               right: -(selfWidth / 2 - imageRect.origin.x - imageRect.size.width / 2))
                
                break
            case .RightLeft:
                //图片在右，文字在左，距离按钮两边边距
                titleEdgeInsets = UIEdgeInsets(top: 0,
                                               left: -(titleRect.origin.x - padding),
                                               bottom: 0,
                                               right: (titleRect.origin.x - padding))
                
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth - padding - imageRect.origin.x - imageRect.size.width),
                                               bottom: 0,
                                               right: -(selfWidth - padding - imageRect.origin.x - imageRect.size.width))
                break
            case .LeftRight:
                //图片在左，文字在右，距离按钮两边边距
                titleEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (selfWidth - padding - titleRect.origin.x - titleRect.size.width),
                                               bottom: 0,
                                               right: -(selfWidth - padding - titleRect.origin.x - titleRect.size.width))
                imageEdgeInsets = UIEdgeInsets(top: 0,
                                               left: -(imageRect.origin.x - padding),
                                               bottom: 0,
                                               right: (imageRect.origin.x - padding))
                break
                //            default:
                //                break
            }
        }else{
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
}
extension UIViewController{
    
    /// 设置背景颜色
    func setBackgroundColor()  {
        self.view.backgroundColor = UIColor.baseBackgroundColor
    }
}
extension UIView{
    ///部分圆角 在控制器 viewDidLayoutSubviews 调用,
    func kCornerRad(rectCorner:UIRectCorner,cornerRad:CGFloat) {
        let bezierPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: cornerRad, height: cornerRad))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = bezierPath.cgPath
        self.layer.mask = maskLayer
    }
  
}
extension Double{
    var px : CGFloat{ //适配XR,MAX ,其他屏幕按尺寸缩小
        return kScreenWidth / 414 * CGFloat(self)
    }
}
extension CGFloat{
    var px : CGFloat{ //适配XR,MAX ,其他屏幕按尺寸缩小
        return kScreenWidth / 414 * self
    }
}
