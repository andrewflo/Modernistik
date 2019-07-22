//
//  ViewController.swift
//  Phoenix
//
//  Created by Anthony Persaud on 6/2/19.
//  Copyright © 2019 Modernistik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func startOperations(_ sender: Any) {
        SleepWorker.enqueue()
        BasicWorker.enqueue(params: ["loop": 25])
    }
}

