import Foundation
import UIKit

@IBDesignable class CircularProgressView: UIView {
    
    @IBInspectable var arcWidth:CGFloat = 10.0
    @IBInspectable var arcColor:UIColor = UIColor.blueColor()
    @IBInspectable var arcBackgroundColor:UIColor = UIColor.darkGrayColor()
    @IBInspectable var hasRoundedEndCap: Bool = true
    @IBInspectable var isClockwise: Bool = true
    @IBInspectable var progress:CGFloat = 0.0 {
        didSet{
            setNeedsDisplay()
        }
        willSet(newEndArc) {
            self.progress = max(min(1.0, newEndArc), 0.0)
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        var cursor = isClockwise ? progress : (1.0 - progress)
        
        let fullCircle = 2.0 * CGFloat(M_PI)
        let angleOne:CGFloat = -0.25 * fullCircle  // North
        let angleTwo:CGFloat = cursor * fullCircle + angleOne
        let start,end: CGFloat
        
        if isClockwise {
            start = angleOne
            end = angleTwo
        } else {
            start = angleTwo
            end = angleOne
        }
        
        var centerPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        
        var radius:CGFloat = (min(rect.width, rect.height) - arcWidth) / 2.0
        
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(context, arcWidth)
        if hasRoundedEndCap {
            CGContextSetLineCap(context, kCGLineCapRound)
        } else {
            CGContextSetLineCap(context, kCGLineCapSquare)
        }
        
        CGContextSetStrokeColorWithColor(context, arcBackgroundColor.CGColor)
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, 0, fullCircle, 0)
        CGContextStrokePath(context)
        
        CGContextSetStrokeColorWithColor(context, arcColor.CGColor)
        CGContextSetLineWidth(context, arcWidth )
        
        CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, start,end, 0)
        CGContextStrokePath(context)
    }
}
