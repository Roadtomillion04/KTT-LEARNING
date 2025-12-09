//
//  TripSettlementView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/09/25.
//

import SwiftUI

struct TripSettlementView: View {
    
    @StateObject private var vm: TripSettlementViewModel = .init()
    
    @EnvironmentObject private var apiService: APIService
    
    var body: some View {
    
        HStack {
                
            
        }
        .frame(height: 75)
        
        .searchable(text: $vm.searchText)
        
        .padding()
        
        .task {
            await vm.onAppear(apiService: apiService)
        }
    }
}


fileprivate class TripSettlementViewModel: ObservableObject {
    
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var searchText: String = ""
    
    func onAppear(apiService: APIService) async {
        do {
            try await apiService.getTripSheet()
        } catch {
            
        }
    }
    
}

struct TripSheetModel: Decodable {
    var success: Bool?
    var message: String?
}

#Preview {
//    TripSettlementView()
}
