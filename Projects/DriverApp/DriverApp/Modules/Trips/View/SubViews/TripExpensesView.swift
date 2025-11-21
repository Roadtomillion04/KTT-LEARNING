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
                    
                    IconData(icon: "square.fill.text.grid.1x2", title: LocalizedStringResource("type"), value: expense.type ?? "")
                    
                    IconData(icon: "newspaper.fill", title: LocalizedStringResource("bill_no"), value: expense.details.billNumber ?? "-")
                    
                    IconData(icon: "calendar", title: LocalizedStringResource("expense_date"), value: expense.date?.dateFormatting() ?? "")
                    
                    IconData(icon: "mappin", title: LocalizedStringResource("location"), value: expense.location.name ?? "")
                    
                    // For Fuel extra fields
                    if let liters = expense.details.liters, !liters.isEmpty {
                        IconData(icon: "fuelpump.fill", title: LocalizedStringResource("liters"), value: liters)
                    }
                    
                    if let costPerLiter = expense.details.costPerLiter, !costPerLiter.isEmpty {
                        IconData(icon: "banknote", title: LocalizedStringResource("cost_per_liter"), value: costPerLiter)
                    }
                    
                    IconData(icon: "indianrupeesign", title: LocalizedStringResource("amount"), value: expense.amount ?? "")
                    
                    IconData(icon: "creditcard.fill", title: LocalizedStringResource("payment_mode"), value: expense.paymentMode ?? "")
                    
                    IconData(icon: "ellipsis.message.fill", title: LocalizedStringResource("comments"), value: expense.comments ?? "")
                    
                    IconData(icon: "person.crop.circle.fill", title: LocalizedStringResource("created_by"), value: "\(expense.userIDCreatedBy ?? "N/A")")
                    
                    // Image, downloaded images there, in apiService
                
                    Section {
        
                        ForEach(expense.images, id: \.self) { image in
                            
                            ImagePreview(uiImage: image)
                           
                        }
                        
                        if expense.status == 3 {
                            
                            Text(LocalizedStringResource("rejected"))
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
                                
                                Text(LocalizedStringResource("delete"))
                                    .padding()
                                    .foregroundStyle(.white)
                                    .bold()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.red))
                                
                                    .onTapGesture {
                                        vm.confirmDelete = true
                                    }
                                
                                    .alert("delete_message", isPresented: $vm.confirmDelete) {
                                        Button(LocalizedStringKey("yes")) {
                                            vm.deleteExpense(apiService: apiService, coordinator: coordinator, id: expense.id ?? -1)
                                        }
                                        
                                        Button(LocalizedStringKey("no"), role: .cancel) {
                                            
                                        }
                                    }
                                    
                                
                                Text("Pending")
                                    .padding()
                                    .foregroundStyle(.white)
                                    .bold()
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray3)))
                                
                            }
                            
                        }
                        
                        
                    } header: {
                        
                        IconData(icon: "square.and.arrow.up.fill", title: LocalizedStringResource("image"), value: "")
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
    
    @Published var confirmDelete: Bool = false
    
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



           
