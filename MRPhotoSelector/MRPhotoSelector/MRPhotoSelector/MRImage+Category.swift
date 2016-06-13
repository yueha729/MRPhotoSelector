//
//  MRImage+Category.swift
//  MRPhotoSelectorDemo
//
//  Created by 乐浩 on 16/6/1.
//  Copyright © 2016年 乐浩. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     根据传入的宽度生成一张图片
     按照图片的宽高比来压缩以前的图片
     - parameter width: 指定宽度
     - returns: 压缩后的图片
     */
    func imageWithScale(width: CGFloat) -> UIImage {
        
        //1. 知道宽度，根据图片的宽高比计算高度
        let heignt = size.height / size.width * width
        
        //2. 按照计算出来的高度和已知的宽度，重新绘制一张新的图片
        let currentSize = CGSize(width: width, height: heignt)
        
        //2.1 根据size新建绘制图片上下文
        UIGraphicsBeginImageContext(currentSize)
        drawInRect(CGRect(origin: CGPointZero, size: currentSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        // 关闭绘制图片上下文
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
