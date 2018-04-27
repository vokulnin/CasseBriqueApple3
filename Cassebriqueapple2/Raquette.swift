//
//  Raquette.swift
//  CasseBrique
//
//  Created by vokulnin on 4/18/18.
//  Copyright © 2018 vokulnin. All rights reserved.
//

import UIKit

class Raquette: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder : aDecoder)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: self)
            paddle.px = position.x - (paddle.sx * vX)/2
        }
        self.setNeedsDisplay()

    }
    
    var timer = Timer()
    var ball = Ball(Sx : 10,Sy : 10,Px: 200,Py : 500)
    var life = 3
    var score = 0
    var level = 0
    var bricks = [Brick]()
    var brickLeft = 0
    var vX = CGFloat (500)
    var playing = true
    var won = false
    var time = Float(5)
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
    }
    
    func Reset(){
        brickLeft = 0
        life = 3
        level = 0
        score = 0
        bricks = [Brick]()
        playing = true
        won = false

        time = Float(5)
    }



    var paddle = Raquette2(Sx : 0.5 ,Sy : 0.02,Px: 0,Py : 0.75)
    
    override init(frame : CGRect){


        super.init(frame: frame);
        self.becomeFirstResponder()

        backgroundColor = UIColor.clear;
        scheduledTimerWithTimeInterval();
        
    }

    func generate(x : CGFloat , y : CGFloat){
        for i in 1...(Int(x)) {
            for j in 1...(Int(y)){
                bricks.append(Brick(Sx : vX/(x+1) , Sy : (vX/(x+1))/2 , Px : ((vX/(x + 1.2))) * CGFloat(i-1) , Py : ((vX/(x)/2) * CGFloat(j-1)  )))
                brickLeft = brickLeft + 1;
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if(playing){
        let context = UIGraphicsGetCurrentContext()

        let vX = UIScreen.main.bounds.width
        let vY = UIScreen.main.bounds.height
        context?.setLineWidth(5)
        UIColor.gray.setStroke()
        if(ball.px<0 || ball.px + ball.sx > vX){
            ball.sideBounce()
        }
        if(ball.py < 0){
            ball.upBounce()
        }
        let carreBall = CGRect(x:ball.px , y:ball.py , width:ball.sx , height:ball.sy)
        let carrePaddle = CGRect(x:paddle.px  , y:paddle.py * vY  , width:paddle.sx * vX, height:paddle.sy * vY )

        var i = 0
        for brick in bricks{
      
            let carreBrique = CGRect(x:brick.px , y:brick.py , width:brick.sx , height:brick.sy)

            if(carreBrique.intersects(carreBall)){
                
                bricks.remove(at : i)
                ball.paddleBounce()
                brickLeft -= 1
                score = score + 10
                break
            }
                  i = i+1
        }
        for brick in bricks{
            let carreBrique = CGRect(x:brick.px , y:brick.py , width:brick.sx , height:brick.sy)
            context?.addRect(carreBrique)

        }
        if (bricks.count == 0){
            switch(level){
            case 0:
            generate(x : 5,y : 2)
                level += 1
                break
            case 1:
            generate(x : 5,y : 4)
                level += 1
            case 2:
            generate(x : 6,y : 5)
                level += 1
            default:
                won = true
                playing = false
                break
            }
            
        }
        if(ball.py > carrePaddle.minY + carrePaddle.height ){
            life -= 1
            ball.px = 250
            ball.py = 250
        }
            if(life <= 0){
                playing = false
            }
        if carrePaddle.intersects(carreBall){
            ball.paddleBounce()
        }
        ball.move()
        context?.addRect(carrePaddle)
        context?.addRect(carreBall)
        context?.strokePath()
        

        // Drawing code
    }
        else{
            if(time>0){
                time = time - Float(0.02)
            }
            else{
                Reset()
            }
        }
    }

    @objc func update(){
        self.setNeedsDisplay()
    }
    override func motionBegan(_ motion: UIEventSubtype , with event: UIEvent?){
    self.setNeedsDisplay()
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    
    class Brick{
        var px , py , sx , sy : CGFloat
        
        init(Sx : CGFloat , Sy : CGFloat , Px : CGFloat , Py : CGFloat ){
            sx = Sx
            sy = Sy
            px = Px
            py = Py
            
        }
    }
    class Ball {
        var px,py,sx,sy , vx , vy : CGFloat

        func move(){
            px = px + vx
            py = py + vy
        }
        
        init(Sx : CGFloat , Sy : CGFloat , Px : CGFloat , Py : CGFloat ){
            sx = Sx
            sy = Sy
            px = Px
            py = Py
            vx = -5
            vy = -5
            
        }
        func paddleBounce(){
            vy = -vy
        }
        
        func sideBounce(){
            vx =  -vx
        }
        func upBounce(){
            vy = -vy
        }
    }

    class Raquette2 {
        var px,py,sx,sy : CGFloat
        init(Sx : CGFloat , Sy : CGFloat , Px : CGFloat , Py : CGFloat ){
            sx = Sx
            sy = Sy
            px = Px
            py = Py
        }
        func move(Px : CGFloat , Py : CGFloat){
            px = Px
            py = Py
        }
        
    }
}
