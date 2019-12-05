//
//  ViewController.swift
//  animations
//
//  Created by gdaalumno on 10/16/19.
//  Copyright © 2019 gdaalumno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            //self.createCircle()
            let shape = Star()
            let xPos = CGFloat.random(in: 0...self.view.frame.width)
            shape.backgroundColor = UIColor.white.withAlphaComponent(0.0)
            shape.frame = CGRect(x: xPos, y: 100, width: 120, height: 120)
            self.view.addSubview(shape)
            self.animateShape(circle: shape)
        }
    }
    
    func createCircle(radius: Int = Int.random(in: 20...100)) {
        let xPos = CGFloat.random(in: 0...view.frame.width)
        let circle = UIView()
        circle.frame = CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2)
        circle.center = CGPoint(x: xPos, y: 100)
        circle.backgroundColor = getRandomColor()
        circle.layer.cornerRadius = circle.frame.width / 2
        view.addSubview(circle)

        animateShape(circle: circle)
    }
    
    func animateShape(circle: UIView) {
        UIView.animate(withDuration: 2, delay: 1, options: [.autoreverse, .curveEaseIn], animations: {
            circle.center = CGPoint(x: circle.center.x, y: self.view.frame.height - 100)
        }, completion: {
            complete in
            circle.removeFromSuperview()
        })
        
    }
    
    func getRandomColor() -> UIColor {
        let red:CGFloat = CGFloat.random(in: 0...1)
        let green:CGFloat = CGFloat.random(in: 0...1)
        let blue:CGFloat = CGFloat.random(in: 0...1)
        
        return UIColor(red:red, green: green, blue: blue, alpha: 1.0)
    }

}

