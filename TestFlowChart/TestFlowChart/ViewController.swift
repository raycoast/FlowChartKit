//
//  ViewController.swift
//  TestFlowChart
//
//  Created by QiangRen on 10/30/15.
//  Copyright (c) 2015 QiangRen. All rights reserved.
//

import UIKit
import FlowChartKit

class ViewController: UIViewController {

    @IBOutlet weak var chartView: FlowChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        @IBOutlet weak var chartView: FlowChartView!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

