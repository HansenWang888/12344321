//
//  MeNewRedEnvelopeCell.swift
//  ProjectCSHB
//
//  Created by 汤姆 on 2019/8/22.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class MeNewRedEnvelopeCell: UICollectionViewCell {
    var model : HaderWavesIconModel?{
        didSet{
            iconImageView.image = UIImage(named: (model?.icon!)!)
            titleLab.text = model?.title!
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconImageView)
        addSubview(titleLab)
        addSubview(lineView)
        iconImageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(15.px)
            make.width.height.equalTo(40.px)
        }
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        lineView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(45.px)
            make.right.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var iconImageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private lazy var titleLab: UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.kTextColor
        lab.font = UIFont.systemFont(ofSize: 13.px)
        return lab
    }()
    lazy var lineView: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor.kLineColor
        return vi
    }()
}
