//
//  ViewController.swift
//  TestFlowChart
//
//  Created by QiangRen on 10/31/15.
//  Copyright (c) 2015 QiangRen. All rights reserved.
//

import UIKit
import FlowChartKit

class ViewController: UIViewController {

    @IBOutlet weak var chartView: FlowChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let a0 = FCProcess(style: .StartEvent, frame: CGRectMake(280, 50, 60, 60))
        let a1 = FCProcess(style: .InclusiveGateway, frame: CGRectMake(270, 140, 80, 80))
        a1.highlighted = true

        let a2 = FCProcess(style: .Task, frame: CGRectMake(235, 300, 150, 100), title: "")
        
        let a3 = FCProcess(style: .Task, frame: CGRectMake(70, 440, 150, 100), title: "Square 1")
        let a4 = FCProcess(style: .Task, frame: CGRectMake(400, 440, 150, 100), title: "Square 2")
        
        let a5 = FCProcess(style: .ComplexGateway, frame: CGRectMake(270, 540, 80, 80))
        let a6 = FCProcess(style: .EndEvent, frame: CGRectMake(280, 680, 60, 60))
        chartView?.addShapes([a0, a1, a2, a3, a4, a5, a6])

        let l1 = FCConnection(points: [CGPointMake(310, 110), CGPointMake(310, 140)]).withHighlight()
        let l2 = a1.bottom.connectTo(a2.top).withStyle(.Association)
        let l3 = a2.left.connectTo(a3.top).withStyle(.MessageFlow)
        let l4 = a2.right.connectTo(a4.top).withText("测试")
        let l5 = a3.bottom.connectTo(a5.left)
        let l6 = a4.bottom.connectTo(a5.right)
        let l7 = FCConnection(style: .MessageFlow, points: [CGPointMake(310, 620), CGPointMake(310, 680)])
        chartView?.addFlows([l1, l2, l3, l4, l5, l6, l7])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

