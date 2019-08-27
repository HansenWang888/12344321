//
//  MeNewViewController.swift
//  Project
//
//  Created by 汤姆 on 2019/8/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import JXSegmentedView
class MeNewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundColor()
//        self.automaticallyAdjustsScrollViewInsets = false
//        view.addSubview(scrollView)
        view.addSubview(headerView)
        view.addSubview(pageView)
        view.addSubview(listContainerView)
//        scrollView.snp.makeConstraints { (make) in
////            make.top.equalTo(-kStatusHeight)
//            make.top.left.equalToSuperview()
//            make.width.equalTo(kScreenWidth)
//            make.bottom.equalTo(-(kbottomBarHeight + 49))
//        }
        headerView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(kScreenWidth * 0.85)
        }
        pageView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom).offset(5)
            make.width.equalTo(kScreenWidth - 20)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(40)
        }
        
        listContainerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-(kbottomBarHeight + 49))
            make.top.equalTo(pageView.snp.bottom).offset(1)
        }
        
    }
 
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: 0, height: 800 )
        pageView.kCornerRad(rectCorner: [.topLeft,.topRight], cornerRad: 10)
      

    }
    lazy var headerView:MeNewHaderView  = {
        let headview = MeNewHaderView()
        headview.delegate = self
        return headview
    }()
    lazy var scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.showsVerticalScrollIndicator = false
        sc.showsHorizontalScrollIndicator = false
        return sc
    }()
   private lazy var pageView: JXSegmentedView = {
        let vi = JXSegmentedView()
        vi.backgroundColor = UIColor.white
        vi.dataSource = segmentedDataSource
        vi.delegate = self
        vi.contentScrollView = listContainerView.scrollView

        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorHeight = 1
        lineView.indicatorColor = UIColor.RGB(r: 190, g: 0, b: 54)
        lineView.indicatorWidth = 80.px
        vi.indicators = [lineView]
        return vi
    }()
    ///数据源
   private lazy var segmentedDataSource: JXSegmentedTitleImageDataSource = {
        let dataSource = JXSegmentedTitleImageDataSource()
        dataSource.isTitleColorGradientEnabled = true
        dataSource.titles = titles
        dataSource.titleNormalColor = UIColor.kTextColor
        dataSource.titleSelectedColor = UIColor.kTextColor
        dataSource.titleImageType = .leftImage
        dataSource.isImageZoomEnabled = true
    
        dataSource.normalImageInfos = ["hongBaoIcon", "dianziIcon", "yuebaoIcon", "qipaiIcon"]
        dataSource.loadImageClosure = {(imageView, normalImageInfo) in
            //如果normalImageInfo传递的是图片的地址，你需要借助SDWebImage等第三方库进行图片加载。
                //加载bundle内的图片，就用下面的方式，内部默认也采用该方法。
                imageView.image = UIImage(named: normalImageInfo)
            }
        dataSource.reloadData(selectedIndex: 0)

        return dataSource
    }()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    private let titles = ["红包","电子","余额宝","棋牌"]
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
extension MeNewViewController:JXSegmentedViewDelegate{
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
//        if let dotDataSource = segmentedDataSource  {
            //先更新数据源的数据
//            segmentedDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)

    }
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }

}
extension MeNewViewController:JXSegmentedListContainerViewDataSource{
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = pageView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            return MeNewRedEnvelopeViewController()
        }else if index == 1{
            return MeDianZiGamesController()
        }else if index == 2{
            return MeYuEBaoController()
        }else{
            return MeQiPaiController()
        }
    }
 
    
}
extension MeNewViewController:MeNewHaderDelegate{
    
    func shareTutorial(index: Int) {
        switch index {
        case 0:
            kLog("邀请码")
            break
        case 1:
            kLog("分享")
            break
        case 2:
            kLog("余额宝")
            break
        case 3:
            kLog("新手教程")
            break
        default:
            break
        }
    }
    
    ///退出登录
    func logOut() {
//        if appModel!.userInfo.isLogined {
           appModel!.logout()
//        }
    }
    func personalInfo(){
        kLog("个人信息")
    }
    func systemSettings()  {
        kLog("系统设置")
    }
    func financialCenter(index: Int) {
        switch index {
        case 0:
            kLog("充值中心")
            break
        case 1:
            kLog("提款中心")
            break
        case 2:
            kLog("代理中心")
            break
        case 3:
            kLog("资金明细")
            break
        default:
            break
        }
    }
}
