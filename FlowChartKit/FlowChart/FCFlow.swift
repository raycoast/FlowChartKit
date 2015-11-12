//
//  FCFlow.swift
//  FlowChartKit
//
//  Created by QiangRen on 11/1/15.
//  Copyright (c) 2015 QiangRen. All rights reserved.
//

import Foundation
import CoreGraphics

public enum FCFlowType {
    case Line
    case ArrowLine
    case DotLine
    case Custom
}

public protocol FCFlow: NSObjectProtocol {
    
    var type: FCFlowType { get }
    var text: String! { get }
    var points: [CGPoint] { get }
    var highlighted: Bool { get }

    func draw(view: UIView, style: FCFlowStyle)

}
