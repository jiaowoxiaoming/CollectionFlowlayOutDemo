//
//  XMInvertedImageView.swift
//  API
//
//  Created by 郭建斌 on 16/5/17.
//  Copyright © 2016年 郭建斌. All rights reserved.
//

import UIKit

class XMInvertedImageView: UIView {

    //倒影跟原图的距离
//    var reflectionGap:CGFloat = 0.0
    
    lazy var reflectionImageView:UIImageView = {
       
        var imageView:UIImageView = UIImageView.init(frame: self.bounds)
        
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        imageView.clipsToBounds = true
        
        self.addSubview(imageView)
        
        return imageView
    }()
    
    var reflectionGap: CGFloat = 0.0 {
//        willSet(newValue) {
//            
//        }
        didSet {
            
            self.setNeedsLayout()
        } 
    } 

    //呈现出倒影的比例
    var reflectionScale:CGFloat = 0.0
        {
//        willSet(newValue) {
//            
//        }
        didSet {
            self.setNeedsLayout()
        }
    } 

    //倒影的透明度
    var reflectionAlpha:CGFloat = 0.0
        {
//        willSet(newValue) {
//            
//        }
        didSet {
            self.setNeedsLayout()
        }
    } 

    
    var dynamic:Bool = false
    
    lazy var gradientLayer:CAGradientLayer = {
        
        let layer = CAGradientLayer()
        
        layer.colors = [UIColor.blackColor().CGColor,UIColor.blackColor().CGColor,UIColor.clearColor().CGColor]
        
        return layer
    }()
    
    override class func layerClass() -> AnyClass
    {
        return CAReplicatorLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setUp()
    }
    
    override func awakeFromNib() {
       
        self.setUp()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.update()
        
    }
    
    func setUp() -> Void {
//        配置初始值
        reflectionGap = 4.0;
        reflectionScale = 0.5;
        reflectionAlpha = 0.5;
//        调整布局
        self.setNeedsLayout()

    }
    
    
    
    func update() -> Void {
       let layer:CAReplicatorLayer = self.layer as! CAReplicatorLayer
        if !dynamic {
            
            self.reflectionImageView.removeFromSuperview()
//            self.reflectionImageView = nil
            
//            layer.contents = UIImage(imageLiteral: "girl").CGImage
            // 光栅化
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.mainScreen().scale
            layer.instanceCount = 2
            
            var transform:CATransform3D = CATransform3DIdentity
                
            transform = CATransform3DTranslate(transform, 0.0, layer.bounds.size.height + reflectionGap, 0.0)
            
            transform = CATransform3DScale(transform, 1.0, -1.0, 0.0)
            
//            transform = CATransform3DRotate(transform, CGFloat(M_PI / 2), 4, 0, 5)
//
////            transform = CATransform3DScale(transform, 1.0, -2.0, 0.0)
////            transform = CATransform3DTranslate(transform, 30, 0, 0)
            layer.instanceTransform = transform
            layer.instanceAlphaOffset = Float(reflectionAlpha - 1.0)
            
            layer.mask = gradientLayer
            
            let total = layer.bounds.size.height * 2.0 + reflectionGap
            
            let halfWay = (layer.bounds.size.height + reflectionGap) / total - 0.01
            
            
            gradientLayer.frame = CGRectMake(0.0, 0.0, self.bounds.size.width, total)
            gradientLayer.locations = [NSNumber.init(float: 0.0),NSNumber.init(float: Float(halfWay)),NSNumber.init(float: Float(halfWay + (1.0 - halfWay) * reflectionScale))]
            
            
        }
        else
        {
            self.layer.mask = nil
            
//            self.gradientLayer = nil
            
            layer.shouldRasterize = false
            layer.instanceCount = 1
            
            let size = CGSizeMake(self.bounds.size.width, self.bounds.size.height * reflectionScale)
            
            if (size.height > 0.0 && size.width > 0.0)
            {
                
                UIGraphicsBeginImageContextWithOptions(size, true, 0.0);
                let gradientContext = UIGraphicsGetCurrentContext();
                let colors = [CGFloat(1.0), 1.0, 0.0, 1.0]
                let colorSpace = CGColorSpaceCreateDeviceGray();
                let gradient = CGGradientCreateWithColorComponents(colorSpace,colors , nil, 2);
                let gradientStartPoint = CGPointMake(0.0, 0.0);
                let gradientEndPoint = CGPointMake(0.0, size.height);
                CGContextDrawLinearGradient(gradientContext, gradient, gradientStartPoint,
                                            gradientEndPoint, CGGradientDrawingOptions.DrawsAfterEndLocation);
                let gradientMask = CGBitmapContextCreateImage(gradientContext);
                
//                CGGradientRelease(gradient);
                
//                CGColorSpaceRelease(colorSpace);
                
                UIGraphicsEndImageContext();
                
                //取出当前上下文 并旋转上下文
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
                let context = UIGraphicsGetCurrentContext();
                CGContextScaleCTM(context, 1.0, -1.0);
                CGContextTranslateCTM(context, 0.0, -self.bounds.size.height);
                
                //增加遮罩
                CGContextClipToMask(context, CGRectMake(0.0, self.bounds.size.height - size.height,
                    size.width, size.height), gradientMask);
//                CGImageRelease(gradientMask);
                
                //draw reflected layer content
              
                self.layer.renderInContext(context!)
                //capture resultant image
                reflectionImageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            
            //update reflection
            reflectionImageView.alpha = reflectionAlpha;
            reflectionImageView.frame = CGRectMake(0, self.bounds.size.height + reflectionGap, size.width, size.height);
            
//            reflectionImageView.layer.transform = CATransform3DMakeTranslation(20, 0, 30)
            
        }
    }
    
   
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
