//
//  QQMessageButton.swift
//  QQMessageButton
//
//  Created by Tpphha on 16/3/1.
//  Copyright © 2016年 tpphha. All rights reserved.
//

import UIKit

class QQMessageButton: UIButton {
    
    //MARK: - 属性
    lazy var images: [UIImage] = {
        var arraryM = [UIImage]()
        for i in 1...8 {
            let image = UIImage(named: "\(i)")
            arraryM.append(image!)
        }
        return arraryM
    }()
    
    var badgeNumber: Int = 0 {
        didSet {

            if 0 == badgeNumber {
                self.setTitle("", forState: UIControlState.Normal)
            }else {
                self.setTitle("\(badgeNumber)", forState: UIControlState.Normal)
                self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                self.titleLabel?.font = UIFont.systemFontOfSize(self.layer.cornerRadius)
            }
        }
    }
    
    private var shapeLayer: CAShapeLayer?
    
    private var smallCircleView: UIView?
    
    private var maxDistance: CGFloat?
    
    private var firstSmallCircleViewWH: CGFloat?
    
    private var firstSize: CGSize?
    


    //MARK: - 初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        //如果 是用 () 直接创建, frame 为 zero
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        smallCircleView = nil
        shapeLayer = nil
    }

   
    
    //MARK: - 布局
    override func layoutSubviews() {
        super.layoutSubviews()
        guard smallCircleView != nil else {
            smallCircleView = UIView()
            smallCircleView!.backgroundColor = self.backgroundColor
            smallCircleView!.center = self.center
            smallCircleView!.size = CGSizeMake(self.layer.cornerRadius, self.layer.cornerRadius)
            smallCircleView!.layer.cornerRadius = smallCircleView!.width / 2
            firstSmallCircleViewWH = smallCircleView!.width
            firstSize = self.size
            return
        }
        
    }
    //MARK: - 初始化
    private func setup() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.width > self.height ? (self.height / 2) : (self.width / 2)
        maxDistance = self.layer.cornerRadius * 3
        self.backgroundColor = UIColor.redColor()
        self.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "panGesture:"))
        shapeLayer = CAShapeLayer()
        shapeLayer?.fillColor = self.backgroundColor?.CGColor
        self.addTarget(self, action: "buttonClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    //MARK: - 按钮点击
    func buttonClick(button: UIButton) {
        let animation = CAKeyframeAnimation()
        let shake = 10
        animation.keyPath = "transform.translation.x"
        animation.values = [-shake, shake, -shake]
        animation.repeatCount = 3;
        animation.duration = 0.1
        animation.removedOnCompletion = true
        self.layer.addAnimation(animation, forKey: "shake")
    }
    
    //MARK: - 监听手势
    func panGesture(pan: UIPanGestureRecognizer) {
        let panPoint = pan.translationInView(self)
        
        switch pan.state {
        case .Began:
            self.superview?.insertSubview(smallCircleView!, belowSubview: self)
            self.superview?.layer.insertSublayer(shapeLayer!, below: self.layer)
        case .Changed:
            var changPoint = self.center
            changPoint.x += panPoint.x
            changPoint.y += panPoint.y
            pan.setTranslation(CGPointZero, inView: self)
            self.center = changPoint
            
            let currentDistance = pointToPointDistanceWithPoint1((smallCircleView?.center)!, point2: self.center)
            var scale1: CGFloat = 0
            var scale2: CGFloat = 0
            if currentDistance <= maxDistance {
                scale1 = 0.4 + 0.6 * ((maxDistance! - currentDistance) / maxDistance!)
                scale2 = 0.6 + 0.4 * ((maxDistance! - currentDistance) / maxDistance!)
            }else {
                scale1 = 0.4
                scale2 = 0.6
            }
            
            let smallCircleViewWH = firstSmallCircleViewWH! * scale1
            smallCircleView?.size = CGSizeMake(smallCircleViewWH, smallCircleViewWH)
            smallCircleView?.layer.cornerRadius = smallCircleViewWH / 2
            
            
            
            self.size = CGSizeMake((firstSize?.width)! * scale2, (firstSize?.height)! * scale2)
            self.layer.cornerRadius = self.width > self.height ? (self.height / 2) : (self.width / 2)
            
            self.titleLabel?.font = UIFont.systemFontOfSize(self.layer.cornerRadius)
            
            if currentDistance > maxDistance {
                
                shapeLayer!.removeFromSuperlayer()
                smallCircleView?.removeFromSuperview()
                
            }else {
                shapeLayer!.path = path().CGPath
            }
            
        case .Ended:
            let currentDistance = pointToPointDistanceWithPoint1((smallCircleView?.center)!, point2: self.center)
            weak var weakSelf = self
            if currentDistance < maxDistance {
                shapeLayer!.removeFromSuperlayer()
                smallCircleView?.removeFromSuperview()
                UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                    
                    weakSelf!.center = weakSelf!.smallCircleView!.center
                    weakSelf?.size = weakSelf!.firstSize!
                    weakSelf!.layer.cornerRadius = weakSelf!.width > weakSelf!.height ? (weakSelf!.height / 2) : (weakSelf!.width / 2)
                    }, completion: { (finished: Bool) -> Void in
                })

            }else {
                killAll()
            }
        default:
            break
        }
    }
    
    private func killAll() {
        smallCircleView?.removeFromSuperview()
        shapeLayer!.removeFromSuperlayer()
        startMissAnimationWithFrame(self.frame)
        self.removeFromSuperview()
    }
    
    //MARK: - 两点之间距离
    private func pointToPointDistanceWithPoint1(point1: CGPoint, point2: CGPoint) ->CGFloat {
        let xDistance = point2.x - point1.x
        let yDistance = point2.y - point1.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
    
    //MARK: - 中间图形路径
    private func path() -> UIBezierPath {
        let center1 = smallCircleView!.center
        let r1 = smallCircleView!.layer.cornerRadius
        let center2 = self.center
        let r2 = self.layer.cornerRadius
        let d = pointToPointDistanceWithPoint1(center1, point2: center2)
        let x1 = center1.x
        let x2 = center2.x
        let y1 = center1.y
        let y2 = center2.y
        let cosθ = (y2 - y1) / d
        let sinθ = (x2 - x1) / d
        
        let A = CGPointMake(x1 - r1 * cosθ, y1 + r1 * sinθ)
        let B = CGPointMake(x1 + r1 * cosθ, y1 - r1 * sinθ)
        let C = CGPointMake(x2 + r2 * cosθ, y2 - r2 * sinθ)
        let D = CGPointMake(x2 - r2 * cosθ, y2 + r2 * sinθ)
        let O = CGPointMake(A.x + d / 2 * sinθ, A.y + d / 2 * cosθ)
        let P = CGPointMake(B.x + d / 2 * sinθ, B.y + d / 2 * cosθ)
        
        let path = UIBezierPath()
        path.moveToPoint(A)
        path.addLineToPoint(B)
        path.addQuadCurveToPoint(C, controlPoint: P)
        path.addLineToPoint(D)
        path.addQuadCurveToPoint(A, controlPoint: O)
        
        return path
    }
    
    
    //MARK: - 完成的动画
    private func startMissAnimationWithFrame(frame: CGRect) {
        let animationImageView = UIImageView()
        animationImageView.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame))
        animationImageView.size = CGSizeMake(68, 50)
        animationImageView.animationImages = images
        animationImageView.animationDuration = 0.5
        animationImageView.animationRepeatCount = 1;
        self.superview?.addSubview(animationImageView)
        animationImageView.startAnimating()
        let minseconds = 0.5 * Double(NSEC_PER_SEC)
        let dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(minseconds))
        dispatch_after(dtime, dispatch_get_main_queue()) { () -> Void in
            animationImageView.removeFromSuperview()
        }
    }
}

extension String {
    public func stringSizeWithFont(font: UIFont, maxWidth: CGFloat) -> CGSize? {
        let text = NSString(CString: (self.cStringUsingEncoding(NSUTF8StringEncoding))!, encoding: NSUTF8StringEncoding)
        let maxSize = CGSizeMake(maxWidth, CGFloat(MAXFLOAT))
        let size = text?.boundingRectWithSize(maxSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName : font], context: nil).size
        return size
    }
    
    public func stringSizeWithFont(font: UIFont) -> CGSize? {
        return self.stringSizeWithFont(font, maxWidth: CGFloat(MAXFLOAT))
    }
}
