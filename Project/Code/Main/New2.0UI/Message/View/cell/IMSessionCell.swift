//
//  IMMessageCell.swift
//  Project
//
//  Created by fangyuan on 2019/8/20.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import Kingfisher

class IMSessionCell: DYTableViewCell {
    @IBOutlet weak var avartarImgV: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var haveMessage: UIView!
    
    var realModel: FYContacts?
    
    override var model: AnyObject? {
        
        didSet {
            self.realModel = self.model as? FYContacts;
            self.avartarImgV.kf.setImage(with: URL.init(string: realModel?.avatar ?? ""), placeholder: UIImage.init(named: "msg3"), options: .none, progressBlock: nil) { (image, _, _, _) in
            }
            self.nameLabel.text = realModel?.name;
            let message = IMMessageModule.sharedInstance().getMessageWithMessageId(realModel?.lastMessageId ?? "");
            if message.isDeleted || message.isRecallMessage {
                self.messageLabel.text = "暂未收到消息";
                realModel?.lastTimestamp = 0;
            } else {
                self.messageLabel.text = realModel?.lastMessage ?? "还没收到消息";
            }
            if realModel?.lastTimestamp == nil || realModel?.lastTimestamp == 0 {
                self.timeLabel.text = "";
            } else {
                
                let date = Date.init(timeIntervalSince1970: realModel!.lastTimestamp / 1000);
                self.timeLabel.text = self.getLastDisplayString(date: date);
            }
            self.haveMessage.isHidden = realModel?.unReadMsgCount ?? 0 > 0 ? false : true;
            self.updateGroupAvartar();
        }
    }
    
    private func updateGroupAvartar() {
        if self.model?.sessionType == FYChatConversationType.conversationType_GROUP {
            if self.model?.name.length == 0 || self.model?.avatar?.length == 0 {
                //获取群组信息并且跟新数据库会话信息
                IMMessageNetwork.getGroupInfo(groupId: self.model!.id).dy_startRequest { (response, error) in
                    if let r = response as? [String : Any] {
                        let model = IMGroupInfoModel.deserialize(from: r);
                        self.realModel?.name = model?.chatgName;
                        self.realModel?.avatar = model?.img;
                        IMSessionModule.updateSeesion(self.realModel!);
                        self.avartarImgV.kf.setImage(with: URL.init(string: self.model?.avatar ?? ""), placeholder: UIImage.init(named: "msg3"), options: .none, progressBlock: nil) { (image, _, _, _) in
                        }
                        self.nameLabel.text = self.model?.name;
                    }
                }
                
            }
        }
    }
    
    private func getLastDisplayString(date: Date) -> String {
        
        let calendar = Calendar.current;
        
        let unit:Set<Calendar.Component> = [Calendar.Component.day, Calendar.Component.month , Calendar.Component.year];
        let nowCp = calendar.dateComponents(unit, from: Date.init());
        let myCp = calendar.dateComponents(unit, from: date);
        
        let dateForm = DateFormatter.init();
        
        let component = calendar.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekday] , from: date);
        
        if nowCp != myCp {
            dateForm.dateFormat = "yyyy/MM/dd";
        } else {
            if nowCp == myCp {
                dateForm.amSymbol = "上午";
                dateForm.pmSymbol = "下午";
                dateForm.dateFormat = "aaa hh:mm";
            } else if (nowCp.day! - myCp.day!) == 1 {
                dateForm.amSymbol = "上午";
                dateForm.pmSymbol = "下午";
                dateForm.dateFormat = "昨天";
            } else {
                
                if (nowCp.day! - myCp.day!) <= 7{
                    
                    switch component.weekday {
                        
                    case 1:
                        dateForm.dateFormat = "星期日";
                        break;
                    case 2:
                        dateForm.dateFormat = "星期一";
                        break;
                    case 3:
                        dateForm.dateFormat = "星期二";
                        break;
                    case 4:
                        dateForm.dateFormat = "星期三";
                        break;
                    case 5:
                        dateForm.dateFormat = "星期四";
                        break;
                    case 6:
                        dateForm.dateFormat = "星期五";
                        break;
                    case 7:
                        dateForm.dateFormat = "星期六";
                        break;
                    default:
                        break;
                    }
                } else {
                    dateForm.dateFormat = "yyyy/MM/dd";
                }
            }
        }
        return dateForm.string(from: date);
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.avartarImgV.addRounded(radius: 5);
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
