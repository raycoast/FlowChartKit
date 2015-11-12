//
//  FlowChartView+Scroll.swift
//  FlowChartKit
//
//  Created by QiangRen on 11/5/15.
//  Copyright (c) 2015 QiangRen. All rights reserved.
//

import UIKit

extension FlowChartView: UIScrollViewDelegate {
    
    func initScrollView() {
        scrollView = UIScrollView(frame: self.bounds)
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        scrollView.delegate = self
        scrollView.scrollEnabled = true
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 2.0
        self.addSubview(scrollView)
        
        let subViews = ["scrollView": scrollView]
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: .allZeros, metrics: nil, views: subViews))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: .allZeros, metrics: nil, views: subViews))
        
        contentView = UIView(frame: scrollView.bounds)
        scrollView.addSubview(contentView)
    }
    
    public func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return contentView
    }
    
}
