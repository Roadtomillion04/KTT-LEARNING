//
//  TripsView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI
import Foundation

struct TripsView: View {
    
    @StateObject private var vm: TripsViewModel = .init()
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    

    var body: some View {
        
        VStack {
            
            HStack {
                
                VStack(alignment: .leading) {
                    Text("From")
                    
                    DatePicker("From", selection: $vm.startDate, displayedComponents: .date)
                        .labelsHidden()
                    
                        .onChange(of: vm.startDate) { old, new in
                            
                            Task {
                                
                                do {
                                    
                                    try await apiService.getTripsData(startDate: new.toString(), endDate: vm.endDate.toString())
                                    
                                } catch {
                                    
                                }
                            }
                        }
                    
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("To")
                    
                    DatePicker("To", selection: $vm.endDate, displayedComponents: .date)
                        .labelsHidden()
                    
                        .onChange(of: vm.endDate) { old, new in
                            
                            Task {
                                do {
                                    try await apiService.getTripsData(startDate: vm.startDate.toString(), endDate: new.toString())
                                } catch {
                                    
                                }
                            }
                            
                        }
                    
                }
            }
            
            
            HStack {
                
                Spacer()
                
                VStack {
                    
                    Text("Total Advances")
                        .foregroundStyle(Color(.systemGray))
                    
                    Text("₹\(apiService.tripsDataAttributes.totalAdvances?.round() ?? "")")
                        .bold()
                }
                
                Spacer()
                
                VStack {
                    
                    Text("Total Expenses")
                        .foregroundStyle(Color(.systemGray))
                    
                    Text("₹\(apiService.tripsDataAttributes.totalExpenses?.round() ?? "")")
                        .bold()
                }
                
                Spacer()
            }
            
            ScrollView {
                
                ForEach(apiService.tripsDataAttributes.results.sorted(by: { $0.id ?? 0 > $1.id ?? 0 }), id: \.id) { data in
                    tripsListContent(
                        id: data.id ?? -1,
                        assetId: data.assetID ?? -1,
                        vehicleNumber: data.vehicle ?? "",
                        startOdo: data.odo ?? "0", route: data.route ?? "",
                        loadingIn: data.loadIn?.dateFormatting() ?? "-",
                        loadingOut: data.loadOut?.dateFormatting() ?? "-",
                        unloadingIn: data.unloadIn?.dateFormatting() ?? "-",
                        unloadingOut: data.unloadOut?.dateFormatting() ?? "-", status: data.status ?? -1, statusAccounts: data.statusAccounts ?? -1,
                        tripAdvances: data.tripAdvances,
                        tripExpenses: data.tripExpenses
                    )
                }
                
            }
            .scrollIndicators(.hidden)
                        
        }
        .padding(.horizontal)
        
        .refreshable {
            Task {
                try await apiService.getTripsData(startDate: vm.startDate.toString(), endDate: vm.endDate.toString(), cachePolicy: .reloadIgnoringLocalCacheData)
            }
        }
        
    }
    
    
    @ViewBuilder
    private func tripsListContent(id: Int, assetId: Int, vehicleNumber: String, startOdo: String, route: String, loadingIn: String, loadingOut: String, unloadingIn: String, unloadingOut: String, status: Int, statusAccounts: Int, tripAdvances: [APIService.TripsDataAttributes.TripAdvance], tripExpenses: [APIService.TripsDataAttributes.TripExpense]) -> some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Section {
                
                HStack {
                    
                    VStack(spacing: 5) {
                        Text("Start ODO")
                            .font(Font.custom("AriSanPro-Medium", size: 15))
                            .foregroundStyle(Color(.systemGray))
                        
                        Text(startOdo)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5)  {
                        Text("End ODO")
                            .font(Font.custom("AriSanPro-Medium", size: 15))
                            .foregroundStyle(Color(.systemGray))

                        Text("0")
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5)  {
                        Text("Distance")
                            .font(Font.custom("AriSanPro-Medium", size: 15))
                            .foregroundStyle(Color(.systemGray))

                        Text("0")
                    }
                    
                }
            } header: {
                HStack(spacing: 15) {
                    Image(systemName: "truck.box.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                        
                    
                    Text(vehicleNumber)
            
                }
            }
            
            Divider()
                
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .foregroundStyle(.blue)
                
                Text("Ref No:-")
            }
            
            HStack {
                Image(systemName: "location.north.fill")
                    .foregroundStyle(.blue)
                
                Text(route)
                    .font(Font.custom("Monaco", size: 16))
            }
    
                
            LazyVGrid(columns: vm.columns, alignment: .leading, spacing: 10) {
                
                Text("Loading - In & Out")
                    .foregroundStyle(Color(.systemGray))
                
                Text("Unloading - In & Out")
                    .foregroundStyle(Color(.systemGray))
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.blue)
                    
                    Text(loadingIn)
                        .font(Font.custom("Monaco", size: 12.5))
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.green)
                    
                    Text(unloadingIn)
                        .font(Font.custom("Monaco", size: 12.5))
                }
                
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.blue)
                    
                    Text(loadingOut)
                        .font(Font.custom("Monaco", size: 12.5))
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundStyle(.green)
                    
                    Text(unloadingOut)
                        .font(Font.custom("Monaco", size: 12.5))
                }
                
            }
            
            
            HStack {
                
                VStack(spacing: 5) {
                    Text("Advances")
                        .foregroundStyle(Color(.systemGray))
                    
                    Text("₹\(vm.calculateAdvance(tripAdvances))")
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                }
                .onTapGesture {
                    coordinator.push(.trips(.tripAdvances(advanceData: tripAdvances)))
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    
                    Text("Trip Status")
                        .foregroundStyle(Color(.systemGray))
                    
                    Text(TripStatusHandler.statusText(status))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.teal.opacity(0.75)))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    Text("Account Status")
                        .foregroundStyle(Color(.systemGray))
                    
                    Text(TripStatusHandler.statusAccountText(statusAccounts))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.blue.opacity(0.5)))
                        .foregroundStyle(.white)
                }
                
            }
            .font(Font.custom("Monaco", size: 15))
            
            
            Section {
                
                HStack {
                    
                    VStack(spacing: 5) {
                        Text("Approved")
                            .foregroundStyle(Color(.systemGray))
                        
                        Text("₹\(vm.approvedExpense(tripExpenses))")
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text("Pending")
                            .foregroundStyle(Color(.systemGray))
                        
                        Text("₹\(vm.pendingExpense(tripExpenses))")
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text("Rejected")
                            .foregroundStyle(Color(.systemGray))
                        
                        Text("₹\(vm.rejectedExpense(tripExpenses))")
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                    }
                    
                }
                .font(Font.custom("Monaco", size: 15))
                
            } header: {
                Text("Total Expenses")
                    .font(Font.custom("ArialRoundedMTBold", size: 17.5))
            }
            
            .onTapGesture {
                coordinator.push(.trips(.tripExpenses(.tripExpenses(tripId: id, assetId: assetId))))
            }
            
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .padding(.vertical, 20)
        .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))
        
    }
    
}

#Preview {
//    TripsView()
}
