//
//  DYMaskingView.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/31.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class DYMaskingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var compeletedBlock: ((_ items:[Any]) ->Void)?
    var contentHeight: CGFloat = 244;
    var pickerBackgroudColor = UIColor.white;
    var titleColor = UIColor.black;
    var title: String?
    init() {
        super.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight))
       
    }

    override func layoutSubviews() {
        super.layoutSubviews();
        if self.subviews.count == 0 {
            self.setupSubview();
            self.titleLabel.text = self.title;
            self.contentView.backgroundColor = self.pickerBackgroudColor;
            self.titleLabel.textColor = self.titleColor;
        }
    }
    
    func setPicker(_ picker: UIView) {
        self.pickerContentView.addSubview(picker);
        picker.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    required init?(coder aDecoder: NSCoder) {
    //        fatalError("init(coder:) has not been implemented")
    //    }
    
    
    /**
     * 显示到某个view
     * @param view 要显示的view 为nil时显示到window
     *
     */
    func showOnView(_ view: UIView?, compeleted: @escaping ([Any]) -> Void) {
        self.compeletedBlock = compeleted
        if view != nil {
            view?.addSubview(self)
            self.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            return
        }
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    @objc func dismiss() {
        self.removeFromSuperview()
        self.compeletedBlock = nil
    }
    
    
    private func setupSubview() {
        let btn = UIButton.init();
        btn.addTarget(self, action: #selector(dismiss), for: UIControl.Event.touchUpInside);
        self.addSubview(btn);
        self.addSubview(self.contentView);
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.pickerContentView)
        
        btn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        self.contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(contentHeight);
        }
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(44)
//            make.left.equalTo(self.cancleBtn.snp.right)
//            make.right.equalTo(self.confirmBtn.snp.left)
        }
        self.pickerContentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom)
        }
        
        self.backgroundColor = UIColor.HWColorWithHexString(hex: "#000000", alpha: 0.4)
       
        
    }
    
    @objc private func cancleBtnClick() {
        self.dismiss()
        
    }
    @objc func confirmBtnClick() {
        
        
        self.dismiss()
    }
    lazy var pickerContentView: UIView = {
        let view = UIView();
        
        return view;
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    
    private lazy var cancleBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.system)
        btn.setTitle("取消", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    private lazy var confirmBtn: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.system)
        btn.setTitle("确定", for: UIControl.State.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        return btn
    }()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.HWColorWithHexString(hex: "#333333")
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    
    

}
