//
//  OperatingExpensesView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/10/25.
//

import SwiftUI

struct OperatingExpensesView: View {
    
    @StateObject private var vm: OperatingExpensesViewModel = .init()
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    
    let zoneId: String
    let opExpenses: Trip.OpExpenses
    
    
    var body: some View {
        
        VStack(spacing: 10) {
        
            if opExpenses.floor {
                CustomTextField(icon: "numbers.rectangle.fill", title: "Floor No.", text: $vm.floorNo)
                    .formatDouble($vm.floorNo)
                    
            }
            
            if opExpenses.floor || opExpenses.headLoadingCharges {
                
                CustomTextField(icon: "scalemass.fill", title: "Actual weight (Kg)", text: $vm.actualWeight)
                    .formatDouble($vm.actualWeight)
            }
            
            if opExpenses.loadingCharges {
                
                CustomTextField(icon: "banknote.fill", title: "Loading Charge", text: $vm.loadingCharges)
                    .formatDouble($vm.loadingCharges)
                
            }
            
            if opExpenses.unloadingCharges {
                
                CustomTextField(icon: "banknote.fill", title: "Unloading Charge", text: $vm.unloadingCharges)
                    .formatDouble($vm.unloadingCharges)
            }
            
            Divider()
            
            if opExpenses.headLoadingCharges {
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    Text("Head Load Charges?")
                        .bold()
                    
                    HStack {
                        
                        
                        HStack {
                            Image(systemName: vm.selection == .yes ? "circle.fill" : "circle")
                            
                            
                            Text("Yes")
                        }
                        .font(.headline)
                        .onTapGesture {
                            vm.selection = .yes
                        }
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: vm.selection == .no ? "circle.fill" : "circle")
                            
                            Text("No")
                        }
                        .font(.headline)
                        .onTapGesture {
                            vm.selection = .no
                        }
                        
                        Spacer()
                        
                    }
                    .tint(.black)
                    
                }
                
            }
            
            Spacer()
            
            Button {
                
                Task {
                    do {
                        vm.isLoading = true
                        vm.success = try await apiService.uploadDocuments(docType: .op(floorNo: vm.floorNo, unloadingCharge: vm.unloadingCharges, loadingCharge: vm.loadingCharges, headChargeAvailable: vm.selection.rawValue, actualWeight: vm.actualWeight), zoneId: zoneId)
                        vm.isLoading = false
                        
                        try await apiService.getDriverStatus(cachePolicy: .reloadIgnoringCacheData)
                        try await apiService.getTripsData(cachePolicy: .reloadIgnoringCacheData)
                        
                    } catch {
                        vm.isLoading = false
                        vm.failed = true
                    }
                }
                
            } label: {
                Text("Save")
                    .modifier(SaveButtonModifier())
            }
            
        }
        .ignoresSafeArea(.keyboard) // stops pushing button up on keyboard
        .padding(.horizontal)


        .onAppear {
            // saved data, no weight received
            vm.loadingCharges = opExpenses.loadingCharge
            vm.unloadingCharges = opExpenses.unloadingCharge
            vm.selection = opExpenses.headChargeAvailable == "true" ? .yes : .no
            
        }

        .successAlert(success: $vm.success, failed: $vm.failed, message: "POD uploaded successfully", coordinator: coordinator)

    }
    
}


fileprivate class OperatingExpensesViewModel: ObservableObject {
    
    enum HeadLoadChargesSelection: String, CaseIterable {

        case yes = "true"
        case no = "false"
    }

    @Published var selection: HeadLoadChargesSelection = .no
    
    @Published var floorNo: String = ""
    @Published var loadingCharges: String = ""
    @Published var unloadingCharges: String = ""
    @Published var actualWeight: String = ""
    
    @Published var testStr = String(format: "%0.1f")
    
    @Published var success: Bool = false
    @Published var isLoading: Bool = false
    @Published var failed: Bool = false
    
}

#Preview {
//    OperatingExpensesView()
}
