//
//  ViewController.swift
//  MoyaMangagerDemo
//
//  Created by Sam Chiang on 2020/4/21.
//  Copyright © 2020 Sam Chiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NetManager.shareInstance.request(api: TestApi.hotMovies(start: 0, count: 1), success: { (model, message, responseStr) in
            debugPrint(responseStr)
        }, failure: nil)
    }


}

