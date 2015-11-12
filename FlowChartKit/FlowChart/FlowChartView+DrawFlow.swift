//
//  FlowChartView+DrawFlow.swift
//  FlowChartKit
//
//  Created by QiangRen on 11/5/15.
//  Copyright (c) 2015 QiangRen. All rights reserved.
//

import UIKit

// MARK: - CoreGraphics Flows
extension FlowChartView {
    
    func drawText(flow: FCFlow, style: FCFlowStyle = FCFlowStyle.normal) {
        var minX = flow.points.first!.x
        var maxX = flow.points.first!.x
        var minY = flow.points.first!.y
        var maxY = flow.points.first!.y
        
        for p in flow.points {
            minX = min(minX, p.x)
            maxX = max(maxX, p.x)
            minY = min(minY, p.y)
            maxY = max(maxY, p.y)
        }
        
        let midX = (minX + maxX) / 2
        let midY = (minY + maxY) / 2
        
        let textLabel = UILabel(frame: CGRectMake(midX, midY, 100, 20))
        textLabel.text = flow.text
        textLabel.sizeToFit()
        textLabel.frame.origin.y -= textLabel.frame.height
        contentView.addSubview(textLabel)
    }
    
    func drawFlow(flow: FCFlow, style: FCFlowStyle = FCFlowStyle.normal) {
        switch flow.type {
        case .Line:
            drawLine(flow, style: style)
        case .ArrowLine:
            drawArrawLine(flow, style: style)
        case .DotLine:
            drawDotLine(flow, style: style)
        case .Custom:
            drawCustomLine(flow, style: style)
            break
        }

        drawText(flow, style: style)
    }

    func drawCustomLine(flow: FCFlow, style: FCFlowStyle = FCFlowStyle.normal) {
        flow.draw(contentView, style: style)
//        var path = flow.draw(self, style: style)
//        
//        let layer = CAShapeLayer()
//        layer.frame = contentView.bounds //CGRectMake(0, 0, length, length)
//        layer.path = path
//        
//        layer.lineCap = "kCGLineCapRound"
//        layer.lineWidth = style.lineWidth
//        layer.fillColor = UIColor.clearColor().CGColor
//        layer.strokeColor = style.lineColor
//        
//        self.contentView.layer.addSublayer(layer)
    }

    func drawLine(flow: FCFlow, style: FCFlowStyle = FCFlowStyle.normal) {
        var path = CGPathCreateMutable()
        CGPathAddPath(path, nil, drawLine(flow.points, style: style))
        
        let layer = CAShapeLayer()
        layer.frame = contentView.bounds //CGRectMake(0, 0, length, length)
        layer.path = path
        
        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = style.lineWidth
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = style.lineColor
        
        self.contentView.layer.addSublayer(layer)
    }
    
    func drawLine(points: [CGPoint], style: FCFlowStyle) -> CGPath {
        var path = CGPathCreateMutable()
        if points.count < 2 {
            
        }
        else {
            CGPathMoveToPoint(path, nil, points.first!.x, points.first!.y)
            for i in 1..<points.count - 1 {
                let s = points[i]
                let e = points[i+1]
                CGPathAddArcToPoint(path, nil, s.x, s.y, e.x, e.y, style.lineRadius)
            }
            CGPathAddLineToPoint(path, nil, points.last!.x, points.last!.y)
        }
        
        return path
    }

    func drawDotLine(flow: FCFlow, style: FCFlowStyle = FCFlowStyle.normal) {
        var path = CGPathCreateMutable()
        CGPathAddPath(path, nil, drawLine(flow.points, style: style))
        
        let layer = CAShapeLayer()
        layer.frame = contentView.bounds //CGRectMake(0, 0, length, length)
        layer.path = path
        
        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = style.lineWidth
        layer.lineDashPattern = [style.lineWidth, 3*style.lineWidth]
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = style.lineColor
        
        self.contentView.layer.addSublayer(layer)
    }
    
    func drawArrawLine(flow: FCFlow, style: FCFlowStyle = FCFlowStyle.normal) {
        var path = CGPathCreateMutable()
        CGPathAddPath(path, nil, drawArrawLine(flow.points, style: style))
        
        let layer = CAShapeLayer()
        layer.frame = contentView.bounds //CGRectMake(0, 0, length, length)
        layer.path = path
        
        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = style.lineWidth
        layer.fillColor = UIColor.clearColor().CGColor
        layer.strokeColor = style.lineColor
        
        self.contentView.layer.addSublayer(layer)
    }
    
    func drawArrawLine(points: [CGPoint], style: FCFlowStyle) -> CGPathRef {
        var path = CGPathCreateMutable()
        if points.count < 2 {
            
        }
        else {
            CGPathMoveToPoint(path, nil, points.first!.x, points.first!.y)
            for i in 1..<points.count - 1 {
                let s = points[i]
                let e = points[i+1]
                CGPathAddArcToPoint(path, nil, s.x, s.y, e.x, e.y, style.lineRadius)
            }
            //CGPathAddLineToPoint(path, nil, points.last!.x, points.last!.y)
            FlowChartView.pathAddArrawLineToPoint(path, endPoint: points.last!)
        }
        
        return path
    }

    struct Arraw {
        static let Length: CGFloat = 9.0
        static let Width: CGFloat = 5.0
    }
    
    public class func pathAddArrawLineToPoint(path: CGMutablePathRef, endPoint: CGPoint) -> CGPathRef {
        let startPoint = CGPathGetCurrentPoint(path)
        
        let length = hypot(endPoint.x - startPoint.x, endPoint.y - startPoint.y)
        let width = max(endPoint.x - startPoint.x, 1)
        let height = max(endPoint.y - startPoint.y, 1)

        let cosine = (endPoint.x - startPoint.x) / length
        let sine = (endPoint.y - startPoint.y) / length
        var transform = CGAffineTransformMake(cosine, sine, -sine, cosine, startPoint.x, startPoint.y)


        let points = [CGPointMake(0, 0), CGPointMake(length - Arraw.Length, 0), CGPointMake(length - Arraw.Length, Arraw.Width / 2), CGPointMake(length, 0), CGPointMake(length - Arraw.Length, -Arraw.Width / 2), CGPointMake(length - Arraw.Length, 0)]
        CGPathAddLines(path, &transform, points, points.count)
        CGPathCloseSubpath(path)
        
        return path
    }

}