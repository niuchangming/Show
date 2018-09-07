//
//  UIImage+NDImage.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/9/7.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit
import Accelerate.vImage

extension UIImage {
    
    public func circleImage() -> UIImage {
        let size = self.size
        let drawWH = size.width < size.height ? size.width : size.height
        
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(CGSize.init(width: drawWH, height: drawWH))
        // 2. 绘制一个圆形区域, 进行裁剪
        let context = UIGraphicsGetCurrentContext()
        let clipRect = CGRect.init(x: 0, y: 0, width: drawWH, height: drawWH)
        context!.addEllipse(in: clipRect)
        context?.clip();
        
        // 3. 绘制图片
        let drawRect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
        self.draw(in: drawRect)
        
        // 4. 取出结果图片
        let resultImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext();
        
        return resultImage!;
    }
    
    /** 将当前图片缩放到指定宽度
 
        parameter height: 指定宽度
 
        returns: UIImage，如果本身比指定的宽度小，直接返回
    */
    func scaleImageToWidth(_ width: CGFloat) -> UIImage {
        
        // 1. 判断宽度，如果小于指定宽度直接返回当前图像
        if size.width < width {
            return self
        }
        
        // 2. 计算等比例缩放的高度
        let height = width * size.height / size.width
        
        // 3. 图像的上下文
        let s = CGSize(width: width, height: height)
        // 提示：一旦开启上下文，所有的绘图都在当前上下文中
        UIGraphicsBeginImageContext(s)
        
        // 在制定区域中缩放绘制完整图像
        draw(in: CGRect(origin: CGPoint.zero, size: s))
        
        // 4. 获取绘制结果
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // 5. 关闭上下文
        UIGraphicsEndImageContext()
        
        // 6. 返回结果
        return result!
    }
    
    /**
        图片模糊效果处理
        高斯模糊
     */
    func gaussianBlur(blurAmount:CGFloat) -> UIImage {
        let context = CIContext(options: nil)
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: self)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(blurAmount, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
    
}
