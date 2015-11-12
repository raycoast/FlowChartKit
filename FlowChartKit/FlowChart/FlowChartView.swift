//
//  FlowChartView.swift
//  FlowChartKit
//
//  Created by QiangRen on 10/25/15.
//  Copyright (c) 2015 QiangRen. All rights reserved.
//

import UIKit

public protocol FlowChartViewDelegate: NSObjectProtocol {
    func flowChartView(chartView: FlowChartView!, didTaponShape shape: FCShape!)
}

public struct FCFlowStyle {
    var lineWidth: CGFloat = 1.0
    var lineColor: CGColor = UIColor.blackColor().CGColor
    var lineRadius: CGFloat = 5.0
    
    static var normal: FCFlowStyle!
    static var highlight: FCFlowStyle!
    
    private init(dict: NSDictionary) {
        if let lineWidth = dict["LineWidth"] as? NSNumber {
            self.lineWidth = CGFloat(lineWidth.floatValue)
        }
        if let lineColor = dict["LineColor"] as? NSString {
            self.lineColor = UIColor(rgba: lineColor as String).CGColor
        }
        if let lineRadius = dict["LineRadius"] as? NSString {
            self.lineRadius = CGFloat(lineRadius.floatValue)
        }
    }
}

public struct FCShapeStyle {
    var cornerRadius: CGFloat = 5.0
    var borderWidth: CGFloat = 3.0
    var borderColor: CGColor = UIColor.blackColor().CGColor
    var textColor: UIColor = UIColor.blackColor()
    
    static var normal: FCShapeStyle!
    static var highlight: FCShapeStyle!
    
    private init(dict: NSDictionary) {
        if let borderWidth = dict["BorderWidth"] as? NSNumber {
            self.borderWidth = CGFloat(borderWidth.floatValue)
        }
        if let borderColor = dict["BorderColor"] as? NSString {
            self.borderColor = UIColor(rgba: borderColor as String).CGColor
        }
        if let cornerRadius = dict["CornerRadius"] as? NSNumber {
            self.cornerRadius = CGFloat(cornerRadius.floatValue)
        }
        if let textColor = dict["TextColor"] as? NSString {
            self.textColor = UIColor(rgba: textColor as String)
        }
    }
}

public class FlowChartView: UIView, NSCoding {

    public var delegate: FlowChartViewDelegate!
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var shapes: [FCShape]? {
        didSet {
            if let shapes = shapes {
                var rect: CGRect!
                for s in shapes {
                    if rect == nil {
                        rect = s.rect
                    }
                    else {
                        rect = CGRectUnion(s.rect, rect)
                    }
                }
                if rect != nil {
                    rect = rect.rectByOffsetting(dx: 20, dy: 20)
                    contentView.frame.size = CGSizeMake(rect.maxX, rect.maxY)
                    self.setNeedsLayout()
                    
                    let scaleX = scrollView.frame.width / rect.maxX
                    let scaleY = scrollView.frame.height / rect.maxY
                    scrollView.zoomScale = min(scaleX, scaleY)
                    
//                    scrollView.contentOffset = CGPointMake(rect.minX * scrollView.zoomScale, rect.minY * scrollView.zoomScale)
                }
            } else {
                //frame = CGRectZero
            }
        }
    }
    
    var flows: [FCFlow]?
    
    override public func awakeFromNib() {
        initScrollView()
        loadStyle()
    }

}

extension FlowChartView {

    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        // Drawing code
        for view in self.contentView.subviews {
            view.removeFromSuperview()
        }
        
        //let context = UIGraphicsGetCurrentContext()
        for shape in shapes ?? [] {
            let style = shape.highlighted ? FCShapeStyle.highlight : FCShapeStyle.normal
            drawShape(shape, style: style)
        }

        for flow in flows ?? [] {
            let style = flow.highlighted ? FCFlowStyle.highlight : FCFlowStyle.normal
            drawFlow(flow, style: style)
        }
        //UIGraphicsEndImageContext()
    }

    private func loadStyle() {
        if let url = NSBundle(forClass: FlowChartView.self).URLForResource("FlowChartStyle", withExtension: "plist"),
            let dict = NSDictionary(contentsOfURL: url) {
                if let shape = dict["Shape"] as? NSDictionary {
                    if let normal = shape["Normal"] as? NSDictionary {
                        FCShapeStyle.normal = FCShapeStyle(dict: normal)
                    }
                    if let highlight = shape["Highlight"] as? NSDictionary {
                        FCShapeStyle.highlight = FCShapeStyle(dict: highlight)
                    }
                }
                if let shape = dict["Flow"] as? NSDictionary {
                    if let normal = shape["Normal"] as? NSDictionary {
                        FCFlowStyle.normal = FCFlowStyle(dict: normal)
                    }
                    if let highlight = shape["Highlight"] as? NSDictionary {
                        FCFlowStyle.highlight = FCFlowStyle(dict: highlight)
                    }
                }
        }
    }
    
    public func addShape(shape: FCShape) {
        if self.shapes == nil { self.shapes = [] }
        self.shapes?.append(shape)
        
        self.setNeedsDisplay()
    }

    public func addShapes(shapes: [FCShape]) {
        if self.shapes == nil { self.shapes = [] }
        self.shapes?.extend(shapes)

        self.setNeedsDisplay()
    }
    
    public func addFlow(flow: FCFlow) {
        if self.flows == nil { self.flows = [] }
        self.flows?.append(flow)

        self.setNeedsDisplay()
    }

    public func addFlows(flows: [FCFlow]) {
        if self.flows == nil { self.flows = [] }
        self.flows?.extend(flows)
        
        self.setNeedsDisplay()
    }

}
