//
//  ImageExtension.swift
//  DriverApp
//
//  Created by Nirmal kumar on 04/09/25.
//

import SwiftUI

extension Image {
    
    func previewableImage() -> some View {
        
        self
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    
    func profileImage() -> some View {
        
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(.circle)
        
            .background(Circle().stroke(style: StrokeStyle(lineWidth: 5)).foregroundColor(.white))

    }
    
}


import UIKit
import CoreGraphics

extension UIImage {
    func withTextWatermark(drawText text: String) -> UIImage {
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: self.size))
        
        let textFont =  UIFont.systemFont(ofSize: 75, weight: .bold)
        let textColor = UIColor.white
        let maxWidthPercentage = 0.9
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        paragraphStyle.alignment = .left

        let textAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        let maxTextWidth = self.size.width * maxWidthPercentage
        let constrainedSize = CGSize(width: maxTextWidth, height: .greatestFiniteMagnitude)
        
        let actualTextSize = NSString(string: text).boundingRect(
            with: constrainedSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: textAttributes,
            context: nil
        ).size
        
        let drawRect = CGRect(
            x: 100,
            y: self.size.height - actualTextSize.height - 100,
            width: actualTextSize.width,
            height: actualTextSize.height
        )

        text.draw(in: drawRect, withAttributes: textAttributes)
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}



extension UIImage {
     func resized(to size: CGSize) -> UIImage {
         UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
         self.draw(in: CGRect(origin: .zero, size: size))
         let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return resizedImage ?? self
     }
 }


extension UIImage {
    func withColor(_ color: UIColor) -> UIImage? {
        let templateImage = self.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(templateImage.size, false, templateImage.scale)
        color.set()
        templateImage.draw(in: CGRect(x: 0, y: 0, width: templateImage.size.width, height: templateImage.size.height))
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage
    }
}
