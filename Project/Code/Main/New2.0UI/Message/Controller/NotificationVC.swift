//
//  NotificationVC.swift
//  ProjectCSHB
//
//  Created by fangyuan on 2019/8/23.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit

class NotificationVC: BaseVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "系统公告";
        self.setupSubview();
        // Do any additional setup after loading the view.
    }
    
    private func setupSubview() {
        self.view.backgroundColor = .groupTableViewBackground;
        self.view.addSubview(self.headerView);
        self.headerView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview();
            make.height.equalTo(55);
        };
        
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(0);
            make.left.equalToSuperview().offset(15);
            make.right.equalToSuperview().offset(-15);
            make.bottom.equalToSuperview();
            
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "msg-operation-1"), style: .plain, target: self, action: #selector(rightBtnClick));
        self.tableView.loadData();
        self.headerView.selectIndexBlock = {
            [weak self] (pageIndex) in
            
            self?.tableView.loadData();
        };
        
    }
    
    private func handleCellDeleted(_ index: Int) {
        
        self.dataDict[self.headerView.currSelectIndex]?.remove(at: index);
        
    }
    
    @objc
    private func rightBtnClick() {
        
        
    }
    
    lazy var tableView: DYTableView = {
        
        let view = DYTableView.init();
        view.separatorColor = UIColor.clear;
        view.tableFooterView = UIView.init();
        view.dataSource = self;
        view.delegate = self;
        view.register(UINib.init(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "cell");
        view.noDataText = "暂无数据";
        view.noDataImage = "state_empty";
        view.backgroundColor = UIColor.clear;
        view.loadDataCallback = {
            [weak self] (pageIndex, result) in
            
            result(self!.dataDict[self!.headerView.currSelectIndex] ?? []);
            //            IMMessageNetwork.getMessageList(Int(pageIndex), pageSize: 100).dy_startRequest(successful: { (response) in
            //                if response is [String : Any] {
            //
            //                    let arrayResponse: [[String : Any]] = (response as! [String : Any])["records"] as? [[String : Any]] ?? [];
            //
            //                    result(NSArray.init(array: self.filterData(arrayResponse) ?? []) as! [Any]);
            //                } else {
            //                    result([]);
            //                }
            //
            //            });
            
        };
        
        return view;
        
        
    }()
    lazy var dataDict: [Int: [NotificationCellModel]] = {
        
        let data = [["title":"小猪运营升级公告","content":"小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.","time":"2089-12-34"],
        ["title":"小猪运营升级公告","content":"小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.","time":"2089-12-34"],
        ["title":"小猪运营升级公告","content":"小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.","time":"2089-12-34"],
        ["title":"小猪运营升级公告","content":"小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.","time":"2089-12-34"],
        ["title":"小猪运营升级公告","content":"小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.","time":"2089-12-34"],
        ["title":"小猪运营升级公告","content":"小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.小猪运营升级公告.","time":"2089-12-34"]];
        
        var ddd: [Int: [NotificationCellModel]] = [:];
        var array1: [NotificationCellModel] = []
        var array2: [NotificationCellModel] = []

        for item in data {
            let model = NotificationCellModel.deserialize(from: item);
            let model2 = NotificationCellModel.deserialize(from: item);

            array1.append(model!);
            array2.append(model2!);
        }
        ddd[0] = array1;
        ddd[1] = array2;
        return ddd;
    }();
    
    lazy var headerView: DYSliderHeadView = {
        
        let view = DYSliderHeadView.init(titles: ["系统消息","平台公告"]);
        view.font = UIFont.systemFont(ofSize: 17);
        view.selectColor = UIColor.HWColorWithHexString(hex:"fe3962");
        view.textColor = UIColor.HWColorWithHexString(hex: "#6d6c6e");
        view.type = DYSliderHeaderType.banScroll;
        return view;
        
    }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableView.dy_dataSource.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationCell;
        cell.model = (self.tableView.dy_dataSource[indexPath.row] as! NotificationCellModel);
        return cell;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.tableView.dy_dataSource[indexPath.row] as! NotificationCellModel;
        model.isRead = true;
        model.isStretch = !model.isStretch;
        tableView.reloadRows(at: [indexPath], with: .middle);
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let model = self.tableView.dy_dataSource[indexPath.row] as! NotificationCellModel;
        var height = self.tableView.heightCache[indexPath.row];
        if height == nil {
            height = model.calculateCellheight();
            self.tableView.heightCache[indexPath.row] = height;
        }
      
        return height as! CGFloat;
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let model = self.tableView.dy_dataSource[indexPath.row] as! NotificationCellModel;
        if model.isStretch {
            return false;
        }
        return true;
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            self.tableView.dy_dataSource.removeObject(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: .automatic);
            self.handleCellDeleted(indexPath.row);
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除";
    }
    
    
}
