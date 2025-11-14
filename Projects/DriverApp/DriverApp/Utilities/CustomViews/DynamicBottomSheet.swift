//
//  DynamicBottomSheet.swift
//  DriverApp
//
//  Created by Nirmal kumar on 23/10/25.
//

// credit - https://www.svpdigitalstudio.com/blog/dynamic-bottom-sheet-height-based-on-content-inside


import SwiftUI

struct AdaptableHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}


struct AdaptableHeightModifier: ViewModifier {
    @Binding var currentHeight: CGFloat

    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: AdaptableHeightPreferenceKey.self, value: geometry.size.height)
        }
    }

    func body(content: Content) -> some View {
        content
            .background(sizeView)
            .onPreferenceChange(AdaptableHeightPreferenceKey.self) { height in
                if let height {
                    currentHeight = height
                }
            }
    }
}


extension View {
    func setDynamicHeight(_ height: Binding<CGFloat>) -> some View {
        self.modifier(AdaptableHeightModifier(currentHeight: height))
    }
}



#Preview {
//    DynamicBottomSheet()
}
