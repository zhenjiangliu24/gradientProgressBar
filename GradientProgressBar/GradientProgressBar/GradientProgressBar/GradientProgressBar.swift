//
//  GradientProgressBar.swift
//  GradientProgressBar
//
//  Created by Zhenjiang Liu on 2018-08-21.
//  Copyright © 2018 zhenjiang. All rights reserved.
//

import UIKit

import UIKit

@IBDesignable
class GradientProgressBar: UIView {
    
    @IBInspectable var trackColor: UIColor = UIColor.clear
    @IBInspectable var leftColor: UIColor = UIColor.blue
    @IBInspectable var rightColor: UIColor = UIColor.red
    @IBInspectable var barThickness: CGFloat = 6
    @IBInspectable var barPadding: CGFloat = 10
    @IBInspectable var progress: Float = 0 {
        didSet {
            if progress >= 1 {
                progress = 1
            } else if progress <= 0 {
                progress = 0
            }
            setNeedsDisplay()
        }
    }
    
    fileprivate var progressValue: CGFloat {
        return CGFloat(progress)
    }
    
    fileprivate var trackHeight: CGFloat {
        return barThickness
    }
    
    fileprivate var trackOffset: CGFloat {
        return trackHeight / 2
    }
    
    fileprivate var gradientBarLength: CGFloat {
        return (frame.size.width - 2 * barPadding - trackHeight) * progressValue
    }
    
    override func draw(_ rect: CGRect) {
        drawProgressView()
    }
    
    fileprivate func drawProgressView() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        drawTrackBar(context: context)
        
        guard progressValue > 0 else { return }
        drawGradientBar(context: context)
    }
    
    fileprivate func drawTrackBar(context: CGContext) {
        context.saveGState()
        
        let radius = frame.size.height / 2
        // draw the track
        context.setStrokeColor(trackColor.cgColor)
        context.setLineWidth(trackHeight)
        
        let trackPath = UIBezierPath()
        trackPath.move(to: CGPoint(x: barPadding + trackOffset, y: radius))
        trackPath.addLine(to: CGPoint(x: frame.size.width - barPadding - trackOffset, y: radius))
        context.setLineCap(.round)
        context.addPath(trackPath.cgPath)
        context.drawPath(using: .stroke)
        
        context.restoreGState()
    }
    
    fileprivate func drawGradientBar(context: CGContext) {
        context.saveGState()
        
        let middle = frame.size.height / 2
        let radius = trackHeight / 2
        
        context.beginPath()
        let barPath = UIBezierPath()
        barPath.move(to: CGPoint(x: barPadding + radius, y: middle - radius))
        barPath.addLine(to: CGPoint(x: barPadding + radius + gradientBarLength, y: middle - radius))
        if progressValue < 1.0 {
            barPath.addLine(to: CGPoint(x: barPadding + radius + gradientBarLength, y: middle + radius))
        }else {
            barPath.addArc(withCenter: CGPoint(x: barPadding + radius + gradientBarLength, y: middle), radius: radius, startAngle: CGFloat(Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 5 / 2), clockwise: true)
        }
        barPath.addLine(to: CGPoint(x: barPadding + radius, y: middle + radius))
        barPath.addArc(withCenter: CGPoint(x: barPadding + radius, y: middle), radius: radius, startAngle: CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi * 3 / 2), clockwise: true)
        barPath.close()
        context.addPath(barPath.cgPath)
        context.closePath()
        // clip the area before drawing the gradient.
        context.clip()
        
        drawGradient(context: context)
        context.restoreGState()
    }
    
    fileprivate func drawGradient(context: CGContext) {
        let colors = [leftColor.cgColor, rightColor.cgColor] as CFArray
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: [0.0, 1.0]) else { return }
        context.drawLinearGradient(gradient, start: CGPoint(x: barPadding, y: 0.0), end: CGPoint(x: frame.size.width - barPadding, y: 0.0), options: .drawsAfterEndLocation)
    }
    
}
