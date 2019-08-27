//
//  MeDianZiGamesController.swift
//  Project
//
//  Created by 汤姆 on 2019/8/21.
//  Copyright © 2019 CDJay. All rights reserved.
//

import UIKit
import JXSegmentedView
class MeDianZiGamesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

 

}
extension MeDianZiGamesController:JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return view
    }
}
