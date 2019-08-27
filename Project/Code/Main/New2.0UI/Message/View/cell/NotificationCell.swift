//
//  TableViewCell.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var hasRead: UIView!
    
    var model: NotificationCellModel?  {
        
        didSet {
            self.title.text = model!.title;
            self.content.text = model!.isStretch == false ? "" : model!.content;
            self.time.text = model!.time;
            self.hasRead.isHidden = model!.isRead ?? false ? true : false;
            self.title.textColor = model!.isRead ?? false ? UIColor.HWColorWithHexString(hex: "#6d6c6e") : UIColor.HWColorWithHexString(hex: "#fe3962");
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
