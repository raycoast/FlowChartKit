//
//  FlowChartView+DrawShape.swift
//  FlowChartKit
//
//  Created by QiangRen on 11/5/15.
//  Copyright (c) 2015 QiangRen. All rights reserved.
//

import UIKit

// MARK: - CoreGraphics Shapes
extension FlowChartView {
    
    func drawShape(shape: FCShape, style: FCShapeStyle = FCShapeStyle.normal) {
        let view: UIView
        switch shape.type {
        case .Circle:
            view = drawCircle(shape, style: style)
        case .Oval:      // Terminal
            view = drawOval(shape, style: style)
        case .Ellipse:
            view = drawEllipse(shape, style: style)
        case .Square:    // Process
            view = drawSquare(shape, style: style)
        case .Diamond:   // Decision
            view = drawDiamond(shape, style: style)
        case .Quadangle: // Input/Output
            view = drawQuadangle(shape, style: style)
        case .Hexagon:   // Preparation
            view = drawHexagon(shape, style: style)
        }
        contentView.addSubview(view)
        shape.draw(view, style: style)
    }
    
    func drawCircle(shape: FCShape, style: FCShapeStyle = FCShapeStyle.normal) -> UIView {
        let d = min(shape.rect.size.width, shape.rect.size.height)
        let dx = (shape.rect.size.width - d) / 2
        let dy = (shape.rect.size.height - d) / 2
        let rect = shape.rect.rectByInsetting(dx: dx, dy: dy)
        
        let v = UIButton(frame: rect)
        v.layer.cornerRadius = d / 2
        v.layer.borderColor = style.borderColor
        v.layer.borderWidth = style.borderWidth
        
        v.setTitleColor(style.textColor, forState: .Normal)
        v.setTitle(shape.title, forState: UIControlState.Normal)
        
        return v
    }
    
    func drawOval(shape: FCShape, style: FCShapeStyle = FCShapeStyle.normal) -> UIView {
        let v = UIButton(frame: shape.rect)
        v.layer.cornerRadius = min(shape.rect.width, shape.rect.height) / 2
        v.layer.borderColor = style.borderColor
        v.layer.borderWidth = style.borderWidth
        
        v.setTitleColor(style.textColor, forState: .Normal)
        v.setTitle(shape.title, forState: UIControlState.Normal)
        v.addTarget(self, action: "onTaped:", forControlEvents: .TouchUpInside)
        
        for (i, s) in enumerate(shapes ?? []) {
            if s.id == shape.id {
                v.tag = i
                break
            }
        }
        
        return v
    }
    
    func drawEllipse(shape: FCShape, style: FCShapeStyle = FCShapeStyle.normal) -> UIView {
        let v = UIView(frame: shape.rect)
        
        var path = CGPathCreateMutable()
        CGPathAddEllipseInRect(path, nil, CGRectMake(0, 0, shape.rect.width, shape.rect.height))
        //CGPathCloseSubpath(path)
        
        let layer = CAShapeLayer()
        layer.frame = v.bounds
        layer.path = path
        
        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = style.borderWidth
        layer.strokeColor = style.borderColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        v.layer.addSublayer(layer)
        
        return v
    }
    
    func drawSquare(shape: FCShape, style: FCShapeStyle = FCShapeStyle.normal) -> UIView {
        let v = UIButton(frame: shape.rect)
        v.layer.cornerRadius = style.cornerRadius
        v.layer.borderColor = style.borderColor
        v.layer.borderWidth = style.borderWidth
        
        v.setTitleColor(style.textColor, forState: .Normal)
        v.setTitle(shape.title, forState: UIControlState.Normal)
        v.addTarget(self, action: "onTaped:", forControlEvents: .TouchUpInside)
        
        for (i, s) in enumerate(shapes ?? []) {
            if s.id == shape.id {
                v.tag = i
                break
            }
        }
        
        return v
    }
    
    func drawDiamond(shape: FCShape, style: FCShapeStyle = FCShapeStyle.normal) -> UIView {
        let v = UIView(frame: shape.rect)
        
        var path = CGPathCreateMutable()
        let points = [
            CGPointMake(shape.rect.width / 2, 0),
            CGPointMake(shape.rect.width, shape.rect.height / 2),
            CGPointMake(shape.rect.width / 2, shape.rect.height),
            CGPointMake(0, shape.rect.height / 2),
            CGPointMake(shape.rect.width / 2, 0),
        ]
        //CGPathMoveToPoint(path, nil, shape.rect.midX, 0)
        CGPathAddLines(path, nil, points, points.count)
        CGPathCloseSubpath(path)
        
        let layer = CAShapeLayer()
        layer.frame = v.bounds
        layer.path = path
        
        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = style.borderWidth
        layer.strokeColor = style.borderColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        v.layer.addSublayer(layer)
        
        return v
    }
    
    func drawQuadangle(shape: FCShape, style: FCShapeStyle = FCShapeStyle.normal) -> UIView {
        let v = UIView(frame: shape.rect)
        
        var path = CGPathCreateMutable()
        let halfHeight = shape.rect.size.height/2
        let halfWidth = shape.rect.size.width/2
        
        let oneQuarterHeight = shape.rect.size.height/4
        let oneQuarterWidth = shape.rect.size.width/4
        
        let threeQuarterHeight = oneQuarterHeight * 3
        let threeQuarterWidth = oneQuarterWidth * 3
        
        let fullHeight = shape.rect.size.height
        let fullWidth = shape.rect.size.width
        
        let originX: CGFloat = 0.0 //shape.rect.origin.x
        let originY: CGFloat = 0.0 //shape.rect.origin.y
        
        let radius:CGFloat = style.cornerRadius //fullHeight/9.0
        
        
        //CENTERS
        let leftBottom = CGPoint(x: originX, y: originY + fullHeight)
        let rightTop = CGPoint(x: originX + fullWidth, y: originY)
        
        //QUARTERS
        let leftTopQuarter = CGPoint(x: originX + oneQuarterWidth, y: originY)
        
        let rightBottomQuarter = CGPoint(x: originX + threeQuarterWidth, y: originY + fullHeight)
        
        //Computed Start Point
        let computedX = leftBottom.x + (leftTopQuarter.x - leftBottom.x)/2.0
        let computedY = leftBottom.y - (leftBottom.y - leftTopQuarter.y)/2.0
        
        
        //Start here (needs to be between first and last point
        //This will be the top center of the view, so half way in (X) and full up (Y)
        CGPathMoveToPoint(path, nil, computedX, computedY)
        
        //Take it to that point, and point it at the next direction
        CGPathAddArcToPoint(path, nil, leftTopQuarter.x, leftTopQuarter.y, rightTop.x, rightTop.y, radius)
        CGPathAddArcToPoint(path, nil, rightTop.x, rightTop.y, rightBottomQuarter.x, rightBottomQuarter.y, radius)
        CGPathAddArcToPoint(path, nil, rightBottomQuarter.x, rightBottomQuarter.y, leftBottom.x, leftBottom.y, radius)
        CGPathAddArcToPoint(path, nil, leftBottom.x, leftBottom.y, leftTopQuarter.x, leftTopQuarter.y, radius)
        
        CGPathCloseSubpath(path)
        
        let layer = CAShapeLayer()
        layer.frame = v.bounds
        layer.path = path
        
        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = style.borderWidth
        layer.strokeColor = style.borderColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        v.layer.addSublayer(layer)
        
        return v
    }
    
    func drawHexagon(shape: FCShape, style: FCShapeStyle = FCShapeStyle.normal) -> UIView {
        let v = UIView(frame: shape.rect)
        
        var path = CGPathCreateMutable()
        let halfHeight = shape.rect.size.height/2
        let halfWidth = shape.rect.size.width/2
        
        let oneQuarterHeight = shape.rect.size.height/4
        let oneQuarterWidth = shape.rect.size.width/4
        
        let threeQuarterHeight = oneQuarterHeight * 3
        let threeQuarterWidth = oneQuarterWidth * 3
        
        let fullHeight = shape.rect.size.height
        let fullWidth = shape.rect.size.width
        
        let originX: CGFloat = 0.0 //shape.rect.origin.x
        let originY: CGFloat = 0.0 //shape.rect.origin.y
        
        let radius:CGFloat = style.cornerRadius //fullHeight/9.0
        
        
        //CENTERS
        let leftCenter = CGPoint(x: originX, y: originY + halfHeight)
        let rightCenter = CGPoint(x: originX + fullWidth, y: originY + halfHeight)
        
        //QUARTERS
        let leftTopQuarter = CGPoint(x: originX + oneQuarterWidth, y: originY)
        let leftBottomQuarter = CGPoint(x: originX + oneQuarterWidth, y: originY + fullHeight)
        
        let rightTopQuarter = CGPoint(x: originX + threeQuarterWidth, y: originY)
        let rightBottomQuarter = CGPoint(x: originX + threeQuarterWidth, y: originY + fullHeight)
        
        //Computed Start Point
        let computedX = leftCenter.x + (leftBottomQuarter.x - leftCenter.x)/2.0
        let computedY = leftCenter.y - (leftBottomQuarter.y - leftCenter.y)/2.0
        
        
        //Start here (needs to be between first and last point
        //This will be the top center of the view, so half way in (X) and full up (Y)
        CGPathMoveToPoint(path, nil, computedX, computedY)
        
        //Take it to that point, and point it at the next direction
        CGPathAddArcToPoint(path, nil, leftTopQuarter.x, leftTopQuarter.y, rightTopQuarter.x, rightTopQuarter.y, radius)
        
        CGPathAddArcToPoint(path, nil, rightTopQuarter.x, rightTopQuarter.y, rightCenter.x, rightCenter.y, radius)
        CGPathAddArcToPoint(path, nil, rightCenter.x, rightCenter.y, rightBottomQuarter.x, rightBottomQuarter.y, radius)
        
        CGPathAddArcToPoint(path, nil, rightBottomQuarter.x, rightBottomQuarter.y, leftBottomQuarter.x, leftBottomQuarter.y, radius)
        CGPathAddArcToPoint(path, nil, leftBottomQuarter.x, leftBottomQuarter.y, leftCenter.x, leftCenter.y, radius)
        //
        CGPathAddArcToPoint(path, nil, leftCenter.x, leftCenter.y, leftTopQuarter.x, leftTopQuarter.y, radius)
        
        
        CGPathCloseSubpath(path)
        
        let layer = CAShapeLayer()
        layer.frame = v.bounds
        layer.path = path
        
        layer.lineCap = "kCGLineCapRound"
        layer.lineWidth = style.borderWidth
        layer.strokeColor = style.borderColor
        layer.fillColor = UIColor.clearColor().CGColor
        
        v.layer.addSublayer(layer)
        
        return v
    }
    
    func onTaped(sender: UIButton) {
        delegate?.flowChartView(self, didTaponShape: self.shapes?[sender.tag])
    }
    
}

