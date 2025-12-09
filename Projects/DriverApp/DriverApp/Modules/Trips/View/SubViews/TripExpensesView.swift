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
    let startDate: String
    let endDate: String
       
    var body: some View {
        
        VStack {
            
            listExpenses()
            
        }
        
        .refreshable {
            vm.isLoading = true
            do {
                try await apiService.getTripsData(startDate: startDate, endDate: endDate)
            } catch {
                
            }
            vm.isLoading = false
            
            vm.expenseList = apiService.tripsDataModel.results.filter( { $0.id == tripId } ).map( { $0.tripExpenses } ).first ?? []
        }
        
        .loadingScreen(isLoading: vm.isLoading)
        
        .successAlert(success: $vm.success, message: "Expense deleted successfully", coordinator: coordinator)
        
        .task {
            vm.expenseList = apiService.tripsDataModel.results.filter( { $0.id == tripId } ).map( { $0.tripExpenses } ).first ?? []
            
        }
        
    }
    
    @ViewBuilder
    func listExpenses() -> some View {
        
        List {
            // display new data after new expense
            ForEach(vm.expenseList, id: \.self) { expense in
                
                LazyVGrid(columns: vm.columns, alignment: .leading, spacing: 25) {
                    
                    IconData(icon: "square.fill.text.grid.1x2", title: LocalizedStringResource("type"), value: expense.type ?? "")
                    
                    IconData(icon: "newspaper.fill", title: LocalizedStringResource("bill_no"), value: expense.details?.billNumber ?? "-")
                    
                    IconData(icon: "calendar", title: LocalizedStringResource("expense_date"), value: expense.date?.dateFormatting() ?? "")
                    
                    IconData(icon: "mappin", title: LocalizedStringResource("location"), value: expense.location?.name ?? "")
                    
                    // For Fuel extra fields
                    if let liters = expense.details?.liters, !liters.isEmpty {
                        IconData(icon: "fuelpump.fill", title: LocalizedStringResource("liters"), value: liters)
                    }
                    
                    if let costPerLiter = expense.details?.costPerLiter, !costPerLiter.isEmpty {
                        IconData(icon: "banknote", title: LocalizedStringResource("cost_per_liter"), value: costPerLiter)
                    }
                    
                    IconData(icon: "indianrupeesign", title: LocalizedStringResource("amount"), value: expense.amount ?? "")
                    
                    IconData(icon: "creditcard.fill", title: LocalizedStringResource("payment_mode"), value: expense.paymentMode ?? "")
                    
                    IconData(icon: "ellipsis.message.fill", title: LocalizedStringResource("comments"), value: expense.comments ?? "")
                    
                    IconData(icon: "person.crop.circle.fill", title: LocalizedStringResource("created_by"), value: "\((expense.userIdCreatedBy != nil) ? String(expense.userIdCreatedBy!) : "N/A")")
                    
                    // Image, downloaded images there, in apiService
                
                    Section {
        
                        ForEach(expense.images, id: \.self) { imageURL in
                            
                            ImagePreview(imageUrl: imageURL)
                           
                        }
                        
                        if expense.status == 3 {
                            
                            Text(LocalizedStringResource("rejected"))
                                .font(Font.custom("ArialRoundedMTBold", size: 13))
                                .padding()
                                .foregroundStyle(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.teal))
                            
                        }
                        
                        if expense.status == 1 {
                            
                            Text("Verified")
                                .font(Font.custom("ArialRoundedMTBold", size: 13))
                                .padding()
                                .foregroundStyle(.white)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.green))
                            
                        }
                        
                        
                        if expense.status == 0 {
                            
                            VStack {
                                
                                Text(LocalizedStringResource("delete"))
                                    .font(Font.custom("ArialRoundedMTBold", size: 13))
                                    .padding()
                                    .foregroundStyle(.white)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(.red))
                                
                                    .onTapGesture {
                                        vm.confirmDelete = true
                                        vm.expenseId = expense.id ?? -1
                                    }
                                
                                    .alert("delete_message", isPresented: $vm.confirmDelete) {
                                        
                                        Button(LocalizedStringKey("yes")) {
                                            Task {                                                await vm.deleteExpense(apiService: apiService, coordinator: coordinator, id: vm.expenseId)
                                            }
                                        }
                                        
                                        Button(LocalizedStringKey("no"), role: .cancel) {
                                            
                                        }
                                        
                                    }
  
                                
                                Text("Pending")
                                    .font(Font.custom("ArialRoundedMTBold", size: 13))
                                    .padding()
                                    .foregroundStyle(.white)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray3)))
                                
                                    .onTapGesture {
                                        coordinator.push(.trips(.tripExpenses(.addTripsExpenses(isEditing: true, expenseId: expense.id ?? -1, tripId: tripId, assetId: assetId, startDate: startDate, endDate: endDate))))
                                    }
                                
                            }
                            
                        }
                        
                        
                    } header: {
                        
                        IconData(icon: "square.and.arrow.up.fill", title: LocalizedStringResource("image"), value: "")
                    }
                
    
                }
                .padding(.vertical)
                
            }
                
        }
        .listRowSpacing(15)
        .shadow(radius: 2)
        
        
        .toolbar {
            
            ToolbarItem(placement: .bottomBar) {
                
                Button("+") {
                    coordinator.push(.trips(.tripExpenses(.addTripsExpenses(isEditing: false, expenseId: nil, tripId: tripId, assetId: assetId, startDate: startDate, endDate: endDate))))
                }
                .font(Font.custom("", size: 30))
                .tint(.white)
                
                .background(
                    Circle()
                        .fill(.teal)
                        .frame(width: 42, height: 42)
                )
            }
        }
        
    }
    
}

@MainActor
fileprivate class TripExpensesViewModel: ObservableObject {
    
    @Published var success: Bool = false
    @Published var isLoading: Bool = false
    
    @Published var confirmDelete: Bool = false
    
    let columns = [
                GridItem(.flexible(), spacing: 40),
                GridItem(.flexible())
            ]
    
    @Published var expenseId: Int = 0 // to hold data on delete in alert, otherwise as known alert not updating

    @Published var expenseList: [APIService.TripsDataModel.TripExpense] = []

    func deleteExpense(apiService: APIService, coordinator: AppCoordinator, id: Int) async {
   
        do {
            isLoading = true
            
            try await apiService.deleteExpenese(expenseId: id)
            
            isLoading = false
            
        } catch {
            isLoading = false
        }
    }
    
}

#Preview {
    //    TripExpensesView()
}
