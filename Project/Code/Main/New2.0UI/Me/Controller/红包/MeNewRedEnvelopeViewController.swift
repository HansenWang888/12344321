//
//  MeNewRedEnvelopeViewController.swift
//  ProjectXZHB
//
//  Created by 汤姆 on 2019/8/21.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import JXSegmentedView
import ReusableKit
fileprivate enum Reusable {
    static let cell = ReusableCell<MeNewRedEnvelopeCell>()
}
///cell高度
fileprivate let cellH = 100.px
fileprivate let cellW = (kScreenWidth - 20) / 4 - 1
class MeNewRedEnvelopeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
       
    }
    
    private lazy var collectionView: UICollectionView = {
        let colle = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colle.register(Reusable.cell)
        colle.backgroundColor = UIColor.white
        colle.showsVerticalScrollIndicator = false
        colle.showsHorizontalScrollIndicator = false
        colle.delegate = self
        colle.dataSource = self
        return colle
    }()
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let lay = UICollectionViewFlowLayout()
        lay.minimumLineSpacing = 0
        lay.minimumInteritemSpacing = 0
        return lay
    }()
    var dataSource = [HaderWavesIconModel]()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.kCornerRad(rectCorner: [.bottomLeft,.bottomRight], cornerRad: 10)
    }
  
}

extension MeNewRedEnvelopeViewController{
    func initUI() {
        let model1 = HaderWavesIconModel(icon: "saoleiIcon", title: "扫雷明细", content: "")
        let model2 = HaderWavesIconModel(icon: "niuniuIcon", title: "牛牛明细", content: "")
        let model3 = HaderWavesIconModel(icon: "jinqiangIcon", title: "禁抢明细", content: "")
        let model4 = HaderWavesIconModel(icon: "fuliIcon", title: "福利明细", content: "")
        let model5 = HaderWavesIconModel(icon: "qianzhuangnnIcon", title: "抢庄牛牛明细", content: "")
        let model6 = HaderWavesIconModel(icon: "erbaIcon", title: "二八杠明细", content: "")
        let model7 = HaderWavesIconModel(icon: "jielongmxIcon", title: "接龙明细", content: "")
        dataSource.append(model1)
        dataSource.append(model2)
        dataSource.append(model3)
        dataSource.append(model4)
        dataSource.append(model5)
        dataSource.append(model6)
        dataSource.append(model7)
        view.addSubview(collectionView)
       let row : Int = (dataSource.count % 4) > 0 ? 1 : 0
        collectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview()
            make.height.equalTo(cellH * CGFloat(abs(dataSource.count / 4) + row))
        }
     
    }
}
//MARK: - 代理
extension MeNewRedEnvelopeViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(Reusable.cell, for: indexPath)
        if dataSource.count > indexPath.row{
            cell.model = dataSource[indexPath.row]
            cell.lineView.isHidden = ((indexPath.row + 1) % 4 == 0)
        }
        return cell
    }
    
    
}
extension MeNewRedEnvelopeViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellW, height: cellH)
    }
}
extension MeNewRedEnvelopeViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        kLog(model.title)
    }
}
extension MeNewRedEnvelopeViewController:JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return view
    }
}
