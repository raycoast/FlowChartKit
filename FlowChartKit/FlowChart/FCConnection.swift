//
//  FCConnection.swift
//  FlowChartKit
//
//  Created by QiangRen on 10/26/15.
//  Copyright (c) 2015 QiangRen. All rights reserved.
//

import CoreGraphics
import Foundation

public enum FCConnectionStyle: String {
    case SequenceFlow = "sequenceFlow"
    case MessageFlow = "messageFlow"
    case Association = "association"
}

public class FCConnection: NSObject, FCFlow {
    
    var id: String
    public var text: String!
    var connectionStyle: FCConnectionStyle
    public var type: FCFlowType
    public var points: [CGPoint]
    
    public var highlighted: Bool = false

    public init(style: FCConnectionStyle = .SequenceFlow, points: [CGPoint], text: String? = nil) {
        self.id = NSUUID().UUIDString
        self.connectionStyle = style
        switch style {
        case .SequenceFlow:
            self.type = .ArrowLine
        case .Association:
            self.type = .DotLine
        case .MessageFlow:
            self.type = .Custom
        default:
            self.type = .Line
        }
        self.points = points
        self.text = text
    }

    public func withStyle(style: FCConnectionStyle) -> FCConnection {
        self.connectionStyle = style
        switch style {
        case .SequenceFlow:
            self.type = .ArrowLine
        case .Association:
            self.type = .DotLine
        case .MessageFlow:
            self.type = .Custom
        default:
            self.type = .Line
        }
        return self
    }
    
    public func withHighlight(flag: Bool = true) -> FCConnection {
        self.highlighted = true
        return self
    }

    public func withText(text: String) -> FCConnection {
        self.text = text
        return self
    }
    
}

extension FCConnection {

    override public func isEqual(object: AnyObject?) -> Bool {
        if let flow = object as? FCConnection {
            return flow.id == self.id
        }
        return super.isEqual(object)
    }

}

extension FCConnection {
    
    public func drawText(text: String, style: FCFlowStyle) {
    }
    
    public func draw(view: UIView, style: FCFlowStyle) {
        switch self.connectionStyle {
        case .MessageFlow:
            drawMessageFlow(view, style: style)
        default:
            break
        }
    }
    
    public func drawMessageFlow(view: UIView, style: FCFlowStyle) {
        
        if points.count < 2 {
            
        }
        else if points.count == 2 {
            var transform = self.transform(points[0], endPoint: points[1])

            // Draw Diamond Start
            var diamondPath = CGPathCreateMutable()
            let diamondPoints = [CGPointMake(Diamond.Length, 0), CGPointMake(Diamond.Length / 2, -Diamond.Width / 2), CGPointMake(0, 0), CGPointMake(Diamond.Length / 2, Diamond.Width / 2), CGPointMake(Diamond.Length, 0)]
            CGPathAddLines(diamondPath, &transform, diamondPoints, diamondPoints.count)
            CGPathCloseSubpath(diamondPath)
            
            let diamondLayer = CAShapeLayer()
            diamondLayer.frame = view.bounds //CGRectMake(0, 0, length, length)
            diamondLayer.path = diamondPath
            
            diamondLayer.lineCap = "kCGLineCapRound"
            diamondLayer.lineWidth = style.lineWidth
            diamondLayer.fillColor = UIColor.clearColor().CGColor
            diamondLayer.strokeColor = style.lineColor
            
//            view.layer.addSublayer(diamondLayer)
            // Draw Diamond End
            
            // Draw Line Start
            let length = hypot(points[1].x - points[0].x, points[1].y - points[0].y)
            
            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, &transform, Diamond.Length, 0)
            CGPathAddLineToPoint(path, &transform, length - Arraw.Length, 0)
            
//            let startPoint = CGPathGetCurrentPoint(path)
//            let endPoint = points.last!
            
            // Draw Line End
            
            // Draw Arraw Start
            let arrawPoints = [CGPointMake(length - Arraw.Length, Arraw.Width / 2), CGPointMake(length, 0), CGPointMake(length - Arraw.Length, -Arraw.Width / 2)]
            var arrawPath = CGPathCreateMutable()
            CGPathAddLines(arrawPath, &transform, arrawPoints, arrawPoints.count)
            CGPathCloseSubpath(arrawPath)
            
            let arrawLayer = CAShapeLayer()
            arrawLayer.frame = view.bounds //CGRectMake(0, 0, length, length)
            arrawLayer.path = arrawPath
            
            arrawLayer.lineCap = "kCGLineCapRound"
            arrawLayer.lineWidth = style.lineWidth
            arrawLayer.fillColor = UIColor.clearColor().CGColor
            arrawLayer.strokeColor = style.lineColor
            
//            view.layer.addSublayer(arrawLayer)
            // Draw Arraw End
            
            let layer = CAShapeLayer()
            layer.frame = view.bounds //CGRectMake(0, 0, length, length)
            layer.path = path
            
            layer.lineCap = "kCGLineCapRound"
            layer.lineWidth = style.lineWidth
            layer.lineDashPattern = [style.lineWidth, 3*style.lineWidth]
            layer.fillColor = UIColor.clearColor().CGColor
            layer.strokeColor = style.lineColor
            
            layer.addSublayer(diamondLayer)
            layer.addSublayer(arrawLayer)
            view.layer.addSublayer(layer)
        }
        else {
            // Draw Diamond Start
            var diamondTransform = transform(points[0], endPoint: points[1])
            var diamondPath = CGPathCreateMutable()
            let diamondPoints = [CGPointMake(Diamond.Length, 0), CGPointMake(Diamond.Length / 2, -Diamond.Width / 2), CGPointMake(0, 0), CGPointMake(Diamond.Length / 2, Diamond.Width / 2), CGPointMake(Diamond.Length, 0)]
            CGPathAddLines(diamondPath, &diamondTransform, diamondPoints, diamondPoints.count)
            CGPathCloseSubpath(diamondPath)
            
            let diamondLayer = CAShapeLayer()
            diamondLayer.frame = view.bounds //CGRectMake(0, 0, length, length)
            diamondLayer.path = diamondPath
            
            diamondLayer.lineCap = "kCGLineCapRound"
            diamondLayer.lineWidth = style.lineWidth
            diamondLayer.fillColor = UIColor.clearColor().CGColor
            diamondLayer.strokeColor = style.lineColor
            
//            view.layer.addSublayer(diamondLayer)
            // Draw Diamond End

            // Draw Line Start
            let length = hypot(points[1].x - points[0].x, points[1].y - points[0].y)

            var path = CGPathCreateMutable()
            CGPathMoveToPoint(path, &diamondTransform, Diamond.Length, 0)
            CGPathAddLineToPoint(path, &diamondTransform, self.length(points[0], endPoint: points[1]), 0)
            for i in 1..<points.count - 1 {
                let s = points[i]
                let e = points[i+1]
                CGPathAddArcToPoint(path, nil, s.x, s.y, e.x, e.y, style.lineRadius)
            }

            let startPoint = CGPathGetCurrentPoint(path)
            let endPoint = points.last!
            var arrawTransform = transform(startPoint, endPoint: endPoint)
            
            CGPathAddLineToPoint(path, &arrawTransform, self.length(startPoint, endPoint: endPoint) - Arraw.Length, 0)
            // Draw Line End

            // Draw Arraw Start
            let arrawPoints = [CGPointMake(length - Arraw.Length, Arraw.Width / 2), CGPointMake(length, 0), CGPointMake(length - Arraw.Length, -Arraw.Width / 2)]
            var arrawPath = CGPathCreateMutable()
            CGPathAddLines(arrawPath, &arrawTransform, arrawPoints, arrawPoints.count)
            CGPathCloseSubpath(arrawPath)

            let arrawLayer = CAShapeLayer()
            arrawLayer.frame = view.bounds //CGRectMake(0, 0, length, length)
            arrawLayer.path = arrawPath
            
            arrawLayer.lineCap = "kCGLineCapRound"
            arrawLayer.lineWidth = style.lineWidth
            arrawLayer.fillColor = UIColor.clearColor().CGColor
            arrawLayer.strokeColor = style.lineColor
            
//            view.layer.addSublayer(arrawLayer)
            // Draw Arraw End

            let layer = CAShapeLayer()
            layer.frame = view.bounds //CGRectMake(0, 0, length, length)
            layer.path = path
            
            layer.lineCap = "kCGLineCapRound"
            layer.lineWidth = style.lineWidth
            layer.lineDashPattern = [style.lineWidth, 3*style.lineWidth]
            layer.fillColor = UIColor.clearColor().CGColor
            layer.strokeColor = style.lineColor
            
            layer.addSublayer(diamondLayer)
            layer.addSublayer(arrawLayer)
            view.layer.addSublayer(layer)
        }

    }

    struct Arraw {
        static let Length: CGFloat = 9.0
        static let Width: CGFloat = 5.0
    }

    struct Diamond {
        static let Length: CGFloat = 10.0
        static let Width: CGFloat = 10.0
    }

    func length(startPoint: CGPoint, endPoint: CGPoint) -> CGFloat {
        return hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
    }
    
    func transform(startPoint: CGPoint, endPoint: CGPoint) -> CGAffineTransform {
        let length = hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
//        let width = max(endPoint.x - startPoint.x, 1)
//        let height = max(endPoint.y - startPoint.y, 1)
        
        let cosine = (endPoint.x - startPoint.x) / length
        let sine = (endPoint.y - startPoint.y) / length
        return CGAffineTransformMake(cosine, sine, -sine, cosine, startPoint.x, startPoint.y)
    }

}
