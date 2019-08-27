//
//  File.swift
//  Project
//
//  Created by fangyuan on 2019/8/19.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit


@objcMembers class SessionVC: BaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.navigationItem.title = "消息";
        self.setupSubView();
        self.tableView.loadData();
        self.notifications();

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tableView.loadData();
        self.update();
    }
    
   
    
    private func setupSubView () {
        
        self.initialHeaderView();
        self.view.backgroundColor = UIColor.groupTableViewBackground;
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp_bottom);
            make.left.equalToSuperview().offset(15);
            make.right.equalToSuperview().offset(-15);
            make.bottom.equalToSuperview();
        }
        self.tabBarController?.tabBar.addSubview(self.unreadView);
        self.unreadView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10);
            let width = kScreenWidth / CGFloat(self.tabBarController!.tabBar.items!.count);
            make.left.equalToSuperview().offset(width * 0.7);
        });
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "msg-bell"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(lefButtonClick));
        
    
    }
    
    @objc
    private func lefButtonClick() {
        
        let vc = NotificationVC.init();
        vc.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc, animated: true);
        
    }
    
    private func update() {
        self.unreadView.setUnreadNumber(IMSessionModule.sharedInstance().allUnreadMesagges);
        for subView in self.headerView.subviews as! [SessionHeaderSubView] {
            
            let sessions = self.datasources[subView.tag];
            var isHaveMessage = false;
            for session in sessions ?? [] {
                
                if session.unReadMsgCount > 0 {
                    isHaveMessage = true;
                    break;
                }
            }
            subView.circleView.isHidden = isHaveMessage ? false : true;
            
        }
        self.unreadView.setUnreadNumber(IMSessionModule.sharedInstance().allUnreadMesagges);
    }

    
    private func notifications() {
//      收到新消息 addOrDeleteMembers
        NotificationCenter.default.addObserver(self, selector: #selector(onNewMessage), name: .init(rawValue: "kUnreadMessageNumberChange"), object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(onGroupMessage(_:)), name: .init("addOrDeleteMembers"), object: nil);
    }
    /**
     * 收到新消息
     */
    @objc func onNewMessage() {
        DispatchQueue.main.async {
            self.tableView.loadData();
            self.update();
        }
    }
    /**
     * 被加入群或者踢出群
     */
    @objc func onGroupMessage(_ info: Notification) {
        
        DispatchQueue.main.async {
            self.tableView.loadData();
            self.update();
        }
    }
    private func initialHeaderView () {
        
        self.view.addSubview(self.headerView);
        self.headerView.mas_makeConstraints { (make) in
            make?.left.right()?.top()?.offset()(0);
            make?.height.offset()(72);
        }
        let array: [[String: String]] = [
            ["title": "全部消息", "icon": "msg-all"],
            ["title": "我的群组", "icon": "msg-group"],
            ["title": "我的好友", "icon": "msg-friends"],
            ["title": "在线客服", "icon": "msg-operation"]
        ];
        
        for (index,item) in array.enumerated() {
            let subview = SessionHeaderSubView.init(item["icon"]!, title: item["title"]!);
            subview.tag = index;
            let width = self.view.frame.width / CGFloat(array.count);
            self.headerView.addSubview(subview);
            subview.frame = CGRect.init(x: CGFloat(index) * width, y: 0, width: width, height: 72);
          
            subview.addTarget(self, selector: #selector(btnClick(_:)));
            if index == 0 {
                subview.btn.isSelected = true;
                self.lastSelected = subview;
            }
        }
    }
    
    private func handleDeleteCell (_ row: Int) {
        
        let model = self.datasources[self.lastSelected!.tag]![row];
        self.tableView.dy_dataSource.removeObject(at: row);
        for item in self.datasources {
            
            let isContain = item.value.contains { (newModel) -> Bool in
                return newModel.id == model.id;
            }
            if isContain {
                //补集
                if item.value.count > 0 {
                    self.datasources[item.key] = item.value.filter({$0.id != model.id});
                }
            }
        }
        self.tableView.deleteRows(at: [IndexPath.init(row: row, section: 0)], with: .left);
        IMSessionModule.removeSession(model.sessionId);
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
        self.tableView.dy_dataSource = NSMutableArray.init(array: self.datasources[subview.tag] ?? []);
        self.tableView.reloadData();
        
    }
    private func filterData(_ response: [FYContacts]) -> [FYContacts]? {
        self.datasources.removeAll();
        var arrayM:[FYContacts] = [];
        for item in response {
            var arr:[FYContacts]? = self.datasources[Int(item.sessionType.rawValue)];
            if arr == nil {
                arr = [];
            }
            arr?.append(item);
            arrayM.append(item);
            self.datasources[Int(item.sessionType.rawValue)] = arr;
        }
        self.datasources[0] = arrayM;
        return self.datasources[self.lastSelected?.tag ?? 0];
        
    }
    private lazy var tableView: DYTableView = {
        
        let view = DYTableView.init();
        view.separatorColor = UIColor.clear;
        view.tableFooterView = UIView.init();
        view.register(UINib.init(nibName: "IMSessionCell", bundle: nil), forCellReuseIdentifier: "cell");
        view.dataSource = self;
        view.delegate = self;
        view.noDataText = "暂无消息";
        view.noDataImage = "state_empty";
        view.backgroundColor = UIColor.clear;
        view.loadDataCallback = {
            (pageIndex, result) in
            
            let sessions = self.filterData(IMSessionModule.getAllSessions());
            
            result(sessions ?? []);
            
        };
        view.rowHeight = 78;
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
    
    private var datasources: [Int: [FYContacts]] = [:];
    private var cells: [DYTableView] = [];
    private var lastSelected: SessionHeaderSubView?
    
    
    deinit {
        NotificationCenter.default.removeObserver(self);
    }
}

extension SessionVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.dy_dataSource.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IMSessionCell;
        cell.model = (self.tableView.dy_dataSource[indexPath.row] as! FYContacts);
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.tableView.dy_dataSource[indexPath.row] as! FYContacts;
        var vc: ChatViewController?
        if model.sessionType == .conversationType_GROUP {
            vc = ChatViewController.init(conversationType: model.sessionType, targetId: model.sessionId);
            vc?.title = model.name;
        } else if model.sessionType == .conversationType_PRIVATE {
            vc = ChatViewController.privateChat(withModel: model);
            vc?.toContactsModel = model;
        }
        vc?.hidesBottomBarWhenPushed = true;
        self.navigationController?.pushViewController(vc!, animated: true);
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true;
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.handleDeleteCell(indexPath.row);
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除";
    }
    

}

extension SessionVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.headerView.subviews.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath);
        if cell.contentView.subviews.count == 0 {
            let subview = self.cells[indexPath.row];
            cell.contentView.addSubview(subview);
            subview.snp.makeConstraints { (make) in
                make.edges.equalToSuperview();
            }
            
        }
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.size;
    }
    
    
    
}

class SessionHeaderSubView: UIView {
    
    
    required init(_ imgStr: String, title: String) {
        super.init(frame: .zero);
       
        self.addSubview(self.btn);
        self.addSubview(self.circleView);
        self.btn.mas_makeConstraints { (make) in
            make?.edges.offset()(0);
        }
        self.circleView.mas_makeConstraints { (make) in
            make?.right.bottom()?.equalTo()((self.btn.imageView))?.offset()(2.5);
            make?.size.offset()(9);
        }
        self.btn.setTitle(title, for: .normal);
        self.btn.setImage(UIImage.init(named: imgStr), for: .normal);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var circleView: UIView = {
        
        let view = UIView.init();
        view.addRounded(radius: 4.5);
        view.backgroundColor = UIColor.HWColorWithHexString(hex: "#ffdc19");
        return view;
        
    }()
    
    lazy var btn: DYButton = {
        
        let btn = DYButton.init(type: .custom);
        btn.direction = 1;
        btn.setTitleColor(UIColor.HWColorWithHexString(hex: "#6d6c6e"), for: .normal);
        btn.setTitleColor(UIColor.HWColorWithHexString(hex: "#fe3962"), for: .selected);
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11);
        btn.margin = 10;
        btn.isUserInteractionEnabled = false;
        return btn;
        
    }()
}
