//
//  UIViewExtension.swift
//  CoreAnimation
//
//  Created by Tpphha on 16/2/29.
//  Copyright © 2016年 tpphha. All rights reserved.
//

import UIKit

extension UIView {
    public var width: CGFloat {
        get {
            return CGRectGetWidth(self.bounds)
        }
        
        set {
            self.frame.size.width = newValue
        }
    }
    
    public var height: CGFloat {
        get {
            return CGRectGetHeight(self.bounds)
        }
        
        set {
            self.bounds.size.height = newValue
        }
    }
    
    public var size: CGSize {
        get {
            return self.bounds.size
        }
        
        set {
            //为什么用 frame 不可以呢
            self.bounds.size = newValue
        }
    }
    
    public var origin: CGPoint {
        get {
            return self.frame.origin
        }
        
        set {
            self.frame.origin = newValue
        }
    }
    
    public var x: CGFloat {
        get {
            return self.origin.x
        }
        
        set {
            self.origin.x = newValue
        }
    }
    
    public var y: CGFloat {
        get {
            return self.origin.y
        }
        
        set {
            self.origin.y = newValue
        }
    }
    
    public var maxX: CGFloat {
        return CGRectGetMaxX(self.frame)
    }
    
    public var maxY: CGFloat {
        return CGRectGetMaxY(self.frame)
    }
}

