//
//  FCProcess.swift
//  FlowChartKit
//
//  Created by QiangRen on 10/26/15.
//  Copyright (c) 2015 QiangRen. All rights reserved.
//

import CoreGraphics
import Foundation
import UIKit

public enum FCProcessStyle: String {
    case Terminal = "terminal"
    
    case Process = "process"
    case Decision = "decision"
    case Preparation = "preparation"
    
    case Input = "input"
    case Output = "output"

    //
    case StartEvent = "startEvent"
    case EndEvent = "endEvent"
    case IntermediateEvent = "intermediateEvent"
    case Task = "task"
    case InclusiveGateway = "inclusiveGateway"
    case ExclusiveGateway = "exclusiveGateway"
    case ParallelGateway = "parallelGateway"
    case ComplexGateway = "complexGateway"
}

public class FCProcess: NSObject, FCShape {

    var processStyle: FCProcessStyle

    public var id: String
    public var type: FCShapeType
    public var rect: CGRect
    public var title: String!
    public var highlighted: Bool = false

    public init(style: FCProcessStyle, frame: CGRect, title: String? = nil) {
        self.id = NSUUID().UUIDString

        self.processStyle = style
        switch style {
        case .StartEvent, .EndEvent, .IntermediateEvent:
            self.type = .Circle
        case .Terminal:
            self.type = .Oval
        case .Process, .Task:
            self.type = .Square
        case .Decision:
            self.type = .Diamond
        case .Preparation:
            self.type = .Hexagon
        case .Input, .Output:
            self.type = .Quadangle
        case .InclusiveGateway, .ExclusiveGateway, .ParallelGateway, .ComplexGateway:
            self.type = .Diamond
        default:
            self.type = .Square
        }
        self.rect = frame
        self.title = title
    }

}

extension FCProcess {
    
    public override func isEqual(object: AnyObject?) -> Bool {
        if let process = object as? FCProcess {
            return process.id == self.id
        }
        return super.isEqual(object)
    }
    
}

extension FCProcess {
    
    public func draw(view: UIView, style: FCShapeStyle) {
        switch processStyle {
        case .InclusiveGateway:
            drawInclusiveGateway(view, style: style)
        case .ExclusiveGateway:
            drawExclusiveGateway(view, style: style)
        case .ParallelGateway:
            drawParallelGateway(view, style: style)
        case .ComplexGateway:
            drawComplexGateway(view, style: style)
        default:
            break
        }
    }

    func drawInclusiveGateway(view: UIView, style: FCShapeStyle) {
        let rect = view.bounds.rectByInsetting(dx: 0.3 * view.bounds.width, dy: 0.3 * view.bounds.height)
        
        var path = CGPathCreateMutable()
        
        CGPathAddEllipseInRect(path, nil, rect)
        
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.path = path
        
        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = 3.0
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = style.borderColor
        
        view.layer.addSublayer(layer)
    }

    func drawExclusiveGateway(view: UIView, style: FCShapeStyle) {
        let rect = view.bounds.rectByInsetting(dx: 0.3 * view.bounds.width, dy: 0.3 * view.bounds.height)

        let center = CGPointMake(view.bounds.width / 2, view.bounds.height / 2)

        var path = CGPathCreateMutable()

        let points = [
            center,
            CGPointMake(rect.minX, rect.minY),
            CGPointMake(rect.maxX, rect.maxY),
            center,
            CGPointMake(rect.minX, rect.maxY),
            CGPointMake(rect.maxX, rect.minY),
            center
        ]
        CGPathAddLines(path, nil, points, points.count)
        CGPathCloseSubpath(path)

        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.path = path

        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = 3.0
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = style.borderColor
        
        view.layer.addSublayer(layer)
    }

    func drawParallelGateway(view: UIView, style: FCShapeStyle) {
        let width = view.frame.width
        let height = view.frame.height
        let centerX = width / 2
        let centerY = height / 2
        let center = CGPointMake(centerX, centerY)
        
        var path = CGPathCreateMutable()
        
        let points = [
            center,
            CGPointMake(width / 4, height / 2),
            CGPointMake(width * 3 / 4, height / 2),
            center,
            CGPointMake(width / 2, height / 4),
            CGPointMake(width / 2, height * 3 / 4),
            center
        ]
        CGPathAddLines(path, nil, points, points.count)
        CGPathCloseSubpath(path)
        
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.path = path
        
        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = 3.0
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = style.borderColor
        
        view.layer.addSublayer(layer)
    }

    func drawComplexGateway(view: UIView, style: FCShapeStyle) {
        let rect = view.bounds.rectByInsetting(dx: 0.3 * view.bounds.width, dy: 0.3 * view.bounds.height)

        let width = view.frame.width
        let height = view.frame.height
        let centerX = width / 2
        let centerY = height / 2
        let center = CGPointMake(centerX, centerY)
        
        var path = CGPathCreateMutable()
        
        let points = [
            center,
            CGPointMake(width / 4, height / 2),
            CGPointMake(width * 3 / 4, height / 2),
            center,
            CGPointMake(width / 2, height / 4),
            CGPointMake(width / 2, height * 3 / 4),
            center,
            CGPointMake(rect.minX, rect.minY),
            CGPointMake(rect.maxX, rect.maxY),
            center,
            CGPointMake(rect.minX, rect.maxY),
            CGPointMake(rect.maxX, rect.minY),
            center
        ]
        CGPathAddLines(path, nil, points, points.count)
        CGPathCloseSubpath(path)
        
        let layer = CAShapeLayer()
        layer.frame = view.bounds
        layer.path = path
        
        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = 3.0
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = style.borderColor
        
        view.layer.addSublayer(layer)
    }

}

extension FCProcess {
    
    public var top: FCShapePoint {
        get {
            return FCShapePoint(type: .Top, shape: self)
        }
    }

    public var left: FCShapePoint {
        get {
            return FCShapePoint(type: .Left, shape: self)
        }
    }

    public var right: FCShapePoint {
        get {
            return FCShapePoint(type: .Right, shape: self)
        }
    }

    public var bottom: FCShapePoint {
        get {
            return FCShapePoint(type: .Bottom, shape: self)
        }
    }

}

// MARK: -
enum FCShapePointType {
    case Top
    case Left
    case Right
    case Bottom
}

public struct FCShapePoint {
    var type: FCShapePointType
    var shape: FCShape!
    var point: CGPoint {
        get {
            let minX = shape.rect.minX
            let maxX = shape.rect.maxX

            let minY = shape.rect.minY
            let maxY = shape.rect.maxY
            
            let width = shape.rect.width
            let height = shape.rect.height
            
            switch type {
            case .Top:
                return CGPointMake(minX + width / 2, minY)
            case .Left:
                return CGPointMake(minX, minY + height / 2)
            case .Right:
                return CGPointMake(maxX, minY + height / 2)
            case .Bottom:
                return CGPointMake(minX + width / 2, maxY)
            }
        }
    }

    public func connectTo(end: FCShapePoint) -> FCConnection! {
        //
        if self.type == .Right && end.type == .Left {
            return FCShapePoint.connectRightToLeft(self, e: end)
        }
        else if self.type == .Right && end.type == .Top {
            return FCShapePoint.connectRightToTop(self, e: end)
        }
        else if self.type == .Left && end.type == .Right {
            return FCShapePoint.connectLeftToRight(self, e: end)
        }
        else if self.type == .Left && end.type == .Top {
            return FCShapePoint.connectLeftToTop(self, e: end)
        }
        else if self.type == .Bottom && end.type == .Top {
            return FCShapePoint.connectBottomToTop(self, e: end)
        }
        else if self.type == .Bottom && end.type == .Left {
            return FCShapePoint.connectBottomToLeft(self, e: end)
        }
        else if self.type == .Bottom && end.type == .Right {
            return FCShapePoint.connectBottomToRight(self, e: end)
        }
        else {
            return FCConnection(style: .SequenceFlow, points: [self.point, end.point])
        }
    }

    private static func connectBottomToTop(s: FCShapePoint, e: FCShapePoint) -> FCConnection {
        let midY = s.point.y + (e.point.y - s.point.y) / 2
        
        let points = [
            s.point,
            CGPointMake(s.point.x, midY),
            CGPointMake(e.point.x, midY),
            e.point
        ]
        
        return FCConnection(style: .SequenceFlow, points: points)
    }
    
    private static func connectRightToLeft(s: FCShapePoint, e: FCShapePoint) -> FCConnection {
        let midX = s.point.x + (e.point.x - s.point.x) / 2
        
        let points = [
            s.point,
            CGPointMake(midX, s.point.y),
            CGPointMake(midX, e.point.y),
            e.point
        ]
        
        return FCConnection(style: .SequenceFlow, points: points)
    }

    private static func connectRightToTop(s: FCShapePoint, e: FCShapePoint) -> FCConnection {
        let points = [
            s.point,
            CGPointMake(e.point.x, s.point.y),
            e.point
        ]
        
        return FCConnection(style: .SequenceFlow, points: points)
    }

    private static func connectLeftToRight(s: FCShapePoint, e: FCShapePoint) -> FCConnection {
        let midX = e.point.x + (s.point.x - e.point.x) / 2
        
        let points = [
            s.point,
            CGPointMake(midX, s.point.y),
            CGPointMake(midX, e.point.y),
            e.point
        ]
        
        return FCConnection(style: .SequenceFlow, points: points)
    }
    
    private static func connectLeftToTop(s: FCShapePoint, e: FCShapePoint) -> FCConnection {
        let points = [
            s.point,
            CGPointMake(e.point.x, s.point.y),
            e.point
        ]
        
        return FCConnection(style: .SequenceFlow, points: points)
    }

    private static func connectBottomToLeft(s: FCShapePoint, e: FCShapePoint) -> FCConnection {
        let points = [
            s.point,
            CGPointMake(s.point.x, e.point.y),
            e.point
        ]
        
        return FCConnection(style: .SequenceFlow, points: points)
    }
    
    private static func connectBottomToRight(s: FCShapePoint, e: FCShapePoint) -> FCConnection {
        let points = [
            s.point,
            CGPointMake(s.point.x, e.point.y),
            e.point
        ]
        
        return FCConnection(style: .SequenceFlow, points: points)
    }
    
}
