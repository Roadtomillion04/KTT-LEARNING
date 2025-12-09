//
//  TripsViewHandler.swift
//  DriverApp
//
//  Created by Nirmal kumar on 25/09/25.
//

import SwiftUI

struct TripsViewHandler: View {
    
    @EnvironmentObject private var apiService: APIService
    
    @State var tripPath: TripRoute
    
    var body: some View {
    
        switch tripPath {
                        
        case .tripExpenses(.tripExpenses(let tripId, let assetId, let startDate, let endDate)):
                
            TripExpensesView(tripId: tripId, assetId: assetId, startDate: startDate, endDate: endDate)
                .navigationTitle(LocalizedStringKey("trip_expenses"))
         
            
        case .tripExpenses(.addTripsExpenses(let isEditing, let expenseId, let tripId, let assetId, let startDate, let endDate)):
                
            AddTripExpensesView(isEditing: isEditing, tripId: tripId, assetId: assetId, expenseId: expenseId ?? -1, startDate: startDate, endDate: endDate)
                    .navigationTitle(LocalizedStringKey("add_trip_expenses"))
            
        case .tripAdvances(let advanceData):
            TripAdvanceView(data: advanceData)
                .navigationTitle(LocalizedStringKey("trip_advances"))
            
        }
        
    }
    
}

#Preview {
//    TripsViewHandler()
}
