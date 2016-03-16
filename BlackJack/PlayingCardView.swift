//
//  PlayingCardView.swift
//  BlackJack
//
//  Created by Nathan Barker on 2/11/16.
//  Copyright © 2016 Nathan Barker. All rights reserved.
//

import Foundation
import UIKit

class PlayingCardView:UIView{
    
    let suits : [String] = ["?","♠︎","♣︎","♥︎","♦︎"];
    
    var rank:Int = 1{
        didSet{
            setNeedsDisplay()
            print ("\(rank)")
        }
    }
    
    var suit:String = "♠︎"{
        didSet{
            setNeedsDisplay()
            print ("\(suit)")
        }
    }
    var faceUp:Bool = true{
        didSet{
            setNeedsDisplay()
        }
    }
    
    let defaultScaleFactor = 0.9
    
    var faceCardScaleFactor = 0.9
    
    func rankAsString() ->String{
        return ["?","A","2","3","4","5","6","7","8","9","10","J","Q","K"][rank];
    }
    
    func makeRandomCard(){
        rank = random()%13+1
        suit = suits[random()%4+1];
        setNeedsDisplay()
    }
    
    
    let CORNER_FONT_STANDARD_HEIGHT:CGFloat = 180.0
    let CORNER_RADIUS:CGFloat = 12.0
    
    func cornerScaleFactor() -> CGFloat { return bounds.size.height / CORNER_FONT_STANDARD_HEIGHT }
    func cornerRadius() ->CGFloat { return CORNER_RADIUS * cornerScaleFactor() }
    func cornerOffset() ->CGFloat  { return cornerRadius() / 3.0 }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        
        //UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
        let roundedRect = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius())
        roundedRect.addClip()
        
        UIColor.whiteColor().setFill()
        UIRectFill(self.bounds)
        
        UIColor.blackColor().setStroke()
        roundedRect.stroke()
        
        if (self.faceUp) {
            if let faceImage = UIImage(named: "\(rankAsString())\(suit)"){
                let imageRect = CGRectInset(self.bounds,
                    self.bounds.size.width * (1.0-CGFloat(self.faceCardScaleFactor)),
                    self.bounds.size.height * (1.0-CGFloat(self.faceCardScaleFactor)))
                faceImage.drawInRect(imageRect)
            } else {
                drawPips()
            }
            
            drawCorners();
        } else {
            UIImage(named: "cardback")?.drawInRect(self.bounds)
        }
    }
    
    func pushContextAndRotateUpsideDown(){
        let context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
        CGContextRotateCTM(context, CGFloat(M_PI));
    }
    
    func popContext(){
        CGContextRestoreGState(UIGraphicsGetCurrentContext());
    }
    
    
    func drawCorners() {
        let paragraphStyle = NSMutableParagraphStyle();
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let cornerFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        cornerFont.fontWithSize(cornerFont.pointSize * cornerScaleFactor())
        
        let cornerText = NSAttributedString(string: "\(rankAsString())\n\(suit)", attributes: [NSFontAttributeName:cornerFont,NSParagraphStyleAttributeName:paragraphStyle])
        
        
        var textBounds:CGRect = CGRect();
        textBounds.origin = CGPointMake(cornerOffset(), cornerOffset())
        textBounds.size = cornerText.size()
        cornerText.drawInRect(textBounds)
        
        
        pushContextAndRotateUpsideDown()
        cornerText.drawInRect(textBounds)
        popContext()
    }
    
    let PIP_HOFFSET_PERCENTAGE:CGFloat = 0.165
    let PIP_VOFFSET1_PERCENTAGE:CGFloat = 0.090
    let PIP_VOFFSET2_PERCENTAGE:CGFloat = 0.175
    let PIP_VOFFSET3_PERCENTAGE:CGFloat = 0.270
    
    func drawPips(){
        if ((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3)) {
            drawPipsWithHorizontalOffset(0, vOffset: 0, mirroredVertically: false)
        }
        if ((self.rank == 6) || (self.rank == 7) || (self.rank == 8)) {
            drawPipsWithHorizontalOffset(PIP_HOFFSET_PERCENTAGE, vOffset: 0, mirroredVertically: false)
        }
        if ((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10)) {
            drawPipsWithHorizontalOffset(0, vOffset: PIP_VOFFSET2_PERCENTAGE, mirroredVertically: self.rank != 7)
        }
        if ((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10)) {
            drawPipsWithHorizontalOffset(PIP_HOFFSET_PERCENTAGE, vOffset: PIP_VOFFSET3_PERCENTAGE, mirroredVertically: true)
        }
        if ((self.rank == 9) || (self.rank == 10)) {
            drawPipsWithHorizontalOffset(PIP_HOFFSET_PERCENTAGE, vOffset: PIP_VOFFSET1_PERCENTAGE, mirroredVertically: true)
        }
    }
    
    let PIP_FONT_SCALE_FACTOR:CGFloat = 0.012
    
    func drawPipsWithHorizontalOffset(hoffset:CGFloat, voffset:CGFloat, upsideDown:Bool){
        if upsideDown {
            pushContextAndRotateUpsideDown()
        }
        let middle = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        var pipFont = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        pipFont = pipFont.fontWithSize(pipFont.pointSize * self.bounds.size.width * PIP_FONT_SCALE_FACTOR)
        let attributedSuit = NSAttributedString(string: suit, attributes: [NSFontAttributeName:pipFont])
        let pipSize = attributedSuit.size
        var pipOrigin = CGPointMake(
            middle.x-pipSize().width/2.0-hoffset*self.bounds.size.width,
            middle.y-pipSize().height/2.0-voffset*self.bounds.size.height
        )
        attributedSuit.drawAtPoint(pipOrigin);
        if (hoffset != 0) {
            pipOrigin.x += hoffset*2.0*self.bounds.size.width;
            attributedSuit.drawAtPoint(pipOrigin);
        }
        if upsideDown{
            popContext()
        }
    }
    
    
    func drawPipsWithHorizontalOffset(hoffset :CGFloat, vOffset:CGFloat, mirroredVertically:Bool){
        drawPipsWithHorizontalOffset(hoffset, voffset: vOffset, upsideDown: false)
        if (mirroredVertically) {
            drawPipsWithHorizontalOffset(hoffset, voffset: vOffset, upsideDown: true)
        }
    }
    
    
    
    
    
}
