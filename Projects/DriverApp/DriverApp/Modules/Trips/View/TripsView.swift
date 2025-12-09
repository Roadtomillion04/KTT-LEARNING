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
        
        VStack(spacing: 20) {
            
            HStack {
                
                VStack(alignment: .center, spacing: 3) {
                    
                    Text(LocalizedStringResource("from_date"))
                        .font(Font.custom("ArialRoundedMTBold", size: 15))
                    
                    Label(vm.startDate.toString(format: "dd MMM yyyy"), systemImage: "calendar")
                        .font(Font.custom("Monaco", size: 14))
                    
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))

                
                Spacer()
                
                VStack(alignment: .center, spacing: 3) {
                    
                    Text(LocalizedStringResource("to_date"))
                        .font(Font.custom("ArialRoundedMTBold", size: 15))

                    Label(vm.endDate.toString(format: "dd MMM yyyy"), systemImage: "calendar")
                        .font(Font.custom("Monaco", size: 14))
                    
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.ultraThinMaterial))

            }
            
            .onTapGesture {
                vm.showDatePicker = true
            }
            
            .customAlert(isPresented: $vm.showDatePicker) {
                
                DatePickerView(vm: vm)
                
            }
            
            
            HStack {
                
                Spacer()
                
                VStack(spacing: 3) {
                    
                    Text(LocalizedStringResource("total_advances"))
                        .foregroundStyle(Color(.systemGray))
                        .font(Font.custom("AriSanPro-Medium", size: 15))
                    
                    Text("₹\(vm.totalAdvances(apiService.tripsDataModel.results))")
                        .font(Font.custom("ArialRoundedMTBold", size: 14))
                }
                
                Spacer()
                
                VStack(spacing: 3) {
                    
                    Text(LocalizedStringResource("total_expenses"))
                        .foregroundStyle(Color(.systemGray))
                        .font(Font.custom("AriSanPro-Medium", size: 15))
                    
                    Text("₹\(vm.totalExpenses(apiService.tripsDataModel.results))")
                        .font(Font.custom("ArialRoundedMTBold", size: 14))
                }
                
                Spacer()
            }
            
            ScrollView {
                
                ForEach(apiService.tripsDataModel.results.sorted(by: { $0.id ?? 0 > $1.id ?? 0 }), id: \.id) { data in
                    tripsListContent(
                        id: data.id ?? 0,
                        assetId: data.assetId ?? 0,
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
        
        .task {
//            if !vm.sceneEntered {
                await vm.onAppear(apiService: apiService)
//                vm.sceneEntered = true
//            }
        }
        
        .refreshable {
            await vm.onReload(apiService: apiService)
        }
        
        .loadingScreen(isLoading: vm.isLoading)
        
    }
    
    
    @ViewBuilder
    private func tripsListContent(id: Int, assetId: Int, vehicleNumber: String, startOdo: String, route: String, loadingIn: String, loadingOut: String, unloadingIn: String, unloadingOut: String, status: Int, statusAccounts: Int, tripAdvances: [APIService.TripsDataModel.TripAdvance], tripExpenses: [APIService.TripsDataModel.TripExpense]) -> some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            Section {
                
                HStack {
                    
                    VStack(spacing: 5) {
                        Text(LocalizedStringResource("start_odo"))
                            .font(Font.custom("AriSanPro-Medium", size: 13))
                            .foregroundStyle(Color(.systemGray))
                        
                        Text(startOdo)
                            .font(Font.custom("Monaco", size: 12.5))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5)  {
                        Text(LocalizedStringResource("end_odo"))
                            .font(Font.custom("AriSanPro-Medium", size: 13))
                            .foregroundStyle(Color(.systemGray))

                        Text("0")
                            .font(Font.custom("Monaco", size: 12.5))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5)  {
                        Text(LocalizedStringResource("distance"))
                            .font(Font.custom("AriSanPro-Medium", size: 13))
                            .foregroundStyle(Color(.systemGray))

                        Text("0")
                            .font(Font.custom("Monaco", size: 12.5))
                    }
                    
                }
            } header: {
                HStack(spacing: 10) {
                    Image(systemName: "truck.box.fill")
                        .font(.headline)
                        .foregroundStyle(.blue)
                        
                    
                    Text(vehicleNumber)
                        .font(Font.custom("Monaco", size: 13))
            
                }
            }
            
            Divider()
                
            
            HStack {
                Image(systemName: "arrowshape.right.fill")
                    .foregroundStyle(.blue)
                
                Text("Ref No:-")
                    .font(Font.custom("GillSans", size: 13))
            }
            
            HStack {
                Image(systemName: "location.north.fill")                    .foregroundStyle(.blue)
                
                Text(route)
                    .font(Font.custom("Monaco", size: 13))
            }
    
                
            LazyVGrid(columns: vm.columns, alignment: .leading, spacing: 10) {
                
                Text(LocalizedStringResource("loading_in_amp_out"))
                    .font(Font.custom("AriSanPro-Medium", size: 14))
                    .foregroundStyle(Color(.systemGray))
                
                Text(LocalizedStringResource("unloading_in_amp_out"))
                    .font(Font.custom("AriSanPro-Medium", size: 14))
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
                    Text(LocalizedStringResource("madvances"))
                        .font(Font.custom("AriSanPro-Medium", size: 13))
                        .foregroundStyle(Color(.systemGray))
                    
                    Text("₹\(vm.calculateAdvance(tripAdvances))")
                        .font(Font.custom("Monaco", size: 12.5))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                }
                .onTapGesture {
                    coordinator.push(.trips(.tripAdvances(advanceData: tripAdvances)))
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    
                    Text(LocalizedStringResource("trip_status"))
                        .font(Font.custom("AriSanPro-Medium", size: 13))
                        .foregroundStyle(Color(.systemGray))
                    
                    Text(TripStatusHandler.statusText(status))
                        .font(Font.custom("Monaco", size: 12.5))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.teal.opacity(0.75)))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    Text(LocalizedStringResource("account_status"))
                        .font(Font.custom("AriSanPro-Medium", size: 13))
                        .foregroundStyle(Color(.systemGray))
                    
                    Text(TripStatusHandler.statusAccountText(statusAccounts))
                        .font(Font.custom("Monaco", size: 12.5))
                        .padding(.horizontal)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.blue.opacity(0.5)))
                        .foregroundStyle(.white)
                }
                
            }
            
            
            Section {
                
                HStack {
                    
                    VStack(spacing: 5) {
                        Text(LocalizedStringResource("approved"))
                            .font(Font.custom("AriSanPro-Medium", size: 13))
                            .foregroundStyle(Color(.systemGray))
                        
                        Text("₹\(vm.approvedExpense(tripExpenses))")
                            .font(Font.custom("Monaco", size: 12.5))
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text(LocalizedStringResource("pending"))
                            .font(Font.custom("AriSanPro-Medium", size: 13))
                            .foregroundStyle(Color(.systemGray))
                        
                        Text("₹\(vm.pendingExpense(tripExpenses))")
                            .font(Font.custom("Monaco", size: 12.5))
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 5) {
                        Text(LocalizedStringResource("rejected"))
                            .font(Font.custom("AriSanPro-Medium", size: 13))
                            .foregroundStyle(Color(.systemGray))
                        
                        Text("₹\(vm.rejectedExpense(tripExpenses))")
                            .font(Font.custom("Monaco", size: 12.5))
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray5)))
                    }
                    
                }
                
            } header: {
                Text(LocalizedStringResource("total_expenses"))
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
            }
            
            .onTapGesture {
                print(id, assetId, "in Trips View")
                coordinator.push(.trips(.tripExpenses(.tripExpenses(tripId: id, assetId: assetId, startDate: vm.startDate.toString(), endDate: vm.endDate.toString()))))
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
