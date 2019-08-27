//
//  SelectBankView.swift
//  Project
//
//  Created by fangyuan on 2019/2/26.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
@objc protocol SelectBankDelegate:NSObjectProtocol{
    func selectBankDelegate(view:SelectBankView,index:NSInteger)
}

class SelectBankCell: UITableViewCell {
    var iconView:UIImageView!
    var titleLabel:UILabel!
    var descLabel:UILabel!
    var selectBtn:UIButton!
    
     func initView() {
        // Initialization code
        self.iconView = UIImageView()
        self.iconView.backgroundColor = UIColor.clear
        self.iconView.image = UIImage.init(named: "ccooin")
        self.iconView.layer.masksToBounds = true
        self.iconView.layer.cornerRadius = 15
        self.addSubview(self.iconView)
        self.iconView.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.left.equalTo()(self)?.offset()(20)
            make?.centerY.equalTo()(self.mas_centerY)
            make?.width.equalTo()(30)
            make?.height.equalTo()(30)
        }
        
        self.titleLabel = UILabel()
        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.font = UIFont.systemFont(ofSize: 16)
        self.titleLabel.textColor = UIColor(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1)
        self.addSubview(self.titleLabel)
        self.titleLabel.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.left.equalTo()(self.iconView.mas_right)?.offset()(20)
            make?.centerY.equalTo()(self.iconView)?.offset()(-12)
        }
        
        self.descLabel = UILabel()
        self.descLabel.backgroundColor = UIColor.clear
        self.descLabel.font = UIFont.systemFont(ofSize: 14)
        self.descLabel.textColor = UIColor.lightGray
        self.addSubview(self.descLabel)
        self.descLabel.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.left.equalTo()(self.iconView.mas_right)?.offset()(20)
            make?.centerY.equalTo()(self.iconView)?.offset()(12)
        }
        
        self.selectBtn = UIButton(type: UIButton.ButtonType.custom)
        self.addSubview(self.selectBtn)
        self.selectBtn.setImage(UIImage.init(named: "wr1"), for: UIControl.State.normal)
        self.selectBtn.setImage(UIImage.init(named: "wr2"), for: UIControl.State.selected)
        self.selectBtn.contentEdgeInsets = UIEdgeInsets(top: 13, left: 13, bottom: 13, right: 13)
        self.selectBtn.mas_makeConstraints { (make:MASConstraintMaker?) in
            make?.centerY.equalTo()(self.mas_centerY)
            make?.right.equalTo()(self.mas_right)?.offset()(-20)
            make?.width.equalTo()(44)
            make?.height.equalTo()(44)
        }
        
        let lineView:UIView = UIView()
        lineView.backgroundColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
        self.addSubview(lineView)
        lineView.mas_makeConstraints({ (make:MASConstraintMaker!) in
            make?.left.equalTo()(self.mas_left)?.offset()(20)
            make?.right.equalTo()(self.mas_right)?.offset()(-20)
            make?.bottom.equalTo()(self.mas_bottom)
            make.height.equalTo()(0.5)
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

class SelectBankView: UIView ,UITableViewDelegate,UITableViewDataSource{
    var tableView:UITableView!
    @objc var dataArray:NSArray?
    var bgView:UIView?
    var containView:UIView?
    @objc var delegate:SelectBankDelegate?

    @objc init(array:NSArray) {
        self.dataArray = array
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
        
        var height:NSInteger = 76 + (self.dataArray?.count ?? 0)! * 66
        if height < 120{
            height = 120
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
        
        let titleLabel:UILabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.init(red: 80/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0)
        titleLabel.text = "选择到账银行卡"
        self.containView?.addSubview(titleLabel);
        titleLabel.mas_makeConstraints({ (make:MASConstraintMaker!) in
            make?.left.equalTo()(self.containView)?.offset()(20)
            make.top.equalTo()(self.containView)?.offset()(20)
        })
        
        let descLabel:UILabel = UILabel()
        descLabel.font = UIFont.systemFont(ofSize: 13)
        descLabel.textColor = UIColor.init(red: 180/255.0, green: 180/255.0, blue: 180/255.0, alpha: 1.0)
        descLabel.text = "请留意各银行到账时间"
        self.containView?.addSubview(descLabel);
        descLabel.mas_makeConstraints({ (make:MASConstraintMaker!) in
            make?.left.equalTo()(self.containView)?.offset()(20)
            make.top.equalTo()(titleLabel.mas_bottom)?.offset()(8)
        })
        
        let lineView:UIView = UIView()
        lineView.backgroundColor = UIColor.init(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
        self.containView?.addSubview(lineView)
        lineView.mas_makeConstraints({ (make:MASConstraintMaker!) in
            make?.left.equalTo()(self.containView?.mas_left)
            make?.right.equalTo()(self.containView?.mas_right)
            make?.top.equalTo()(descLabel.mas_bottom)?.offset()(15)
            make.height.equalTo()(0.5)
        })
        
        self.tableView = UITableView(frame: self.bounds, style: UITableView.Style.plain)
        self.tableView?.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.containView?.addSubview(self.tableView!)
        self.tableView?.rowHeight = 66
        self.tableView?.backgroundColor = UIColor.clear
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView?.delegate = self;
        self.tableView?.dataSource = self;
        self.tableView?.mas_makeConstraints({ (make:MASConstraintMaker?) in
            make?.left.equalTo()(self.containView)
            make?.right.equalTo()(self.containView)
            make?.bottom.equalTo()(self.containView)
            make?.top.equalTo()(lineView.mas_bottom)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idef = "cell"
        var cell:SelectBankCell? = tableView.dequeueReusableCell(withIdentifier: idef) as? SelectBankCell
        if cell == nil{
            cell = SelectBankCell(style: .default, reuseIdentifier: idef)
            cell!.initView()
        }
        let dic:NSDictionary = self.dataArray?.object(at: indexPath.row) as! NSDictionary
        cell?.titleLabel.text = dic.object(forKey: "title2") as? String
        cell?.descLabel.isHidden = true
        cell?.selectBtn.isUserInteractionEnabled = false
        cell?.titleLabel.mas_updateConstraints { (make:MASConstraintMaker?) in
            make?.centerY.equalTo()(cell?.iconView)
        }
        if indexPath.row < self.dataArray!.count - 1 {
            let imageUrl:String? = dic.object(forKey: "icon") as? String
            if imageUrl != nil{
                cell?.iconView!.sd_setImage(with: URL.init(string: imageUrl!), completed: nil)
            }
            cell?.descLabel.text = dic.object(forKey: "desc") as? String
            cell?.iconView?.isHidden = false
            
            let select:Bool = (dic.object(forKey: "selected") as! NSNumber).boolValue
            cell?.selectBtn.isSelected = select
        }else{
            cell?.iconView?.isHidden = true
            cell?.selectBtn.isSelected = false
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if self.delegate != nil{
            self.delegate?.selectBankDelegate(view: self, index: indexPath.row)
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
}
