//
//  ContactsCell.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/24.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class ContactsCell: DYTableViewCell {

    var avartarImgV: UIImageView?
    
    var nameLabel: UILabel?
    
    var subTitle: UILabel?
    
    weak var subContentView: UIView?
    
    /**
     * 是否隐藏多余的区域
     */
    var isHiddenRedundantArea: Bool? {
        
        didSet {
            
            
            if self.isHiddenRedundantArea ?? false {
                self.subContentView?.snp.updateConstraints({ (make) in
                    make.edges.equalToSuperview();
                });
            } else {
                self.subContentView?.snp.updateConstraints({ (make) in
                    make.top.equalToSuperview().offset(14);
                    make.left.right.bottom.equalToSuperview();
                });
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier);
        self.setupSubview();
        
    }
   
    
   
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupSubview() {
        self.contentView.backgroundColor = UIColor.groupTableViewBackground;
        let view = UIView.init();
        view.backgroundColor = UIColor.white;
        view.addRounded(radius: 5);
        self.subContentView = view;
        self.avartarImgV = UIImageView.init();
        self.avartarImgV?.addRounded(radius: 5);
        self.nameLabel = UILabel.init();
        self.nameLabel?.textColor = UIColor.HWColorWithHexString(hex: "#6d6c6e");
        self.nameLabel?.font = UIFont.systemFont(ofSize: 14);
        self.subTitle = UILabel.init();
        self.subTitle?.font = UIFont.systemFont(ofSize: 13);
        self.subTitle?.textColor = UIColor.HWColorWithHexString(hex: "#8d8d8d");
        self.contentView.addSubview(view);
        view.addSubview(self.avartarImgV!);
        view.addSubview(self.nameLabel!);
        view.addSubview(self.subTitle!);
        
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(14);
            make.left.right.bottom.equalToSuperview();
        }
        self.avartarImgV?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(14);
            make.top.equalToSuperview().offset(8);
            make.size.equalTo(48);
        });
        
        self.nameLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.avartarImgV!.snp.right).offset(8);
            make.top.equalTo(self.avartarImgV!.snp.top);
            
        });
        
        self.subTitle?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.avartarImgV!.snp.right).offset(8);
            make.bottom.equalTo(self.avartarImgV!.snp.bottom).offset(-5);
        });
        
    }
    override var model: AnyObject? {
        
        didSet {
            
            if self.model!.self is ContactsModel {
                let realModel = self.model as! ContactsModel;
                self.avartarImgV!.kf.setImage(with: URL.init(string: realModel.avatar ?? ""), placeholder: UIImage.init(named: "msg3"), options: .none, progressBlock: nil) { (image, _, _, _) in
                };
                
                self.nameLabel!.text = realModel.nick;
                
                if realModel.type == 0 {
                    self.subTitle!.text = "有问题 找客服";
                } else {
                    self.subTitle!.text = "暂时无显示内容 后期再添加";
                }
            } else if self.model!.self is IMGroupInfoModel {
                let realModel = self.model as! IMGroupInfoModel;
                self.avartarImgV!.kf.setImage(with: URL.init(string: realModel.img ?? ""), placeholder: UIImage.init(named: "msg3"), options: .none, progressBlock: nil) { (image, _, _, _) in
                };
                
                self.nameLabel!.text = realModel.chatgName;
                
                self.subTitle!.text = realModel.notice;
                
            }
            
            
        }
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
