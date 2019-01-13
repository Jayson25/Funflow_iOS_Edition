//
//  UICircularProgressBar.swift
//  Funflow
//
//  Created by Jayson Galante on 11/01/2019.
//  Copyright © 2019 utt. All rights reserved.
//

import UIKit

class UICircularProgressBar : UIView{
    var backgroundPath : UIBezierPath!
    var shapeLayer : CAShapeLayer!
    var progressLayer : CAShapeLayer!
    var progressLabel : UILabel!
    
    var progress : Float = 0 {
        willSet(newValue) {
            self.progressLayer.strokeEnd = CGFloat(newValue)
            
            if (newValue > 0.75){
                self.progressLayer.strokeColor = UIColor.green.cgColor
            }
            
            else if (newValue > 0.33){
                self.progressLayer.strokeColor = UIColor.orange.cgColor
            }
            
            else{
                self.progressLayer.strokeColor = UIColor.red.cgColor
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    private func initialize(){
        self.backgroundPath = UIBezierPath()
        self.drawShape()
    }
    
    private func createCirclePath() {
        let x = self.frame.width/2
        let y = self.frame.height/2
        let center = CGPoint(x: x, y: y)
        
        self.backgroundPath.addArc(withCenter: center, radius: x/CGFloat(2), startAngle: CGFloat(0), endAngle: CGFloat(6.28), clockwise: true)
        self.backgroundPath.close()
    }
    
    func drawShape() {
        createCirclePath()
        
        self.shapeLayer = CAShapeLayer()
        self.shapeLayer.path = backgroundPath.cgPath
        self.shapeLayer.lineWidth = 10
        self.shapeLayer.fillColor = nil
        self.shapeLayer.strokeColor = UIColor.lightGray.cgColor
        
        self.progressLayer = CAShapeLayer()
        self.progressLayer.path = backgroundPath.cgPath
        self.progressLayer.lineWidth = 10
        self.progressLayer.lineCap = CAShapeLayerLineCap.round
        self.progressLayer.fillColor = nil
        self.progressLayer.strokeColor = UIColor.red.cgColor
        self.progressLayer.strokeEnd = 0.0
        
        self.layer.addSublayer(self.shapeLayer)
        self.layer.addSublayer(self.progressLayer)
    }
}
