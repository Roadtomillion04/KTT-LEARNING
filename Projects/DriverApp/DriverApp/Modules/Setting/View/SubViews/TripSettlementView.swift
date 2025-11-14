//
//  TripSettlementView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/09/25.
//

import SwiftUI

struct TripSettlementView: View {
    
    @StateObject private var vm: TripSettlementViewModel = .init()
    
    var body: some View {
    
        HStack {
                
            DatePicker("START", selection: $vm.startDate, displayedComponents: .date)
            
            Divider()
            
            DatePicker("END", selection: $vm.endDate, displayedComponents: .date)
            
        }
        .frame(height: 75)
        
        .searchable(text: $vm.searchText)
        
        Spacer()
        
        
    }
}


fileprivate class TripSettlementViewModel: ObservableObject {
    
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var searchText: String = ""
    
}



#Preview {
//    TripSettlementView()
}
