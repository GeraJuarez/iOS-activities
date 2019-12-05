//
//  Star.swift
//  animations
//
//  Created by gdaalumno on 10/16/19.
//  Copyright © 2019 gdaalumno. All rights reserved.
//

import Foundation
import UIKit

class Star: UIView {
    var starColor = UIColor()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        starColor = self.getRandomYellow()
    }
    
    override func draw(_ rect: CGRect) {
        let starPath = UIBezierPath()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let numberOfPoints = CGFloat(5.0)
        let numberOfLineSegments = Int(numberOfPoints * 2.0)
        let theta = .pi / numberOfPoints
        let circumscribedRadius = center.x
        let outerRadius = circumscribedRadius * 1.039
        let excessRadius = outerRadius - circumscribedRadius
        let innerRadius = CGFloat(outerRadius * 0.382)
        let leftEdgePointX = (center.x + cos(4.0 * theta) * outerRadius) + excessRadius
        let horizontalOffset = leftEdgePointX / 2.0

        // Apply a slight horizontal offset so the star appears to be more
        // centered visually
        let offsetCenter = CGPoint(x: center.x - horizontalOffset, y: center.y)

        // Alternate between the outer and inner radii while moving evenly along the
        // circumference of the circle, connecting each point with a line segment
        for i in 0..<numberOfLineSegments {
            let radius = i % 2 == 0 ? outerRadius : innerRadius

            let pointX = offsetCenter.x + cos(CGFloat(i) * theta) * radius
            let pointY = offsetCenter.y + sin(CGFloat(i) * theta) * radius
            let point = CGPoint(x: pointX, y: pointY)

            if i == 0 {
                starPath.move(to: point)
            } else {
                starPath.addLine(to: point)
            }
        }

        starPath.close()

        // Rotate the path so the star points up as expected
        var pathTransform  = CGAffineTransform.identity
        pathTransform = pathTransform.translatedBy(x: center.x, y: center.y)
        pathTransform = pathTransform.rotated(by: CGFloat(-.pi / 2.0))
        pathTransform = pathTransform.translatedBy(x: -center.x, y: -center.y)
        starPath.apply(pathTransform)

        starColor.setFill()
        starPath.fill()
        starPath.stroke()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        starColor = self.getRandomYellow()
    }

    
    private func getRandomYellow() -> UIColor {
        let red:CGFloat = CGFloat.random(in: 0.6...1)
        let green:CGFloat = CGFloat.random(in: 0.6...1)
        let blue:CGFloat = CGFloat.random(in: 0...0)
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }
}
