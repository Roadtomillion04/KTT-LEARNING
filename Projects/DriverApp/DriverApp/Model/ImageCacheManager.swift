//
//  ImageCacheManager.swift
//  DriverApp
//
//  Created by Nirmal kumar on 05/11/25.
//

import Foundation
import SwiftUI


class ImageCacheManager: ObservableObject {
    
    static let shared = ImageCacheManager() // singleton
    
    @Published var cachedImages: [UIImage] = []
    
    var imageCache = NSCache<NSString, UIImage>()
    
    func save(name: String, image: UIImage) {
        imageCache.setObject(image, forKey: name as NSString)
        cachedImages.append(image)
    }
    
    func remove(name: String) {
        imageCache.removeObject(forKey: name as NSString)
    }
    
    func get(name: String) {
        cachedImages.append(imageCache.object(forKey: name as NSString) ?? UIImage())
    }
}
