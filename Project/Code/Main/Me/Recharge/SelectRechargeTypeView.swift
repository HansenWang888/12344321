//
//  SelectRechargeTypeView.swift
//  Project
//
//  Created by fangyuan on 2019/2/11.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
typealias SwiftClosure2 = (_ selectIndex:Int) -> Void

@objc protocol SelectRechargeTypeDelegate:NSObjectProtocol{
    func selectRechargeTypeDelegate(actionSheet:SelectRechargeTypeView,index:NSInteger)
}
class SelectRechargeTypeView: UIView,UITableViewDelegate,UITableViewDataSource {
    var tableView:UITableView?
    var dataArray:NSArray?
    var bgView:UIView?
    var containView:UIView?
    @objc var callbackFunc:SwiftClosure2?
    
    @objc var delegate:SelectRechargeTypeDelegate?
    @objc var titleLabel:UILabel?
//    typealias block = (NSInteger)
    
    @objc init(array:NSArray) {
        let newArr:NSMutableArray = NSMutableArray.init(array: array)
        self.dataArray = newArr
        let rect:CGRect = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        super.init(frame:rect)
        self.backgroundColor = UIColor.clear
        self.frame = rect
        self.bgView = UIView()
        self.addSubview(self.bgView!);
        self.bgView?.mas_makeConstraints({ (make:MASConstraintMaker?) in
            make?.edges.equalTo()(self)
        })
        self.bgView?.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        let tapGes:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        self.bgView?.addGestureRecognizer(tapGes)
        
        self.containView = UIView()
        self.addSubview(self.containView!);
        
        var height:NSInteger = 44 + (self.dataArray?.count ?? 0)! * 46
        
        if height > NSInteger(self.frame.size.height - 300){
            height = NSInteger(self.frame.size.height - 300)
        }
        if height < 200{
            height = 200
        }
        
        let width:NSInteger = NSInteger(self.frame.size.width)
        self.containView?.frame = CGRect.init(x: 0, y: height, width: width, height: height)
        
        self.containView?.backgroundColor = UIColor.white
//        self.containView?.layer.masksToBounds = true
//        self.containView?.layer.cornerRadius = 9.0
//        self.containView?.layer.borderWidth = 0.5
//        self.containView?.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        self.titleLabel = UILabel()
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        self.titleLabel?.textAlignment = NSTextAlignment.center;
        self.titleLabel?.textColor = UIColor.init(white: 1.0, alpha: 1.0);
        self.titleLabel?.backgroundColor = UIColor.init(red: 254/255.0, green: 57/255.0, blue: 98/255.0, alpha: 1.0)
        self.containView?.addSubview(self.titleLabel!);
        self.titleLabel?.mas_makeConstraints({ (make:MASConstraintMaker!) in
            make?.left.equalTo()(self.containView)
            make.right.equalTo()(self.containView)
            make.top.equalTo()(self.containView)
            make.height.equalTo()(44)
        })
        
        let cancelBtn:UIButton = UIButton(type: UIButton.ButtonType.custom)
        cancelBtn.backgroundColor = UIColor.clear;
        cancelBtn.setTitle("取消", for: UIControl.State.normal);
        self.containView?.addSubview(cancelBtn)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.addTarget(self, action: #selector(cancelAction), for: UIControl.Event.touchUpInside)
        cancelBtn.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.right.equalTo()(self.containView)
            make?.height.equalTo()(44)
            make?.width.equalTo()(60)
        }
        
        self.tableView = UITableView(frame: self.bounds, style: UITableView.Style.plain)
        self.tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.containView?.addSubview(self.tableView!)
        self.tableView?.rowHeight = 56
        self.tableView?.backgroundColor = UIColor.clear
        self.tableView?.showsVerticalScrollIndicator = false
        self.tableView?.showsHorizontalScrollIndicator = false
        self.tableView?.delegate = self;
        self.tableView?.dataSource = self;
        self.tableView?.mas_makeConstraints({ (make:MASConstraintMaker?) in
            make?.left.equalTo()(self.containView)
            make?.right.equalTo()(self.containView)
            make?.bottom.equalTo()(self.containView)
            make?.top.equalTo()(self.titleLabel?.mas_bottom)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idef = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: idef)
        if cell == nil{
            cell = UITableViewCell(style:.default, reuseIdentifier: idef)
            
            let label = UILabel(frame: (cell?.bounds)!)
            cell?.addSubview(label)
            label.textAlignment = NSTextAlignment.center
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 16)
            label.tag = 111
            label.mas_makeConstraints { (make:MASConstraintMaker?) in
                make?.edges.equalTo()(cell)
            }
            
            let imageView = UIImageView()
            cell?.addSubview(imageView)
            imageView.tag = 112;
            imageView.contentMode = .scaleAspectFit
            imageView.mas_makeConstraints { (make:MASConstraintMaker?) in
                make?.left.equalTo()(cell)?.offset()(40)
                make?.width.equalTo()(40)
                make?.height.equalTo()(40)
                make?.centerY.equalTo()(cell?.mas_centerY)
            }
            
            let pigView = UIImageView()
            cell?.addSubview(pigView)
            pigView.contentMode = .scaleAspectFit
            pigView.image = UIImage(named: "pig")
            pigView.mas_makeConstraints { (make:MASConstraintMaker?) in
                make?.right.equalTo()(cell)?.offset()(-40)
                make?.width.equalTo()(30)
                make?.height.equalTo()(30)
                make?.centerY.equalTo()(cell?.mas_centerY)
            }
            
            let lineView:UIView = UIView()
            cell?.addSubview(lineView)
            lineView.backgroundColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
            lineView.mas_makeConstraints { (make:MASConstraintMaker?) in
                make?.left.equalTo()(cell)
                make?.right.equalTo()(cell)
                make?.bottom.equalTo()(cell?.mas_bottom)?.offset()(-0.5)
                make?.height.equalTo()(0.5)
            }
        }
        let label:UILabel = cell?.viewWithTag(111) as! UILabel
        let imageView:UIImageView = cell?.viewWithTag(112) as! UIImageView
        
        let dic:NSDictionary = self.dataArray?.object(at: indexPath.row) as! NSDictionary
        let title = dic.object(forKey: "title")
        let iconName:String? = dic.object(forKey: "img") as? String
        if iconName != nil{
            imageView.sd_setImage(with: URL.init(string: iconName!), completed: nil);
        }
        label.text = title as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.delegate != nil{
            self.delegate?.selectRechargeTypeDelegate(actionSheet: self, index: indexPath.row)
        }
        if self.callbackFunc != nil{
            self.callbackFunc!(indexPath.row)
        }
        self.hiddenWithAnimation(ani: true)
    }
    
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
            self.bgView?.alpha = 0.0
            self.containView?.frame.origin.y = self.frame.size.height
            UIView.animate(withDuration: 0.3) {
                self.bgView?.alpha = 1.0
                self.containView?.frame.origin.y = self.frame.size.height - (self.containView?.frame.size.height)!
            }
        }else{
            self.bgView?.alpha = 1.0
            self.containView?.frame.origin.y = self.frame.size.height - (self.containView?.frame.size.height)!
        }
    }
    
    func hiddenWithAnimation(ani:Bool) {
        if ani == true{
            UIView.animate(withDuration: 0.3, animations: {
                self.bgView?.alpha = 0.0
                self.containView?.frame.origin.y = self.frame.size.height
            }) { (end:Bool) in
                self.delegate = nil
                self.removeFromSuperview()
            }
        }else{
            self.delegate = nil
            self.removeFromSuperview()
        }
    }
    
    @objc func cancelAction() {
        self.hiddenWithAnimation(ani: true)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.hiddenWithAnimation(ani: true)
        }
    }
}
