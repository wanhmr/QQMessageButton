##Swift 模仿 QQ tabbarItem 的未读消息效果
###先看效果
> 借鉴了[这篇博客](http://www.jianshu.com/p/d5ea6c9d65fd)  
> 原博客使用的 OC 写的
> 在其基础上增加了一些功能, 比如能随着移动, size 也随着改变  

![animate.gif](http://upload-images.jianshu.io/upload_images/1200356-8c637652916ffc21.gif?imageMogr2/auto-orient/strip)

###如何实现
-  如上图, 效果是由一个大圆和一个小圆, 以及大圆、小圆之间的不规则图形组成的
- 控件继承了 UIButton, 给控件添加 pan 手势, 当开始移动的时候, 在原位置添加一个小圆， 然后通过下图的方法使用贝塞尔曲线实现中间的不规则图形
![0068uRu1gw1etgs1ssj09j30yg0qmaed.jpg](http://upload-images.jianshu.io/upload_images/1200356-fba2c85648022904.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###中间路径实现代码
```
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

//MARK: - 两点之间距离
    private func pointToPointDistanceWithPoint1(point1: CGPoint, point2: CGPoint) ->CGFloat {
        let xDistance = point2.x - point1.x
        let yDistance = point2.y - point1.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
```

###demo 地址
[请点击这里](https://github.com/wanhmr/QQMessageButton)
