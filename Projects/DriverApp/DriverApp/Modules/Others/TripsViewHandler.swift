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
            
        case .tripExpenses(.tripExpenses(let tripId, let assetId)):
            
            TripExpensesView(tripId: tripId, assetId: assetId)
                .navigationTitle(LocalizedStringKey("trip_expenses"))
         
            
        case .tripExpenses(.addTripsExpenses(let isEditing, let expenseId, let assetId, let tripId)):
            
            AddTripExpensesView(isEditing: isEditing, assetId: assetId, tripId: tripId, expenseId: expenseId ?? -1)
                .navigationTitle(LocalizedStringKey("add_trip_expenses"))
                .task {
                    do {
                        
                        if isEditing {
                            try await apiService.getTripExpense(expenseId!)
                        }
                        
                        try await apiService.getTripExpenseTypes()
                    } catch {
                        
                    }
                }
            
            
        case .tripAdvances(let advanceData):
            TripAdvanceView(data: advanceData)
                .navigationTitle(LocalizedStringKey("trip_advances"))
            
        }
        
    }
    
}

#Preview {
//    TripsViewHandler()
}
