//import SwiftUI
//
//struct CustomFontSize {
//    let small: CGFloat
//    let smallMedium: CGFloat
//    let medium: CGFloat
//    let mediumLarge: CGFloat
//    let large: CGFloat
//    let extraLarge: CGFloat
//    
//    init(height: CGFloat, width: CGFloat) {
//        let widthToCalculate = width
//        switch widthToCalculate {
//        case 0..<375: // iPhone SE (4.7 inch)
//            small = 8
//            smallMedium = 11
//            medium = 15
//            mediumLarge = 19
//            large = 21
//            extraLarge = 33
//        case 375..<414: // iPhone 11, 12, 13, 14 (6.1 inch)
//            small = 9
//            smallMedium = 12
//            medium = 16
//            mediumLarge = 20
//            large = 22
//            extraLarge = 34
//        case 414..<768: // iPhone 16 Pro Max (6.7 inch)
//            small = 10
//            smallMedium = 13
//            medium = 17
//            mediumLarge = 21
//            large = 23
//            extraLarge = 35
//        default: // iPads and larger devices
//            small = 12
//            smallMedium = 15
//            medium = 20
//            mediumLarge = 24
//            large = 26
//            extraLarge = 40
//        }
//    }
//}
//
//struct CustomDimensValues {
//    let small: CGFloat
//    let smallMedium: CGFloat
//    let medium: CGFloat
//    let mediumLarge: CGFloat
//    let large: CGFloat
//    let extraLarge: CGFloat
//    
//    init(height: CGFloat, width: CGFloat) {
//        let widthToCalculate = width
//        switch widthToCalculate {
//        case 0..<375: // iPhone SE (4.7 inch)
//            small = 7
//            smallMedium = 10
//            medium = 12
//            mediumLarge = 15
//            large = 17
//            extraLarge = 22
//        case 375..<414: // iPhone 11, 12, 13, 14 (6.1 inch)
//            small = 8
//            smallMedium = 11
//            medium = 14
//            mediumLarge = 17
//            large = 19
//            extraLarge = 24
//        case 414..<768: // iPhone 16 Pro Max (6.7 inch)
//            small = 9
//            smallMedium = 12
//            medium = 15
//            mediumLarge = 18
//            large = 20
//            extraLarge = 26
//        default: // iPads and larger devices
//            small = 10
//            smallMedium = 13
//            medium = 16
//            mediumLarge = 20
//            large = 22
//            extraLarge = 30
//        }
//    }
//}
//
//struct LayoutProperties {
//    var dimensValues: CustomDimensValues
//    var customFontSize: CustomFontSize
//    var height: CGFloat
//    var width: CGFloat
//}
//
//func getPreviewLayoutProperties() -> LayoutProperties {
//    let screenSize = UIScreen.main.bounds.size
//    let height = screenSize.height
//    let width = screenSize.width
//    
//    return LayoutProperties(
//        dimensValues: CustomDimensValues(height: height, width: width),
//        customFontSize: CustomFontSize(height: height, width: width),
//        height: height,
//        width: width
//    )
//}
//
//
