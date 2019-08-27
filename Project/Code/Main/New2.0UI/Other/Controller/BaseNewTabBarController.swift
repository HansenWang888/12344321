//
//  BaseNewTabBarController.swift
//  Project
//
//  Created by 汤姆 on 2019/8/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class BaseNewTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor("#979797")], for: .selected)
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.red], for: .normal)
        
        setViewController()
        selectedIndex = 0
    }
    private func setViewController() {
        
        setChildViewController(SessionVC(), title: "消息", image: "xiaoxi")
        setChildViewController(GamesViewController(), title: "游戏", image:  "youxi")
        setChildViewController(ActivityMainViewController(), title: "活动", image:  "huodong")
        setChildViewController(ContactsVC(), title: "通讯录", image:  "tongxunlu")
        setChildViewController(MeNewViewController(), title: "我的", image: "wode")
        
    }
    /// 初始化子控制器
    private func setChildViewController(_ childController: UIViewController, title: String, image:String) {
        // 设置 tabbar 文字和图片
        childController.tabBarItem.image = UIImage(named: image + "_n")
        childController.tabBarItem.selectedImage = UIImage(named: image + "_s")
        
        childController.title = title
        // 添加导航控制器为 TabBarController 的子控制器
        let navVc = BaseNewNavViewController(rootViewController: childController)
        
        addChild(navVc)
    }
    
   

}
