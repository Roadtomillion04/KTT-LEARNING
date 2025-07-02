//
//  ResponsiveView.swift
//  MyApp2
//
//  Created by Nirmal kumar on 20/06/25.
//

// credit - https://github.com/MatthiasKerat/SupportDifferentScreensSwiftUI

// and also Blackbox AI for helping out with numbers


import SwiftUI

// I am not sure how pratical is to create size list that is universal fitting every view, for now I'll create individual sizing for every view

struct UserLoginViewCustomFontSize {
    
    var tiny: CGFloat
    var small: CGFloat
    var smallMedium: CGFloat
    var medium: CGFloat
    var mediumLarge: CGFloat
    var large: CGFloat
    var extraLarge: CGFloat
    
    init(height: CGFloat, width: CGFloat) {
        // Base all sizes on screen dimensions for better responsiveness
//        let scaleFactor = min(height / 667, width / 375) // Use both height and width for scaling, width helps in landscape
        
        tiny = 16 // fixed for smallFont
        
        // okay this small is going to be used on Landscape, so setting dimensValue 20 fits everything for RegisterView
        small = 19 //* scaleFactor
        
        smallMedium = 26 //* scaleFactor
        medium = 30 //* scaleFactor
        mediumLarge = 34 //* scaleFactor
        large = 38 //* scaleFactor
        extraLarge = 50 //* scaleFactor
        
    }
}

struct UserLoginViewCustomDimensValues {
    
    var small: CGFloat
    var smallMedium: CGFloat
    var medium: CGFloat
    var mediumLarge: CGFloat
    var large: CGFloat
    var extraLarge: CGFloat
    
    init(height: CGFloat, width: CGFloat) {
        
//        let scaleFactor = min(height / 667, width / 375)
        
        small = 20 //* scaleFactor
        
        smallMedium = 28 //* scaleFactor
        medium = 32 //* scaleFactor
        mediumLarge = 36 //* scaleFactor
        large = 40 //* scaleFactor
        extraLarge = 54 //* scaleFactor
   
    }
}


struct UserLoginViewLayoutProperties {
    
    var dimensValues: UserLoginViewCustomDimensValues
    var customFontSize: UserLoginViewCustomFontSize
    var height: CGFloat
    var width: CGFloat
}

func UserLoginViewgetPreviewLayoutProperties() -> UserLoginViewLayoutProperties {
    
    let screenSize = UIScreen.main.bounds.size
    let height = screenSize.height
    let width = screenSize.width
    
    return UserLoginViewLayoutProperties(
        dimensValues: UserLoginViewCustomDimensValues(height: height, width: width),
        customFontSize: UserLoginViewCustomFontSize(height: height, width: width),
        height: height,
        width: width
    )
}








// User Register View has more fields so these properties are fitting for Iphone Se (4.7 Inch)
struct UserRegisterViewCustomFontSize {
    
    var small: CGFloat
    var smallMedium: CGFloat
    var medium: CGFloat
    var mediumLarge: CGFloat
    var large: CGFloat
    var extraLarge: CGFloat
    
    init(height: CGFloat, width: CGFloat) {
        // Base all sizes on screen dimensions for better responsiveness
        let scaleFactor = min(height / 667, width / 375) // Use both height and width for scaling, width helps in landscape
        
        // okay this small is going to be used on Landscape, so setting dimensValue 20 fits everything for RegisterView
        small = 19 * scaleFactor
        
        
        smallMedium = 22 * scaleFactor
        medium = 28 * scaleFactor
        mediumLarge = 30 * scaleFactor
        large = 34 * scaleFactor
        extraLarge = 40 * scaleFactor
    }
}

struct UserRegisterViewCustomDimensValues {
    
    var small: CGFloat
    var smallMedium: CGFloat
    var medium: CGFloat
    var mediumLarge: CGFloat
    var large: CGFloat
    var extraLarge: CGFloat
    
    init(height: CGFloat, width: CGFloat) {
        let scaleFactor = min(height / 667, width / 375)
        
        small = 20 * scaleFactor
        
        
        smallMedium = 28 * scaleFactor
        medium = 32 * scaleFactor
        mediumLarge = 36 * scaleFactor
        large = 40 * scaleFactor // Increased for better usability
        extraLarge = 44 * scaleFactor // Increased for better usability
    }
}


struct UserRegisterViewLayoutProperties {
    
    var dimensValues: UserRegisterViewCustomDimensValues
    var customFontSize: UserRegisterViewCustomFontSize
    var height: CGFloat
    var width: CGFloat
    
}

func UserRegisterViewgetPreviewLayoutProperties() -> UserRegisterViewLayoutProperties {
    
    let screenSize = UIScreen.main.bounds.size
    let height = screenSize.height
    let width = screenSize.width
    
    return UserRegisterViewLayoutProperties(
        dimensValues: UserRegisterViewCustomDimensValues(height: height, width: width),
        customFontSize: UserRegisterViewCustomFontSize(height: height, width: width),
        height: height,
        width: width
    )
    
}

