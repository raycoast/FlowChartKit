//
//  FCShape.swift
//  FlowChartKit
//
//  Created by QiangRen on 11/1/15.
//  Copyright (c) 2015 QiangRen. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

public enum FCShapeType {
    case Circle
    case Oval      // Terminal
    case Ellipse
    case Square    // Process
    case Diamond   // Decision
    case Quadangle // Input/Output
    case Hexagon   // Preparation
}

public protocol FCShape: NSObjectProtocol {

    var id: String { get }
    var type: FCShapeType { get }
    var rect: CGRect { get }
    var title: String! { get }
    var highlighted: Bool { get }
    
    func draw(view: UIView, style: FCShapeStyle)
    
}
