//
//  DashboardView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI
import Foundation


struct DashboardView: View {
    
    @StateObject private var vm = DashboardViewModel()
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    @State var isExpanded: Bool = false
    
    var body: some View {
       
        ScrollView {
            
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                
                profileContent()
                
                dashboardContent()
                            
            } else {
                // landscape
            }
            
        }
        .scrollIndicators(.hidden)
        
        .onAppear {
            vm.parseData(apiService: apiService)
        }
        
        .refreshable {
            
            do {
                
                try await apiService.getDriverStatus(cachePolicy: .reloadIgnoringLocalCacheData)
                
            } catch {
                
            }
        }

        
    }
    

    @ViewBuilder
    private func profileContent() -> some View {
        
        HStack(spacing: 20) {
            
            AsyncImage(url: URL(string: apiService.driverStatusAttributes.driver.photoURL ?? "")) { image in
                
                image
                    .profileImage()
                
            } placeholder: {
                Image(systemName: "arrow.clockwise")
                    .profileImage()
            }
            .frame(width: 110, height: 110)
            
            VStack(alignment: .leading, spacing: 2) {
                
                Text(apiService.driverStatusAttributes.driver.name ?? "")
                    .font(Font.custom("ArialRoundedMTBold", size: 17.5))
                
                Text("\(String(apiService.driverStatusAttributes.driver.id ?? 0))")
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
                
                Divider()
                    .frame(maxHeight: 2)
                    .overlay(.white)
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 2) {
                        
                        Text("License Expiry")
                            .font(Font.custom("Monaco", size: 15))
                        
                        Text(apiService.driverStatusAttributes.driver.dlexp?.dateFormatting(format: "dd/MM/yyyy") ?? "")
                            .font(Font.custom("Monaco", size: 15))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        
                        Text("RTO / Home")
                            .font(Font.custom("Monaco", size: 15))
                        
                        Text("Location")
                            .font(Font.custom("Moncao", size: 15))
                    }
                }
            }
            .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150, alignment: .top)
        .padding()
        .background(RoundedRectangle(cornerRadius: 5).fill(.pink).shadow(radius: 1))
    }

    
    @ViewBuilder
    private func vehicleDetailView() -> some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            HStack(spacing: 15) {
                
                Image(systemName: "truck.box.fill")
                    .foregroundStyle(.yellow)
                
                Text(apiService.driverStatusAttributes.trip.lplate ?? "")
                    .font(Font.custom("", size: 17.5))
                
                Spacer()
                
                Text("\(String(apiService.driverStatusAttributes.trip.assetOdo ?? 0))")
                    .padding(6)
                    .border(.black)
                
            }
            
            HStack {
                
                Text("Trip Id - \(String(apiService.driverStatusAttributes.trip.id ?? 0))")
                    .font(Font.custom("Monaco", size: 15))
                    .padding(.vertical, 2)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.yellow.opacity(0.25)))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(TripStatusHandler.statusText(apiService.driverStatusAttributes.trip.status ?? 0))
                    .font(Font.custom("Monaco", size: 15))
                    .bold()
                    .padding(.vertical, 2)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.teal.opacity(0.5)))
                    .foregroundStyle(.white)
            }
            
            HStack {
                
                VStack(spacing: 5) {
                    
                    Text("Start ODO")
                        .font(Font.custom("AriSanPro-Medium", size: 15))
                        .foregroundStyle(.secondary)
                    
                    Text(apiService.driverStatusAttributes.trip.odo ?? "0")
                        .font(Font.custom("Monaco", size: 15))
        
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    
                    Text("Current ODO")
                        .font(Font.custom("AriSanPro-Medium", size: 15))
                        .foregroundStyle(.secondary)
                    
                    Text("\(String(apiService.driverStatusAttributes.trip.assetOdo ?? 0))")
                        .font(Font.custom("Monaco", size: 15))
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    
                    Text("Distance")
                        .font(Font.custom("AriSanPro-Medium", size: 15))
                        .foregroundStyle(.secondary)
                    
                    Text("\( String( (apiService.driverStatusAttributes.trip.assetOdo ?? 0) - Int(apiService.driverStatusAttributes.trip.odo ?? "0")! )) KM")
                        .font(Font.custom("Monaco", size: 15))
                }
            }
        }
    }


    @ViewBuilder
    private func dashboardContent() -> some View {
        
        VStack(spacing: 20) {
            
            vehicleDetailView()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.regularMaterial)
                        .shadow(radius: 1)
                )
            
            collapsibleTripsCard(title: "Routes") {
                
                ForEach(vm.trips) { trip in
                    
                    collapsibleTripsCard(title: trip.locationName, trip: trip) {
                        tripContent(trip)
                    }
                    // showing active zone?
                    .background(!trip.inTime.isEmpty && trip.outTime.isEmpty ? .green.opacity(0.25) : .clear)
                }
            }
            
            tripDetailView()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.regularMaterial)
                        .shadow(radius: 1)
                )
        }
        .padding(.horizontal)
        
    }

    
    @ViewBuilder
        private func collapsibleTripsCard<Content: View>(
            title: String,
            trip: Trip? = nil,
            @ViewBuilder content: @escaping () -> Content
        ) -> some View {
            
            DisclosureGroup() {
                
                content()
                    .padding(.top, 10)
                
                
            } label: {
                
                HStack(spacing: 10) {
                    
                    if title != "Routes" {
                        Image(systemName: "mappin")
                            .font(.headline)
                            .foregroundStyle(.pink)
                        
                            .onTapGesture {
                                vm.openMaps(for: trip!)
                            }
                    }
                    
                    Text(title)
                        .font(Font.custom("ArialRoundedMTBold", size: 15))
                        
                    
                    Spacer()
                    
                    
//                    Text(!trip!.inTime.isEmpty && !trip!.outTime.isEmpty ? "Complete" : "")
//                        .font(.caption)
//                        .padding(.horizontal)
//                        .padding(.vertical, 6)
//                        .background(RoundedRectange(cornerRadius: 10).fill(.green))
    
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
            .disclosureGroupStyle(ChevronUpDownDisclosureGroupStyle())
        }
    
    
    @ViewBuilder
    private func tripContent(_ trip: Trip) -> some View {
        
        VStack(spacing: 20) {
            
            VStack(alignment: .leading, spacing: 20) {
                
                HStack {
                    Spacer()
                    
                    // as per android app, if atleast one of 3 has images uploaded
                    if !trip.lr.images.isEmpty || !trip.pod.images.isEmpty || !trip.docs.images.isEmpty {
                     
                        Button("View") {
                            coordinator.push(.dashboard(.zoneInfo(location: trip.locationName, date: trip.inTime, lrNumber: trip.lr.number ?? "", loadingCharges: trip.opExpenses.loadingCharge, unloadingCharges: trip.opExpenses.unloadingCharge, lrImage: trip.lr.images, podImage: trip.pod.images, docImage: trip.docs.images)))
                        }
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.tint)
                        )
                    }
                    
                    if trip.statusCustom == "Delivery" && trip.zoneSeq != 0 {
                        
                        Button("Cancel") {
                            vm.selectedTrip = trip
                            vm.showCancelAlert = true
                        }
                        .bold()
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.red)
                        )
                        
                        .customAlert(isPresented: $vm.showCancelAlert) {
                            
                            ZoneCancellationView(
                                isPresented: $vm.showCancelAlert,
                                location: vm.selectedTrip?.locationName ?? "",
                                tripId: vm.selectedTrip?.id ?? "",
                                reasons: apiService.deliveryCancellationAttributes.results,
                                sequence: vm.selectedTrip?.zoneSeq ?? -1)
                            
                        }
                        
                    }
                }
                
                HStack(spacing: 10) {
                    if trip.lrShow { lrButton(trip) }
                    if trip.podShow { podButton(trip) }
                    if trip.docShow { documentButton(trip) }
                    
                    if trip.opExpenses.floor || trip.opExpenses.headLoadingCharges || trip.opExpenses.loadingCharges || trip.opExpenses.unloadingCharges {
                        operatingExpensesButton(trip)
                    }
                }
            }
        }
        .padding(.vertical, 10)
    }
    
    
    @ViewBuilder
    private func lrButton(_ trip: Trip) -> some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            VStack {
                
                Text("+")
                    .font(Font.custom("Monaco-Light", size: 35))
                    
                if !trip.lr.images.isEmpty {
                Text("\(trip.lr.images.count) uploaded")
                    .font(Font.custom("Monaco", size: 12))
                }
            
                
            }
            .frame(width: 75, height: 75)
            .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.background).shadow(radius: 2))
            
            Text("LR")
                .font(Font.custom("ArialRoundedMTBold", size: 12.5))
        }
        .onTapGesture {
            coordinator.push(.dashboard(.lrUpload(id: trip.id, lr: trip.lr)))
        }
    }
    
    
    @ViewBuilder
    private func podButton(_ trip: Trip) -> some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            VStack {
                
                Text("+")
                    .font(Font.custom("Monaco-Light", size: 35))
                
                if !trip.pod.images.isEmpty {
                    Text("\(trip.pod.images.count) uploaded")
                        .font(Font.custom("Monaco", size: 12))
                }
                
            }
            .frame(width: 75, height: 75)
            .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.background).shadow(radius: 2))
            
            Text("POD")
                .font(Font.custom("ArialRoundedMTBold", size: 12.5))
        }
        .onTapGesture {
            coordinator.push(.dashboard(.podUpload(id: trip.id, pod: trip.pod)))
        }
    }
    
    
    @ViewBuilder
    private func documentButton(_ trip: Trip) -> some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            VStack {
                
                Text("+")
                    .font(Font.custom("Monaco-Light", size: 35))
                
                if !trip.docs.images.isEmpty {
                    Text("\(trip.docs.images.count) uploaded")
                        .font(Font.custom("Monaco", size: 12))
                }
                
            }
            .frame(width: 75, height: 75)
            .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.background).shadow(radius: 2))
            
            Text("Doc")
                .font(Font.custom("ArialRoundedMTBold", size: 12.5))
        }
        .onTapGesture {
            coordinator.push(.dashboard(.docUpload(id: trip.id, doc: trip.docs)))
        }
    }
    
    @ViewBuilder
    private func operatingExpensesButton(_ trip: Trip) -> some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            VStack {
                
                Text("+")
                    .font(Font.custom("Monaco-Light", size: 35))
                
            }
            .frame(width: 75, height: 75)
            .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.background).shadow(radius: 2))
            
            Text("OP")
                .font(Font.custom("ArialRoundedMTBold", size: 12.5))
        }
        .onTapGesture {
            coordinator.push(.dashboard(.operationgExpenses(id: trip.id, opExpenses: Trip.OpExpenses(
                floor: trip.opExpenses.floor,
                headLoadingCharges: trip.opExpenses.headLoadingCharges,
                loadingCharges: trip.opExpenses.loadingCharges,
                unloadingCharges: trip.opExpenses.unloadingCharges,
                loadingCharge: trip.opExpenses.loadingCharge,
                unloadingCharge: trip.opExpenses.unloadingCharge,
                headChargeAvailable: trip.opExpenses.headChargeAvailable
            ))))
        }
    }
    
    @ViewBuilder
    private func tripDetailView() -> some View {
        
        VStack(alignment: .leading) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Target")
                    .font(Font.custom("Monaco", size: 16))
                    .foregroundStyle(.secondary)
                
                HStack {
                    Text("\(String(apiService.driverStatusAttributes.trip.routeData.route.estKM ?? 0)) KM in 00 hr: 00 min")
                    
                    Spacer()
                    
                    Image(systemName: "arrowshape.turn.up.right.circle.fill")
                        .resizable()
                        .background(Circle().fill(.black))
                        .foregroundStyle(.yellow)
                        .frame(width: 32, height: 32)
                    
                        .onTapGesture {
                            vm.openMapsTripNavigation()
                        }
                }
            }
    
            Divider()
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Trip Assignment Date")
                    .font(Font.custom("Monaco", size: 16))
                    .foregroundStyle(.secondary)
                
                Text(apiService.driverStatusAttributes.trip.createdAt?.dateFormatting() ?? "")
                
            }
            
            Divider()

            VStack(alignment: .leading, spacing: 0) {
                
                Text("Total Advances")
                    .font(Font.custom("Monaco", size: 16))
                    .foregroundStyle(.secondary)
                
                HStack {
                    Text(vm.totalAdvances(apiService.driverStatusAttributes.trip.tripAdvances))
                    Spacer()
                    Image("right-arrow")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                
            }
            .onTapGesture {
                coordinator.push(.trips(.tripAdvances(advanceData: apiService.driverStatusAttributes.trip.tripAdvances)))
            }
    

            Divider()
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Total Expenses")
                    .font(Font.custom("Monaco", size: 16))
                    .foregroundStyle(.secondary)
                
                Text(vm.totalExpenses(apiService.driverStatusAttributes.trip.tripExpenses))
            }

        }
        
    }

}


#Preview {
//    DashboardView()
}
