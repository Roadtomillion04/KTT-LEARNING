//
//  TripExpensesView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 25/09/25.
//

import SwiftUI

struct TripExpensesView: View {
    
    @StateObject private var vm: TripExpensesViewModel = .init()
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    
    let tripId: Int
    let assetId: Int
    
    var body: some View {
            
        VStack {
            
            listExpenses()
            
        }
        
        .loadingScreen(isLoading: vm.isLoading)
        
        .successAlert(success: $vm.success, failed: $vm.failed, message: "Expense deleted successfully", coordinator: coordinator)

    }
    
    @ViewBuilder
    func listExpenses() -> some View {
        
        List {
            // display new data after new expense
            ForEach(apiService.tripsDataAttributes.results.filter( { $0.id == tripId } ).map( { $0.tripExpenses } ).first ?? [], id: \.self) { expense in
                
                LazyVGrid(columns: vm.columns, alignment: .leading, spacing: 25) {
                    
                    IconData(icon: "square.fill.text.grid.1x2", title: "Type", value: expense.type ?? "")
                    
                    IconData(icon: "newspaper.fill", title: "Bill Number", value: expense.details.billNumber ?? "-")
                    
                    IconData(icon: "calendar", title: "Expense Date", value: expense.date?.dateFormatting() ?? "")
                    
                    IconData(icon: "mappin", title: "Location", value: expense.location.name ?? "")
                    
                    // For Fuel extra fields
                    if let liters = expense.details.liters, !liters.isEmpty {
                        IconData(icon: "fuelpump.fill", title: "Liters", value: liters)
                    }
                    
                    if let costPerLiter = expense.details.costPerLiter, !costPerLiter.isEmpty {
                        IconData(icon: "banknote", title: "Cost Per Liter", value: costPerLiter)
                    }
                    
                    IconData(icon: "indianrupeesign", title: "Amount", value: expense.amount ?? "")
                    
                    IconData(icon: "creditcard.fill", title: "Payment Mode", value: expense.paymentMode ?? "")
                    
                    IconData(icon: "ellipsis.message.fill", title: "Comments", value: expense.comments ?? "")
                    
                    IconData(icon: "person.crop.circle.fill", title: "Created By", value: "\(expense.userIDCreatedBy ?? "N/A")")
                    
                    // Image, downloaded images there, in apiService
                
                    Section {
        
                        ForEach(expense.images, id: \.self) { image in
                            
                            ImagePreview(uiImage: image)
                           
                        }
                        
                        if expense.status == 3 {
                            
                            Text("Rejected")
                                .padding()
                                .foregroundStyle(.white)
                                .bold()
                                .background(RoundedRectangle(cornerRadius: 10).fill(.teal))
                            
                        }
                        
                        if expense.status == 1 {
                            
                            Text("Verified")
                                .padding()
                                .foregroundStyle(.white)
                                .bold()
                                .background(RoundedRectangle(cornerRadius: 10).fill(.green))
                            
                        }
                        
                        
                        if expense.status == 0 {
                            
                            VStack {
                                
                                Text("Delete")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .bold()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.red))
                                
                                    .onTapGesture {
                                        vm.deleteExpense(apiService: apiService, coordinator: coordinator, id: expense.id ?? -1)
                                    }
                                
                                Text("Pending")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .bold()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray3)))
                                
                            }
                            
                        }
                        
                        
                    } header: {
                        
                        IconData(icon: "square.and.arrow.up.fill", title: "Images", value: "")
                    }
                
    
                }
                .padding(.vertical)
                
                .onTapGesture {
                    coordinator.push(.trips(.tripExpenses(.addTripsExpenses(isEditing: true, expenseId: expense.id ?? -1, assetId: assetId, tripId: tripId))))
                }

                
            }
                
        }
        .listRowSpacing(15)
        .shadow(radius: 2)
        
        
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("+") {
                    coordinator.push(.trips(.tripExpenses(.addTripsExpenses(isEditing: false, assetId: assetId, tripId: tripId))))
                }
                .font(Font.custom("", size: 32))
                .tint(.white)
                
                .background(
                    Circle()
                        .fill(.teal)
                        .frame(width: 48, height: 48)
                )
            }
        }
        
    }
    
}

@MainActor
fileprivate class TripExpensesViewModel: ObservableObject {
    
    @Published var success: Bool = false
    @Published var isLoading: Bool = false
    @Published var failed: Bool = false
    
    let columns = [
                GridItem(.flexible(), spacing: 40),
                GridItem(.flexible())
            ]


    func deleteExpense(apiService: APIService, coordinator: AppCoordinator, id: Int) {
        
        Task {
            do {
                isLoading = true
                try await apiService.deleteExpenese(expenseId: id)
                
                try await apiService.getTripsData(cachePolicy: .reloadIgnoringLocalCacheData)
                
                success = true
                isLoading = false
        
                
            } catch {
                isLoading = failed
                failed = true
            }
        }
        
    }
    
    
}

#Preview {
//    TripExpensesView()
}



           
