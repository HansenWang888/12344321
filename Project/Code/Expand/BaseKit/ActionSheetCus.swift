//
//  ActionSheetCus.swift
//  Project
//
//  Created by fangyuan on 2019/2/11.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
typealias SelectBlock = (_ selectIndex:Int) -> Void
typealias SelectDataBlock = (_ anyData:Any,_ selectIndex:Int) -> Void
@objc protocol ActionSheetDelegate:NSObjectProtocol{
    func actionSheetDelegate(actionSheet:ActionSheetCus,index:NSInteger)
}
extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}
class ActionSheetCus: UIView,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @objc var selectBlock:SelectBlock?
    @objc var selectDataBlock:SelectDataBlock?
    @objc var delegate:ActionSheetDelegate?
    @objc var titleLabel:UILabel?
    
    var isShowFliterTextFiled:Bool?
    
    var dataArray:NSArray?
    var originArrs:NSArray?
    var bgView:UIView?
    var containView:UIView?
    var tableView:UITableView?
    var barImageview:UIImageView?
    
    var fliterTextFiled:UITextField?
    var inputTfString:String?
    
    @objc convenience init(array:NSArray,isShowFliterTextFiled:Bool) {
        
        self.init(array:array)
        self.isShowFliterTextFiled = isShowFliterTextFiled
        self.initFliterTextField(isShowFliterTextField: self.isShowFliterTextFiled!)
    }
    @objc init(array:NSArray) {
        let newArr:NSMutableArray = NSMutableArray.init(array: array)
        newArr.add("取消")
        self.originArrs = newArr
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
        if height < 90{
            height = 90
        }
        if height > NSInteger(self.frame.size.height - 100){
            height = NSInteger(self.frame.size.height - 100)
        }
        
        let width:NSInteger = NSInteger(self.frame.size.width - 60)
        self.containView?.frame = CGRect.init(x: 30, y: height, width: width, height: height)
        
        self.containView?.backgroundColor = UIColor.white
        self.containView?.layer.masksToBounds = true
        self.containView?.layer.cornerRadius = 9.0
        self.containView?.layer.borderWidth = 0.5
        self.containView?.layer.borderColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        
        self.barImageview = UIImageView.init(image: UIImage.init(named: "navBarBg"))
        self.containView?.addSubview(self.barImageview!)
        self.barImageview!.mas_makeConstraints { (make:MASConstraintMaker!) in
            make?.left.equalTo()(self.containView)
            make?.right.equalTo()(self.containView)
            make?.top.equalTo()(self.containView)
            make?.height.equalTo()(44)
        }
        
        self.titleLabel = UILabel()
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        self.titleLabel?.textAlignment = NSTextAlignment.center;
        self.titleLabel?.textColor = UIColor.init(white: 1.0, alpha: 1.0);
        self.titleLabel?.backgroundColor = UIColor.clear
        self.containView?.addSubview(self.titleLabel!);
        self.titleLabel?.mas_makeConstraints({ (make:MASConstraintMaker!) in
            make?.left.equalTo()(self.containView)
            make?.right.equalTo()(self.containView)
            make?.top.equalTo()(self.containView)
            make?.height.equalTo()(44)
        })
        
        self.fliterTextFiled = UITextField()
        self.fliterTextFiled?.font = UIFont.systemFont(ofSize: 18)
        self.fliterTextFiled?.textAlignment = NSTextAlignment.center;
        self.fliterTextFiled?.returnKeyType = UIReturnKeyType.search
        self.fliterTextFiled?.borderStyle = UITextField.BorderStyle.roundedRect
        self.fliterTextFiled?.clearButtonMode = .whileEditing
        self.fliterTextFiled?.placeholder = "输入筛选";
        self.fliterTextFiled?.textColor = UIColor.black;
        self.fliterTextFiled?.backgroundColor = UIColor.white
        self.fliterTextFiled?.delegate = self;
        self.fliterTextFiled?.layer.masksToBounds = true;
        self.fliterTextFiled?.layer.borderWidth = 1;
        self.fliterTextFiled?.layer.borderColor = UIColor.gray.cgColor;
        self.containView?.addSubview(self.fliterTextFiled!);
        self.fliterTextFiled?.mas_makeConstraints({ (make:MASConstraintMaker!) in
            make?.left.equalTo()(self.containView)?.offset()(20)
            make?.right.equalTo()(self.containView)?.offset()(-20)
            make?.top.equalTo()(self.titleLabel?.mas_bottom)?.offset()(0)
            make?.height.equalTo()(0)
        })
        self.fliterTextFiled?.addTarget(self, action: #selector(textField1TextChange(_:)), for: .editingChanged)
        self.tableView = UITableView(frame: self.bounds, style: UITableView.Style.plain)
        self.tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.containView?.addSubview(self.tableView!)
        self.tableView?.rowHeight = 46
        self.tableView?.backgroundColor = UIColor.clear
        self.tableView?.delegate = self;
        self.tableView?.dataSource = self;
        self.tableView?.mas_makeConstraints({ (make:MASConstraintMaker?) in
            make?.left.equalTo()(self.containView)
            make?.right.equalTo()(self.containView)
            make?.bottom.equalTo()(self.containView)
            make?.top.equalTo()(self.fliterTextFiled?.mas_bottom)
        })
        
        
    }
    func initFliterTextField(isShowFliterTextField: Bool) {
        if self.isShowFliterTextFiled==true {
            self.fliterTextFiled?.mas_updateConstraints({ (make:MASConstraintMaker!) in
                make?.top.equalTo()(self.titleLabel?.mas_bottom)?.offset()(3)
                make?.height.equalTo()(40)
            })
            
            self.tableView?.mas_updateConstraints({ (make:MASConstraintMaker!) in
                make?.top.equalTo()(self.fliterTextFiled?.mas_bottom)
            })
        }
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
            
            let lineView:UIView = UIView()
            cell?.addSubview(lineView)
            lineView.backgroundColor = UIColor.init(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
            lineView.mas_makeConstraints { (make:MASConstraintMaker?) in
                make?.left.equalTo()(cell)?.offset()(30)
                make?.right.equalTo()(cell)?.offset()(-30)
                make?.bottom.equalTo()(cell?.mas_bottom)?.offset()(-0.5)
                make?.height.equalTo()(0.5)
            }
        }
        let label:UILabel = cell?.viewWithTag(111) as! UILabel
        let title = self.dataArray?.object(at: indexPath.row)
        label.text = title as? String
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.delegate != nil{
            self.delegate?.actionSheetDelegate(actionSheet: self, index: indexPath.row)
        }
        if self.selectBlock != nil{
            self.selectBlock!(indexPath.row)
        }
        if self.selectDataBlock != nil {
            self.selectDataBlock!(self.dataArray!,indexPath.row)
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
                if self.isShowFliterTextFiled == true {
                    self.containView?.frame.origin.y = (self.frame.size.height - (self.containView?.frame.size.height)!)/2
                    
                    return;
                }
                self.containView?.frame.origin.y = self.frame.size.height - (self.containView?.frame.size.height)! - 8
                
            }
        }else{
            self.bgView?.alpha = 1.0
            self.containView?.frame.origin.y = self.frame.size.height - (self.containView?.frame.size.height)! - 8
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
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.hiddenWithAnimation(ani: true)
        }
    }
    // MARK:- textField Targe&Delegate
    @objc private func textField1TextChange(_ textField: UITextField) {
        let flterAarray = NSMutableArray.init(array: self.originArrs!)
        let pre = NSPredicate(format: "SELF CONTAINS %@", textField.text!)
        flterAarray.filter(using: pre)
        
        if !textField.text!.isEmpty{
            if textField.text!.isInt{
//                let i:Int = Int(textField.text!)!
                if Int(textField.text!)  == 0{
                    textField.layer.borderColor = UIColor.red.cgColor
                }else{
                    textField.layer.borderColor = UIColor.gray.cgColor
                }
                
                textField.text = String(Int(textField.text!)!)
            }else{
                textField.layer.borderColor = UIColor.gray.cgColor
            }
            
            
            let pre = NSPredicate(format: "SELF MATCHES %@", "(^[\u{4e00}-\u{9fa5}]+$)")
            let isMatch = pre.evaluate(with: textField.text!);
            if !isMatch {
                textField.layer.borderColor = UIColor.red.cgColor
            }else{
                textField.layer.borderColor = UIColor.gray.cgColor
            }
            self.inputTfString = textField.text
            self.dataArray = flterAarray
        }else{
            self.inputTfString = ""
            self.dataArray = self.originArrs
        }
        
        self.tableView?.reloadData()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self .textField1TextChange(_ : textField)
        textField.resignFirstResponder()
        self.endEditing(true);
        return true;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.fliterTextFiled) {
            //如果是删除减少字数，都返回允许修改
            if string.isEmpty {
                textField.layer.borderColor = UIColor.gray.cgColor
                return true;
            }
            else{
                textField.layer.borderColor = UIColor.red.cgColor
                if range.location >= 10
                {
                    return false;
                }
//                if range.location == 0 && string == "0"
//                {
////                    if range.location == 1 && string == "0"
////                    {
//                        return false;
////                    }
//                }
            }
        }
        textField.layer.borderColor = UIColor.gray.cgColor
        return true;
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let offsetx:CGFloat  = (self.containView?.frame.origin.y)! - 33;
        UIView.animate(withDuration: 0.5) {
            self.containView?.transform = CGAffineTransform(translationX: 0, y: -offsetx)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5) {
            self.containView?.transform = CGAffineTransform.identity
        }
    }
    
    
    
}
