//
//  BaseNewNavViewController.swift
//  Project
//
//  Created by 汤姆 on 2019/8/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class BaseNewNavViewController: UINavigationController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //导航栏背景颜色
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor =  UIColor.white

        self.navigationBar.setBackgroundImage(UIImage(named: "navBarBg"), for: .default)

        //导航标题文字
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)
        ]
        
        //添加手势代理
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            //添加手势识别
            self.interactivePopGestureRecognizer?.isEnabled = true
            setLeftItem()
        }
        //是否开启动画由传入决定，不会造成冲突
        super.pushViewController(viewController, animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            self.interactivePopGestureRecognizer?.isEnabled = false
            
        }
    }
    
    lazy var backBtn: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "nav_back"), for: .normal)
        btn.addTarget(self, action: #selector(back), for: .touchUpInside)
        return btn
    }()
   @objc private func back(){
        self.navigationController?.popViewController(animated: true)
    }
   private func setLeftItem()  {
        let item = UIBarButtonItem(customView: backBtn)
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        self.navigationItem.leftBarButtonItems = [spaceItem,item]
    }
}
