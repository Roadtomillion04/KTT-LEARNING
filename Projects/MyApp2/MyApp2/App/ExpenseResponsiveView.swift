

import SwiftUI


struct ExpenseViewCustomFontSize {
    
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

struct ExpenseViewCustomDimensValues {
    
    var small: CGFloat
    var smallMedium: CGFloat
    var medium: CGFloat
    var mediumLarge: CGFloat
    var large: CGFloat
    var extraLarge: CGFloat
    
    init(height: CGFloat, width: CGFloat) {
        
//        let scaleFactor = min(height / 667, width / 375)
        
        small = 20
        
        smallMedium = 28
        medium = 32
        mediumLarge = 36
        large = 40
        extraLarge = 54
   
    }
}


struct ExpenseViewLayoutProperties {
    
    var dimensValues: ExpenseViewCustomDimensValues
    var customFontSize: ExpenseViewCustomFontSize
    var height: CGFloat
    var width: CGFloat
    
}

func ExpenseViewgetPreviewLayoutProperties() -> ExpenseViewLayoutProperties {
    
    let screenSize = UIScreen.main.bounds.size
    let height = screenSize.height
    let width = screenSize.width
    
    return ExpenseViewLayoutProperties(
        dimensValues: ExpenseViewCustomDimensValues(height: height, width: width),
        customFontSize: ExpenseViewCustomFontSize(height: height, width: width),
        height: height,
        width: width
    )
}
