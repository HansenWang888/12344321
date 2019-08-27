//
//  ContactsVC.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/24.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class ContactsVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "通讯录";
        
        self.setupSubView();
        
        // Do any additional setup after loading the view.
    }
    
    private func setupSubView () {
        
        self.initialHeaderView();
        self.view.backgroundColor = UIColor.groupTableViewBackground;
     
        self.tabBarController?.tabBar.addSubview(self.unreadView);
        self.unreadView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10);
            let width = kScreenWidth / CGFloat(self.tabBarController!.tabBar.items!.count);
            make.left.equalToSuperview().offset(width * 0.7);
        });
        self.view.addSubview(self.collectionView);
        self.collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview();
            make.top.equalTo(self.headerView.snp.bottom);
        }
        self.initialCells();
        
        let searchBtn = UIBarButtonItem.init(barButtonSystemItem: .search, target: self, action: #selector(searchBtnClick));
        let addBtn = UIBarButtonItem.init(image: UIImage.init(named: "nav_add_r"), style: .plain, target: self, action: #selector(addBtnClick));
        self.navigationItem.rightBarButtonItems = [];
        self.navigationItem.rightBarButtonItems?.append(addBtn);
        self.navigationItem.rightBarButtonItems?.append(searchBtn);
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "msg-bell"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(lefButtonClick));
        
        
    }
    
    @objc
    private func lefButtonClick() {
        
        let vc = NotificationVC.init();
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
        
    }

    
    @objc
    private func searchBtnClick() {
        
        
    }
    
    @objc
    private func addBtnClick() {
        
        self.menuView.show(from: self.navigationController!, withX: kScreenWidth - 32);
        
    }
    private func initialCells() {
        
        for index in 0..<self.headerView.subviews.count {
            
            let view = DYTableView.init();
            view.separatorColor = UIColor.clear;
            view.tableFooterView = UIView.init();
            view.register(ContactsCell.self, forCellReuseIdentifier: "cell");
            view.noDataText = "暂无消息";
            view.noDataImage = "state_empty";
            view.backgroundColor = UIColor.clear;
            view.rowHeight = 78;
            switch index {
            case 0:
                self.handleCustomerServiceData(view);
                self.handleCustomerServiceCellClick(view);
                break;
            case 1:
                view.dataSource = self;
                view.delegate = self;
                self.handleMyFriendData(view);
                break;
            case 2:
                self.handleMyGroupData(view);
                self.handleMyGroupCellClick(view);
                break;
            case 3:
                self.handleVerificationData(view);
                self.handleVerificationCellClick(view);
                break;
            default:
                break;
            }
            view.loadData();
            self.datasources.append(view);
        }
    }
    
    /**
     * 处理客服数据
     */
    private func handleCustomerServiceData(_ tableView: DYTableView) {
        
        tableView.loadDataCallback = {
            (pageIndex, result) in
            
            IMContactsNetwork.getContacts().dy_startRequest(successful: { (response) in
                
                if response is [String : Any] {
                    let array = (response as! [String : Any])["serviceMembers"] as! [[String : Any]];
                    var data: [ContactsModel] = [];
                    for item in array {
                        let model = ContactsModel.deserialize(from: item)!;
                        model.type = 0;
                        data.append(model);
                    }
                    result(data);
                } else {
                    result([]);
                }
            });
        };
    }
    /**
     * 处理好友数据
     */
    private func handleMyFriendData(_ tableView: DYTableView) {
        
        tableView.loadDataCallback = {
            [weak self] (pageIndex, result) in
            
            IMContactsNetwork.getContacts().dy_startRequest(successful: { (response) in
                
                if response is [String : Any] {
                    //邀请我的好友
                    
                    let superior = (response as! [String : Any])["superior"] as! [[String : Any]];
                    var data: [ContactsModel] = [];
                    for item in superior {
                        
                        let model = ContactsModel.deserialize(from: item)!;
                        model.type = 1;
                        data.append(model);
                        
                    }
                    self?.friendsData[0] = data;
                    //                          我邀请的好友
                    let subordinate = (response as! [String : Any])["subordinate"] as! [[String : Any]];
                    var data1: [ContactsModel] = [];
                    for item in subordinate {
                        
                        let model = ContactsModel.deserialize(from: item)!;
                        model.type = 1;
                        data1.append(model);
                        
                    }
                    self?.friendsData[1] = data1;
                    if superior.count == 0 && subordinate.count == 0 {
                        self?.datasources[1].isShowNoData = true;
                    }
                    result([]);
                } else {
                    result([]);
                }
            });
        };
        
    }
    /**
     * 处理群组数据
     */
    private func handleMyGroupData(_ tableView: DYTableView) {
        
        tableView.loadDataCallback = {
            (pageIndex, result) in
            IMMessageNetwork.getMyGroupList(Int(pageIndex), pageSize: 100).dy_startRequest(successful: { (response) in
                
                if response is [String : Any] {
                    
                    var array: [IMGroupInfoModel] = [];
                    let newResponse = response as! [String : Any]
                    for item in newResponse["records"] as! [[String : Any]] {
                        
                        let model = IMGroupInfoModel.deserialize(from: item);
                        
                        array.append(model!);
                    }
                    result(array);
                } else {
                    result([]);
                }
            });
        };
    
    }
    /**
     * 处理验证消息数据
     */
    private func handleVerificationData(_ tableView: DYTableView) {
        tableView.loadDataCallback = {
            (pageIndex, result) in
            result([]);
        };
    }
    
    /**
     * 处理客服cell点击
     */
    private func handleCustomerServiceCellClick(_ tableView: DYTableView) {
        
        tableView.didSelectedCellModelCallback = {
            [weak self] (model) in
            
            let realModel = model as! ContactsModel;
            var session = IMSessionModule.sharedInstance().getSessionWithSessionId(realModel.chatId ?? "");
            if session.id == nil {
                session = FYContacts.init(propertiesDictionary: realModel.toJSON());
            }
            let vc = ChatViewController.init(conversationType: .conversationType_CUSTOMERSERVICE, targetId: realModel.chatId);
            vc?.hidesBottomBarWhenPushed = true;
            vc?.navigationItem.title = realModel.nick;
            vc?.toContactsModel = session;
            self?.navigationController?.pushViewController(vc!, animated: true);
        };
    }
    /**
     * 处理好友cell点击
     */
    private func handleMyFriendCellClick(_ model: ContactsModel) {

        var session = IMSessionModule.sharedInstance().getSessionWithSessionId(model.chatId ?? "");
        if session.id == nil {
            session = FYContacts.init(propertiesDictionary: model.toJSON());
        }
        let vc = ChatViewController.init(conversationType: .conversationType_PRIVATE, targetId: model.chatId);
        vc?.navigationItem.title = model.nick;
        vc?.toContactsModel = session;
        vc?.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc!, animated: true);
        
    }
    /**
     * 处理群组cell点击
     */
    private func handleMyGroupCellClick(_ tableView: DYTableView) {
    
        tableView.didSelectedCellModelCallback = {
            [weak self] (model) in
            
            let realModel = model as! IMGroupInfoModel;
            let vc = ChatViewController.init(conversationType: .conversationType_GROUP, targetId: String(realModel.id ?? 0));
            vc?.navigationItem.title = realModel.chatgName;
            vc?.hidesBottomBarWhenPushed = true;
            self?.navigationController?.pushViewController(vc!, animated: true);
        };
        
    }
    /**
     * 处理验证消息cell点击
     */
    private func handleVerificationCellClick(_ tableView: DYTableView) {
        tableView.didSelectedCellModelCallback = {
            [weak self] (model) in
            
            
        };
    }
    private func initialHeaderView () {
        
        self.view.addSubview(self.headerView);
        self.headerView.mas_makeConstraints { (make) in
            make?.left.right()?.top()?.offset()(0);
            make?.height.offset()(72);
        }
        let array: [[String: String]] = [
            ["title": "在线客服", "icon": "msg-operation"],
            ["title": "我的好友", "icon": "msg-friends"],
            ["title": "我的群组", "icon": "msg-group"],
            ["title": "验证消息", "icon": "msg-all"],
        ];
        
        for (index,item) in array.enumerated() {
            let subview = SessionHeaderSubView.init(item["icon"]!, title: item["title"]!);
            subview.tag = index;
            let width = self.view.frame.width / CGFloat(array.count);
            self.headerView.addSubview(subview);
            subview.frame = CGRect.init(x: CGFloat(index) * width, y: 0, width: width, height: 72);
            subview.circleView.isHidden = true;
            subview.addTarget(self, selector: #selector(btnClick(_:)));
            if index == 0 {
                subview.btn.isSelected = true;
                self.lastSelected = subview;
            }
        }
    }
    
    @objc
    private func btnClick(_ sender: UITapGestureRecognizer) {
        
        let subview = sender.view as! SessionHeaderSubView;
        if subview.btn.isSelected {
            return;
        }
        self.lastSelected?.btn.isSelected = false;
        subview.btn.isSelected = true;
        self.lastSelected = subview;
        let tableView = self.datasources[subview.tag];
        tableView.loadData();
        self.collectionView.scrollToItem(at: IndexPath.init(item: subview.tag, section: 0), at: .centeredHorizontally, animated: false);
        
    }
    
    
    private var lastSelected: SessionHeaderSubView?

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init();
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = .horizontal;
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: layout);
        view.showsHorizontalScrollIndicator = false;
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell");
        view.dataSource = self;
        view.delegate = self;
        view.backgroundColor = UIColor.groupTableViewBackground;
        view.isScrollEnabled = false;
        view.isPagingEnabled = true;
        return view;
        
    }()
    
    lazy var unreadView: DYUnreadView = {
        
        return DYUnreadView.init();
    }()
    
    
    lazy var headerView: UIView = {
        
        let view = UIView.init();
        
        view.backgroundColor = UIColor.white;
        
        return view;
        
    }()
    private var datasources: [DYTableView] = [];
    
    private lazy var menuView: FYMenu = {
        let data: [[String : Any]] = [
            ["icon":"nav_recharge","title":"快速充值","class": "Recharge2ViewController"],
            ["icon":"nav_agent","title":"代理中心","class": "AgentCenterViewController"],
            ["icon":"nav_help","title":"帮助中心","class": "HelpCenterWebController"],
            ["icon":"nav_redp_play","title":"玩法规则","class": "WebViewController"],
            ["icon":"nav_createGroupIcon","title":"创建群组","class": "CreateGroupChatController"],
        ]
        var array: [FYMenuItem] = [];
        for item in data {
            let clsStr = item["class"] as! String;
            let cls = NSClassFromString(clsStr) as! UIViewController.Type;
            let menuItem = FYMenuItem.init(image: UIImage.init(named: item["icon"] as! String), title: item["title"] as! String, action: { [weak self] (item) in
         
                let vc = cls.init();
                vc.hidesBottomBarWhenPushed = true;
                self!.navigationController?.pushViewController(vc, animated: true);
            });
            array.append(menuItem);
        }
      
        let menu = FYMenu.init(items: array);
        menu.menuCornerRadiu = 5.0;
        menu.showShadow = true;
        menu.minMenuItemHeight = 35;
        menu.titleColor = UIColor.darkGray;
        menu.menuBackGroundColor = UIColor.white;
        
        return menu;
        
    }();
    
    private var friendsData: [Int : [ContactsModel]] = [:];

}


extension ContactsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasources.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath);
        if cell.contentView.subviews.count == 0{
            let view = self.datasources[indexPath.row];
            cell.addSubview(view);
            view.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview();
                make.left.equalToSuperview().offset(15);
                make.right.equalToSuperview().offset(-15);

            };
        }
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.size;
    }
}


extension ContactsVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.friendsData[section]?.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactsCell;
        cell.model = self.friendsData[indexPath.section]![indexPath.row];
        if indexPath.row == 0 {
            cell.isHiddenRedundantArea = true;
        } else {
            cell.isHiddenRedundantArea = false;
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model  = self.friendsData[indexPath.section]![indexPath.row];
        self.handleMyFriendCellClick(model);
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 64;
        }
        
        return 78;
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return self.friendsData[section]?.count ?? 0 > 0 ? 30 : 0;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel.init();
        label.font = UIFont.systemFont(ofSize: 14);
        
        label.textColor = UIColor.gray;
        
        label.text = section == 0 ? "邀请我的好友" : "我邀请的好友";
        return label;
        
        
        
    }
    
    
}
