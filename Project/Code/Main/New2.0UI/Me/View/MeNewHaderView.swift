//
//  MeNewHaderView.swift
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/8/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import ReusableKit
protocol MeNewHaderDelegate :AnyObject{
    ///退出登录
    func logOut()
    ///个人信息
    func personalInfo()
    ///系统设置
    func systemSettings()
    ///0:充值中心,1:提款x中心,2:代理中心,3:资金明细
    func financialCenter(index:Int)
    ///0:邀请码,1:分享赚钱,2:余额宝,3:新手教程
    func shareTutorial(index:Int)
    
}
fileprivate enum Reusable{
    static let cell = ReusableCell<HaderWavesIconCollectionViewCell>()
}
class MeNewHaderView: UIView {
    weak var delegate:MeNewHaderDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setDatas()
        initUI()
        initHeaderUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   private lazy var titleLab: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.white
        l.font = UIFont.systemFont(ofSize: 20)
        l.text = "个人中心"
        return l
    }()
    ///设置
    private lazy var settingBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "shezhi"), for: .normal)
        btn.setTitle("设置", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(setting), for: .touchUpInside)
        return btn
    }()
    ///退出登录
    private lazy var logOutBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "tuichu"), for: .normal)
        btn.setTitle("退出登录", for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        return btn
    }()
   private lazy var hederImageView: UIImageView = {
        let im = UIImageView(image: UIImage(named: "meHeadeImage"))
        im.contentMode = .bottom
        im.isUserInteractionEnabled = true

        return im
    }()
    ///波浪图片
   private lazy var wavesIcon: UIImageView = {
        let img = UIImageView(image: UIImage(named: "wavesIcon"))
        img.isUserInteractionEnabled = true
        return img
    }()
   private lazy var lineview: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.kLineColor
        return v
    }()
    //MARK: - 头部
    /// 性别图片
    lazy var headerIcon: UIImageView = {
        let img = UIImageView(image: UIImage(named: appModel?.userInfo.gender == .female ? "female_icon": "male_icon"))
        img.isUserInteractionEnabled = true
        img.addTarget(self, selector: #selector(headerInfo))
        return img
    }()
    
    ///头像
    lazy var headerPortrait: UIImageView = {
        let img = UIImageView()
        img.kf.setImage(with: URL(string: (appModel?.userInfo.avatar ?? "")!), placeholder: UIImage(named: "haderPlaceholder"))
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 11
        img.isUserInteractionEnabled = true
        return img
    }()
    ///名字
    private lazy var nameLab: UILabel = {
        let lab = UILabel()
        lab.text = appModel?.userInfo.nick ?? "昵称"
        lab.textColor = UIColor.white
        lab.font = UIFont.systemFont(ofSize: 16.px)
        return lab
    }()
    ///个人签名
    private lazy var geRenQianMLab: UILabel = {
        let lab = UILabel()
        lab.text = "个性签名"
        lab.textColor = UIColor.RGB(r: 255, g: 218, b:169)
        lab.font = UIFont.systemFont(ofSize: 11)
        return lab
    }()
    ///是否在线
    lazy var onlineBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "onlineIcon"), for: .normal)
        btn.backgroundColor = UIColor.white
        btn.setTitle(" 在线", for: .normal)
        btn.setTitleColor(UIColor.RGB(r: 0, g: 137, b: 30), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 9)
        btn.addRounded(radius: 7)
        btn.isEnabled = false
        return btn
    }()
    ///账号ID
    private lazy var accountIDBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "accountIDIcon"), for: .normal)
        btn.setTitle(" 账号ID:\(appModel?.userInfo.userId ?? "0000")", for: .normal)
        btn.setTitleColor(UIColor.RGB(r: 99, g: 62, b: 13), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.backgroundColor = UIColor.RGB(r: 246, g: 139, b: 0)
        btn.addRounded(radius: 8.px)
        btn.isEnabled = false
        return btn
    }()
    //MARK: - 余额
    lazy var yueView: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor.RGB(r: 254, g: 51, b: 99)
        vi.layer.cornerRadius = 20
        return vi
    }()
    private lazy var yueIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "meYueIcon")
        return img
    }()
    
    private lazy var yueLab: UILabel = {
        let lab = UILabel()
        lab.text = "余额 (元)"
        lab.textColor = UIColor.RGB(r: 255, g: 149, b: 12)
        lab.font = UIFont.systemFont(ofSize: 12)
        return lab
    }()
    ///余额
    private lazy var moneyLab: UILabel = {
        let lab = UILabel()
        lab.text = "00.00"
        lab.textColor = UIColor.RGB(r: 255, g: 218, b: 169)
        lab.font = UIFont.systemFont(ofSize: 11)
        return lab
    }()
    //MARK: - 系统版本
    ///系统版本号
    private lazy var systemVBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "systemVIcon"), for: .normal)
        btn.setTitle(" 系统版本:V\(currentVersion)", for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        btn.isEnabled = false
        return btn
    }()
    //MARK: - 波浪图片
   private lazy var collectionView: UICollectionView = {
        let colle = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colle.register(Reusable.cell)
        colle.backgroundColor = UIColor.white
        colle.showsVerticalScrollIndicator = false
        colle.showsHorizontalScrollIndicator = false
        colle.delegate = self
        colle.dataSource = self
        colle.addRounded(radius: 10)
        return colle
    }()

   private lazy var layout: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.minimumLineSpacing = 0
        lay.minimumInteritemSpacing = 0
        return lay
    }()
    
    private lazy var bottomView: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor.white
        vi.layer.masksToBounds = true
        vi.layer.cornerRadius = 10
        return vi
    }()
    private lazy var financialView: UIView = {
        let vi = UIView()
        return vi
    }()
    
    
    
    private var dataSource = [HaderWavesIconModel]()
    private var btnArrs = [HaderWavesIconModel]()
    private var labTitelModels = [HaderWavesIconModel]()
    ///充值,提款,盈利
    var financialLabs = [UILabel]()
    
}
extension MeNewHaderView{
     @objc private func headerInfo(){
        self.delegate?.personalInfo()
    }
    @objc private func conterClick(btn:UIButton){
        self.delegate?.financialCenter(index: btn.tag)
    }
    @objc private func setting(){
        self.delegate?.systemSettings()
    }
    @objc private func logOut(){
        self.delegate?.logOut()
    }
    private func setDatas() {
        let model1 = HaderWavesIconModel(icon: "yaoqingmaIcon", title: "邀请码", content: appModel?.userInfo.invitecode ?? "0000")
        let model2 = HaderWavesIconModel(icon: "shareMoneyIconn", title: "分享赚钱", content: "带朋友一起")
        let model3 = HaderWavesIconModel(icon: "yuebaoIcon", title: "余额宝", content: "理财能手")
        let model4 = HaderWavesIconModel(icon: "xingshouIcon", title: "新手教程", content: "疑问解答")
        
        dataSource.append(model1)
        dataSource.append(model2)
        dataSource.append(model3)
        dataSource.append(model4)
        
        let btn1 = HaderWavesIconModel(icon: "congzhiIcon", title: "充值中心", content: "")
        let btn2 = HaderWavesIconModel(icon: "tikuanzhongxing", title: "提款中心", content: "")
        let btn3 = HaderWavesIconModel(icon: "dailizhongxingicon", title: "代理中心", content: "")
        let btn4 = HaderWavesIconModel(icon: "zijingmingxi", title: "资金明细", content: "")
        btnArrs.append(btn1)
        btnArrs.append(btn2)
        btnArrs.append(btn3)
        btnArrs.append(btn4)
        let labTitle1 = HaderWavesIconModel(icon: "", title: "今天充值", content: "¥ 00.00")
        let labTitle2 = HaderWavesIconModel(icon: "", title: "今天提款", content: "¥ 00.00")
        let labTitle3 = HaderWavesIconModel(icon: "", title: "今天盈利", content: "¥ 00.00")
        labTitelModels.append(labTitle1)
        labTitelModels.append(labTitle2)
        labTitelModels.append(labTitle3)
    }
    private func initUI(){
        //头部
        addSubview(hederImageView)
        hederImageView.addSubview(headerPortrait)
        headerPortrait.addSubview(headerIcon)
        addSubview(titleLab)
        addSubview(settingBtn)
        addSubview(logOutBtn)
        //波浪图片
        addSubview(wavesIcon)
        wavesIcon.addSubview(lineview)
        wavesIcon.addSubview(collectionView)
        wavesIcon.addSubview(financialView)
        //底部
        addSubview(bottomView)
        hederImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(kScreenWidth * 0.5)
        }
        wavesIcon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalTo(10)
            make.centerY.equalTo(hederImageView.snp.bottom)
            make.height.equalTo(110.px)
        }
        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(kStatusHeight + 15)
        }
        settingBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLab.snp.centerY)
            make.height.equalTo(20)
            make.width.equalTo(60)
            make.left.equalTo(10)
        }
        logOutBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLab.snp.centerY)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        logOutBtn.kButtonImageTitleStyle(.Right, padding: 5)
        headerPortrait.snp.makeConstraints { (make) in
            make.left.equalTo(wavesIcon.snp.left)
            make.width.height.equalTo(50.px)
            make.bottom.equalTo(wavesIcon.snp.top).offset(-10)
        }
        headerIcon.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        lineview.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(0.5)
            make.width.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalTo(lineview.snp.top)
        }
        financialView.snp.makeConstraints { (make) in
            make.top.equalTo(lineview.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-10)
        }
        bottomView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(wavesIcon.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
        }
        let pading :CGFloat = 20
        let btnW = ((kScreenWidth - 20 - pading * 8 ) / 4 - 1)
        let linW = ((kScreenWidth - 20) / 4 - 1)
        //按钮的布局
        for (index,model)  in btnArrs.enumerated() {
            let btn = UIButton()
            btn.tag = index
            btn.setImage(UIImage(named: model.icon!), for: .normal)
            btn.setTitleColor(UIColor.RGB(r: 102, g: 102, b: 102), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12.px)
            btn.setTitle(model.title!, for: .normal)
            bottomView.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview().offset(-5)
                make.width.equalTo(btnW)
                make.left.equalTo((btnW + pading * 2) * CGFloat(index) + pading)
                make.height.equalTo(bottomView.snp.height).offset(-20)
            }
            
            
            btn.kButtonImageTitleStyle(.CenterTop, padding: 20)
            btn.addTarget(self, action: #selector(conterClick), for: .touchUpInside)
            
        }
        //按钮边上的线
        for (index,_)  in btnArrs.enumerated() {
            let lineV = UIView()
            lineV.backgroundColor = UIColor.kLineColor
            bottomView.addSubview(lineV)
            if index != 3{
                lineV.snp.makeConstraints { (make) in
                    make.centerY.equalToSuperview()
                    make.width.equalTo(0.5)
                    make.height.equalTo(bottomView.snp.height).offset(-35)
                    make.left.equalTo(linW * CGFloat(index + 1))
                }
            }
        }
        let labW = (kScreenWidth - 20) / 3 - 1
        for (index,model) in labTitelModels.enumerated() {
            let lab = UILabel()
            lab.textAlignment = .center
            lab.text = model.title!
            lab.textColor = UIColor.kTextColor
            lab.font = UIFont.systemFont(ofSize: 13)
            financialView.addSubview(lab)
            lab.snp.makeConstraints { (make) in
                make.bottom.equalTo(financialView.snp.centerY)
                make.left.equalTo(labW * CGFloat(index))
                make.width.equalTo(labW)
            }
            let contentLab = UILabel()
            contentLab.tag = index + 100
            contentLab.textAlignment = .center
            contentLab.text = model.content
            contentLab.font = UIFont.systemFont(ofSize: 11)
            switch index{
            case 0:
                contentLab.textColor = UIColor.RGB(r: 0, g: 137, b: 30)
                break
            case 1:
                contentLab.textColor = UIColor.RGB(r: 246, g: 139, b: 0)
                break
            case 2:
                contentLab.textColor = UIColor.RGB(r: 254, g: 51, b: 99)
                break
            default:
                break
            }
            financialView.addSubview(contentLab)
            contentLab.snp.makeConstraints { (make) in
                make.centerX.equalTo(lab.snp.centerX)
                make.top.equalTo(lab.snp.bottom).offset(5)
            }
            financialLabs.append(contentLab)
            let lineView = UIView()
            lineView.backgroundColor = UIColor.kLineColor
            financialView.addSubview(lineView)
            if index > 0{
                
                lineView.snp.makeConstraints { (make) in
                    make.width.equalTo(0.5)
                    make.centerY.equalToSuperview()
                    make.height.equalTo(financialView.snp.height).offset(-30)
                    make.left.equalTo(labW * CGFloat(index))
                }
            }
        }
        
    }
    
    func initHeaderUI() {
        hederImageView.addSubview(nameLab)
        hederImageView.addSubview(onlineBtn)
        hederImageView.addSubview(accountIDBtn)
        hederImageView.addSubview(geRenQianMLab)
        hederImageView.addSubview(yueView)
        hederImageView.addSubview(systemVBtn)
        yueView.addSubview(yueIcon)
        yueView.addSubview(yueLab)
        yueView.addSubview(moneyLab)
        nameLab.snp.makeConstraints { (make) in
            make.top.equalTo(headerPortrait.snp.top)
            make.height.equalTo(16.px)
            make.left.equalTo(headerPortrait.snp.right).offset(10)
        }
        onlineBtn.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(5)
            make.height.equalTo(16.px)
            make.width.equalTo(45.px)
            make.centerY.equalTo(nameLab.snp.centerY)
        }
        accountIDBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(headerPortrait.snp.centerY)
            make.left.equalTo(nameLab.snp.left)
            make.width.equalTo(100.px)
            make.height.equalTo(16.px)
        }
        geRenQianMLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(headerPortrait.snp.bottom)
            make.left.equalTo(headerPortrait.snp.right).offset(10)
        }
        yueView.snp.makeConstraints { (make) in
            make.top.equalTo(headerPortrait.snp.top)
            make.width.equalTo(140.px)
            make.height.equalTo(40.px)
            make.right.equalToSuperview().offset(20)
        }
        yueIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(34.px)
            make.left.equalTo(3)
        }
        yueLab.snp.makeConstraints { (make) in
            make.top.equalTo(5.px)
            make.left.equalTo(yueIcon.snp.right).offset(5)
        }
        moneyLab.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-5.px)
            make.left.equalTo(yueLab.snp.left)
            make.right.equalToSuperview().offset(-30)
        }
        systemVBtn.snp.makeConstraints { (make) in
            make.top.equalTo(yueView.snp.bottom)
            make.bottom.equalTo(wavesIcon.snp.top)
            make.right.equalToSuperview()
            make.left.equalTo(yueView.snp.left).offset(10)
        }
    }
    
}

extension MeNewHaderView:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.shareTutorial(index: indexPath.row)
    }
}
extension MeNewHaderView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(Reusable.cell, for: indexPath)
        cell.model = dataSource[indexPath.row]
        return cell
    }
    
    
}
extension MeNewHaderView:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellW = (kScreenWidth - 22) / 4 - 1
        if indexPath.row % 2 != 0{
            return CGSize(width: cellW + 10, height: 54.px)
        }else{
            return CGSize(width: cellW - 10, height: 54.px)
        }
    }
    
}
class HaderWavesIconCollectionViewCell: UICollectionViewCell {
    var model : HaderWavesIconModel?{
        didSet{
            iconImg.image = UIImage(named: model?.icon ?? "")
            titleLab.text = model?.title ?? ""
            contentLab.text = model?.content ?? ""
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(iconImg)
        addSubview(titleLab)
        addSubview(contentLab)
        iconImg.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30.px)
            make.left.equalTo(10)
        }
        titleLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(iconImg.snp.centerY).offset(-2)
            make.left.equalTo(iconImg.snp.right).offset(5)
        }
        contentLab.snp.makeConstraints { (make) in
            make.left.equalTo(titleLab.snp.left)
            make.top.equalTo(iconImg.snp.centerY).offset(2)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var iconImg: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    private lazy var titleLab: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.RGB(r: 102, g: 102, b: 102)
        l.font = UIFont.systemFont(ofSize: 12.px)
        
        return l
    }()
    private lazy var contentLab: UILabel = {
        let l = UILabel()
        l.textColor = UIColor.RGB(r: 246, g: 139, b: 0)
        l.font = UIFont.systemFont(ofSize: 9.px)
        return l
    }()
}
