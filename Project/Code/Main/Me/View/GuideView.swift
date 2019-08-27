//
//  GuideView.swift
//  Project
//
//  Created by fangyuan on 2019/2/18.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class GuideView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView:UICollectionView?
    var dataArray:NSArray?
    var action:ActionSheetCus?
    var saveSel:Selector?
    var saveTar:Any?
    @objc var button:UIButton?
    
    @objc init(array:NSArray, target:Any, selector:Selector){
        saveSel = selector
        saveTar = target
        let rect:CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        super.init(frame: rect)

        self.backgroundColor = UIColor.init(red: 245/255.0, green: 245/255.0, blue: 245/255.0, alpha: 1.0)
        self.dataArray = array
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = rect.size
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)//设置边距
        layout.minimumLineSpacing = 0.0;//每个相邻layout的上下
        layout.minimumInteritemSpacing = 0.0;//每个相邻layout的左右
        layout.headerReferenceSize = CGSize.init(width: 0, height: 0);
        
        collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.addSubview(collectionView!)
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isPagingEnabled = true
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.edges.equalTo()(self)
        }
        let btn:UIButton = UIButton(type: UIButton.ButtonType.custom)
        self.addSubview(btn)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.backgroundColor = UIColor.clear//UIColor(red: 244/255.0, green: 112/255.0, blue: 35/255.0, alpha: 1.0)
        btn.setTitle("关闭 X", for: UIControl.State.normal)
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
//        btn.layer.cornerRadius = 12;
//        btn.layer.borderColor = UIColor.white.cgColor
//        btn.layer.borderWidth = 1.0
        btn.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.right.equalTo()(self.mas_right)?.offset()(-15)
            make?.top.equalTo()(self.mas_top)?.offset()(30)
            make?.height.equalTo()(42)
            make?.width.equalTo()(80)
        }
        btn.addTarget(selector, action: #selector(self.hiddenSelf), for: UIControl.Event.touchUpInside)
        self.button = btn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.dataArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        var imageV = cell.viewWithTag(2)
        if imageV == nil{
            let imageView = UIImageView()
            imageView.tag = 2
            cell.addSubview(imageView)
            imageView.mas_makeConstraints { (make:MASConstraintMaker?) in
                make?.edges.equalTo()(cell)
            }
            imageV = imageView
            
            let btn:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
            btn.frame = CGRect.init(x: 0, y: 0, width: 0, height: 0)
            btn.addTarget(self, action: #selector(self.hiddenSelf), for: UIControl.Event.touchUpInside)
            imageView.addSubview(btn)
            btn.tag = 3
        }
        let imageView:UIImageView = imageV as! UIImageView
        let imageUrl:String = self.dataArray?[indexPath.row] as! String
        weak var weakSelf = self
        imageView.sd_setImage(with: URL.init(string: imageUrl)) { (UIImage, Error, SDImageCacheType, URL) in
            if indexPath.row == (weakSelf?.dataArray)!.count - 1{
                imageView.isUserInteractionEnabled = true;
                if imageView.image != nil{
                    let rate:CGFloat = UIScreen.main.bounds.size.height/1920.0
                    let h:NSInteger = NSInteger(1630 * rate)
                    let btn = imageView.viewWithTag(3)
                    btn?.frame = CGRect.init(x: Int(UIScreen.main.bounds.size.width/2.0 - 70), y: h - 30, width: 140, height: 60)
                }
            }else{
                imageView.isUserInteractionEnabled = false;
            }
        }
        if indexPath.row == self.dataArray!.count - 1{
            imageView.isUserInteractionEnabled = true;
            if imageView.image != nil{
                let rate:CGFloat = UIScreen.main.bounds.size.height/1920.0
                let h:NSInteger = NSInteger(1630 * rate)
                let btn = imageView.viewWithTag(3)
                btn?.frame = CGRect.init(x: Int(UIScreen.main.bounds.size.width/2.0 - 70), y: h - 30, width: 140, height: 60)
            }
        }else{
            imageView.isUserInteractionEnabled = false;
        }
        return cell
    }
    
//    //每个分区的内边距
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
//    }
//
//    //最小 item 间距
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 0;
//    }
//
//    //最小行间距
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
//        return 0;
//    }

    @objc func showWithAnimation(ani:Bool){
        var window:UIWindow? = UIApplication.shared.keyWindow
        if window?.windowLevel != UIWindow.Level.normal{
            let arr:NSArray = UIApplication.shared.windows as NSArray
            for index in arr{
                let win:UIWindow = index as! UIWindow
                if win.windowLevel == UIWindow.Level.normal{
                    window = win
                    break
                }
            }
        }
        if window == nil {
            return
        }
        window?.addSubview(self)
        if ani == true{
            self.alpha = 0.0
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1.0
            }
        }else{
            self.alpha = 1.0
        }
    }
    
    func hiddenWithAnimation(ani:Bool) {
        if ani == true{
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0.0
            }) { (end:Bool) in
                self.removeFromSuperview()
            }
            
        }else{
            self.removeFromSuperview()
        }
        if(saveTar != nil){
            var control:UIControl = UIControl();
            control.sendAction(saveSel!, to: saveTar!, for: nil)
        }
    }
    
    @objc func hiddenSelf() {
        self.hiddenWithAnimation(ani: true)
    }
}
