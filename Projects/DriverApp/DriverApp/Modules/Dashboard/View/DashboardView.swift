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
    
    @EnvironmentObject var customAlertPresenter: CustomAlertPresenter
    
    @State private var showAlert: Bool = false
    @State private var errorDescription: String = ""
    
    var body: some View {
       
        ScrollView {
            
            profileContent()
            dashboardContent()
            
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        
        .task {
            await vm.onAppear(apiService: apiService)
        }
     
        
        .refreshable {
            await vm.onReload(apiService: apiService)
        }
        
        .loadingScreen(isLoading: vm.isLoading)
        
    }
    

    @ViewBuilder
    private func profileContent() -> some View {
        
        HStack(spacing: 20) {
            
            AsyncImage(url: URL(string: apiService.driverStatusModel.driver?.photoURL ?? "")) { image in
                
                image
                    .profileImage()
                
            } placeholder: {
                Circle().fill(.thinMaterial)
            }
            .frame(width: 100, height: 100)
            
            VStack(alignment: .leading, spacing: 2) {
                
                Text(apiService.driverStatusModel.driver?.name ?? "")
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
                
                Text("\(String(apiService.driverStatusModel.driver?.id ?? 0))")
                    .font(Font.custom("ArialRoundedMTBold", size: 12.5))
                
                Divider()
                    .frame(maxHeight: 2)
                    .overlay(.white)
                
                HStack {
                    
                    VStack(alignment: .leading, spacing: 2) {
                        
                        Text(LocalizedStringResource("lic_exp"))
                            .font(Font.custom("AriSanPro-Medium", size: 12.5))
                            .foregroundStyle(.secondary)
                        
                        Text(apiService.driverStatusModel.driver?.dlexp?.dateFormatting(format: "dd/MM/yyyy") ?? "")
                            .font(Font.custom("Monaco", size: 12.5))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 2) {
                        
                        Text(LocalizedStringResource("rto_loc"))
                            .font(Font.custom("AriSanPro-Medium", size: 12.5))
                            .foregroundStyle(.secondary)
                        
                        Text(LocalizedStringResource(stringLiteral: "location"))
                            .font(Font.custom("Moncao", size: 12.5))
                    }
                }
            }
            .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(.pink).shadow(radius: 1))
        .padding()
    }

    
    @ViewBuilder
    private func vehicleDetailView() -> some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            HStack(spacing: 15) {
                
                Image(systemName: "truck.box.fill")
                    .foregroundStyle(.yellow)
                
                Text(apiService.driverStatusModel.trip?.lplate ?? "")
                    .font(Font.custom("Monaco", size: 15))
                
                Spacer()
                
                Text("\(String(apiService.driverStatusModel.trip?.assetOdo ?? 0))")
                    .font(Font.custom("Monaco", size: 15))
                    .padding(6)
                    .border(.black)
                
            }
            
            HStack {
                
                Text("Trip Id - \(String(apiService.driverStatusModel.trip?.id ?? 0))")
                    .font(Font.custom("Monaco", size: 12.5))
                    .padding(.vertical, 2)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.yellow.opacity(0.25)))
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text(TripStatusHandler.statusText(apiService.driverStatusModel.trip?.status ?? 0))
                    .font(Font.custom("Monaco", size: 12.5))
                    .bold()
                    .padding(.vertical, 2)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.teal.opacity(0.5)))
                    .foregroundStyle(.white)
            }
            
            HStack {
                
                VStack(spacing: 5) {
                    
                    Text(LocalizedStringResource("start_odo"))
                        .font(Font.custom("AriSanPro-Medium", size: 12.5))
                        .foregroundStyle(.secondary)
                    
                    Text(apiService.driverStatusModel.trip?.odo ?? "0")
                        .font(Font.custom("Monaco", size: 12.5))
        
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    
                    Text(LocalizedStringResource("current_odo"))
                        .font(Font.custom("AriSanPro-Medium", size: 12.5))
                        .foregroundStyle(.secondary)
                    
                    Text("\(String(apiService.driverStatusModel.trip?.assetOdo ?? 0))")
                        .font(Font.custom("Monaco", size: 12.5))
                }
                
                Spacer()
                
                VStack(spacing: 5) {
                    
                    Text(LocalizedStringResource("distance"))
                        .font(Font.custom("AriSanPro-Medium", size: 12.5))
                        .foregroundStyle(.secondary)
                    
                    Text("\( String( (apiService.driverStatusModel.trip?.assetOdo ?? 0) - Int(apiService.driverStatusModel.trip?.odo ?? "0")! )) KM")
                        .font(Font.custom("Monaco", size: 12.5))
                }
            }
        }
    }


    @ViewBuilder
    private func dashboardContent() -> some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            vehicleDetailView()
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.regularMaterial)
                        .shadow(radius: 1)
                )
            
            DisclosureGroup {
                
                ForEach(vm.trips, id: \.id) { trip in
                    
                    HStack(spacing: 10) {
                        VStack{
                            Rectangle()
                                .frame(width: 1, height: .infinity)
                                .opacity(trip.zoneSeq == 0 ? 0 : 1)
                                .padding(.vertical, -10)
     
                            Circle()
                                .strokeBorder(Color(.systemGray4), lineWidth: 2)
                                .fill((!trip.inTime.isEmpty || trip.zoneSeq == 0) ? .teal : .clear)
                                .frame(width: 24, height: 24)
                            
                            Rectangle()
                                .frame(width: 1, height: .infinity)
                                .opacity(trip.zoneSeq == vm.trips.count - 1 ? 0 : 1)
                                .padding(.vertical, -10)
                        }

                        tripContent(trip)
                            .padding(6)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        (!trip.inTime.isEmpty && trip.outTime.isEmpty) || (trip.zoneSeq == 0 && trip.inTime.isEmpty)
                                        ? .green.opacity(0.25)
                                        : .white.opacity(0.75)
                                    )
                            )
                    }
                    .padding(.vertical, 6)

                }
                
            } label: {
                Text("Routes")
                    .font(Font.custom("ArialRoundedMTBold", size: 13))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
            .disclosureGroupStyle(ChevronUpDownDisclosureGroupStyle())

            
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
    private func tripContent(_ trip: Trip) -> some View {
            
        VStack(spacing: 14) {
            
            HStack(spacing: 10) {
                HStack{
                    Image(systemName: "mappin")
                        .font(.headline)
                        .foregroundStyle(.pink)
                    
                  
                    Text(trip.locationName)
                        .font(Font.custom("ArialRoundedMTBold", size: 12.5))
                }
                .onTapGesture {
                    vm.openMaps(for: trip)
                }
            
                
                Spacer()
                
                
                // as per android app, if atleast one of 3 has images uploaded
                if !trip.lr.images.isEmpty || !trip.pod.images.isEmpty || !trip.docs.isEmpty {
                    
                    Button(LocalizedStringKey("view")) {
                        coordinator.push(.dashboard(.zoneInfo(location: trip.locationName, date: trip.inTime, lrNumber: trip.lr.number ?? "", loadingCharges: trip.opExpenses.loadingCharge, unloadingCharges: trip.opExpenses.unloadingCharge, lrImage: trip.lr.images, podImage: trip.pod.images, docImage: trip.docs)))
                    }
                    
                    .font(Font.custom("ArialRoundedMTBold", size: 12.5))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 7)
                    .foregroundStyle(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.tint)
                    )
                }
                
                if trip.statusCustom == "Delivery" && trip.zoneSeq != 0 {
                    
                    Button("cancel") {
                        vm.selectedTrip = trip
                        vm.showCancelAlert = true
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12.5))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 7)
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
                            reasons: vm.tripCancelReason.results,
                            sequence: vm.selectedTrip?.zoneSeq ?? -1)
                        
                    }
                }
            }
          
            
            HStack(spacing: 7) {
                if trip.lrShow { lrButton(trip) }
                if trip.podShow { podButton(trip) }
                if trip.docShow { documentButton(trip) }
                
                if trip.opExpenses.floor || trip.opExpenses.headLoadingCharges || trip.opExpenses.loadingCharges || trip.opExpenses.unloadingCharges {
                    operatingExpensesButton(trip)
                }
                
                Spacer()
                
            }
        }
        .padding(.vertical)
        
    }
    
    
    @ViewBuilder
    private func lrButton(_ trip: Trip) -> some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            VStack {
                
                Text("+")
                    .font(Font.custom("Monaco-Light", size: 25))
                    
                if !trip.lr.images.isEmpty {
                Text("\(trip.lr.images.count) uploaded")
                        .font(Font.custom("Monaco", size: 12))
                }
            
                
            }
            .frame(width: 63, height: 63)
            .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.background).shadow(radius: 2))
            
            Text(LocalizedStringResource("lr"))
                .font(Font.custom("ArialRoundedMTBold", size: 12))
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
                    .font(Font.custom("Monaco-Light", size: 25))
                
                if !trip.pod.images.isEmpty {
                    Text("\(trip.pod.images.count) uploaded")
                        .font(Font.custom("Monaco", size: 12))
                }
                
            }
            .frame(width: 63, height: 63)
            .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.background).shadow(radius: 2))
            
            Text(LocalizedStringResource("pod"))
                .font(Font.custom("ArialRoundedMTBold", size: 12))
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
                    .font(Font.custom("Monaco-Light", size: 25))
                
                if !trip.docs.isEmpty {
                    Text("\(trip.docs.count) uploaded")
                        .font(Font.custom("Monaco", size: 12))
                }
                
            }
            .frame(width: 63, height: 63)
            .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.background).shadow(radius: 2))
            
            Text(LocalizedStringResource("doc"))
                .font(Font.custom("ArialRoundedMTBold", size: 12))
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
                    .font(Font.custom("Monaco-Light", size: 25))
                
            }
            .frame(width: 63, height: 63)
            .background(RoundedRectangle(cornerRadius: 5).foregroundStyle(.background).shadow(radius: 2))
            
            Text(LocalizedStringResource("operating_expenses"))
                .font(Font.custom("ArialRoundedMTBold", size: 12))
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
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text(LocalizedStringResource("target"))
                    .font(Font.custom("GillSans", size: 14))
                    .foregroundStyle(.secondary)
                
                HStack {
                    Text("\(String(apiService.driverStatusModel.trip?.routeData?.route.estKM ?? 0)) KM in 00 hr: 00 min")
                        .font(Font.custom("Monaco", size: 14))
                    
                    Spacer()
                    
                    Image(systemName: "arrowshape.turn.up.right.circle.fill")
                        .font(.headline)
                        .background(Circle().fill(.black))
                        .foregroundStyle(.yellow)
                        
                    
                        .onTapGesture {
                            vm.openMapsTripNavigation()
                        }
                }
            }
    
            Divider()
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text(LocalizedStringResource("trip_adate"))
                    .font(Font.custom("GillSans", size: 14))
                    .foregroundStyle(.secondary)
                
                Text(apiService.driverStatusModel.trip?.createdAt?.dateFormatting() ?? "")
                    .font(Font.custom("Monaco", size: 14))
                
            }
            
            Divider()

            VStack(alignment: .leading, spacing: 3) {
                
                Text(LocalizedStringResource("total_advance"))
                    .font(Font.custom("GillSans", size: 14))
                    .foregroundStyle(.secondary)
                
                HStack {
                    Text(vm.totalAdvances(apiService.driverStatusModel.trip?.tripAdvances ?? []))
                        .font(Font.custom("Monaco", size: 14))
                    
                    Spacer()
                    
                    Image(systemName: "chevron.forward")
                        .font(.headline)
                }
                .onTapGesture {
                    coordinator.push(.trips(.tripAdvances(advanceData: apiService.driverStatusModel.trip?.tripAdvances ?? [])))
                }
                
            }
    

            Divider()
            
            VStack(alignment: .leading, spacing: 3) {
                
                Text(LocalizedStringResource("trip_expenses"))
                    .font(Font.custom("GillSans", size: 14))
                    .foregroundStyle(.secondary)
                
                Text(vm.totalExpenses(apiService.driverStatusModel.trip?.tripExpenses ?? []))
                    .font(Font.custom("Monaco", size: 14))
            }

        }
        
    }

}


#Preview {
//    DashboardView()
}

