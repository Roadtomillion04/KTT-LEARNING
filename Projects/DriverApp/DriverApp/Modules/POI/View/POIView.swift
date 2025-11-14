//
//  POIView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI
import MapKit


struct POIView: View {
    
    @StateObject private var vm: POIViewModel = .init()
    
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var apiService: APIService
    
    @State var showPopover: Bool = false
    
    @State var showAlert: Bool = false
    
 
    var body: some View {
        
        Map {
            
            UserAnnotation() // show user location
            
            if vm.poiSelected {
                
                ForEach(vm.poiList, id: \.self) { poi in
                    
                    Annotation(poi.city, coordinate: CLLocationCoordinate2D(latitude: poi.lat, longitude: poi.lng)) {
                        Image(systemName: "location.north.circle.fill")
                            .font(.title)
                            .foregroundStyle(.red)
                    }
                    
                }
                
            }
            
            if vm.fuelSelected {
                
                ForEach(vm.fuelList, id: \.self) { fuel in
                    
                    if vm.userLocation.distance(from: CLLocation(latitude: fuel.lat, longitude: fuel.lng)) < 200000 {
                        
                        Annotation(fuel.locationName, coordinate: CLLocationCoordinate2D(latitude: fuel.lat, longitude: fuel.lng)) {
                            
                            Image(systemName: "fuelpump.fill")
                                .font(.title)
                                .foregroundStyle(fuel.color == 1 ? .orange : .blue)
                            
                                .onTapGesture {
                                    vm.selectedSnippet = fuel
                                    
                                    showAlert = true
                                    
                                }
                            
                            
                                .customAlert(isPresented: $showAlert) {
                                    
                                    VStack(alignment: .center, spacing: 10) {
                                        
                                        Text(vm.selectedSnippet?.name ?? "")
                                            .bold()
                                        
                                        Divider()
                                        
                                        Text(vm.selectedSnippet?.locationName ?? "")
                                        
                                        Text("Contact: \(vm.selectedSnippet?.contactName ?? "") (\(vm.selectedSnippet?.contactPhone ?? ""))")
                                        
                                    }
                                    
                                }
                            
                        }
                        
                    }
                    
                }
                
            }
        
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
        
        .onAppear {
            vm.onAppear(apiService: apiService, locationManager: locationManager)
        }
 
        .overlay {
            Image(systemName: "square.stack.3d.up.fill")
                .font(.headline)
                .padding()
                .background(Circle().fill(.white))
                .padding()
            
                .onTapGesture {
                    showPopover.toggle()
                }
            
                // positioning like this finally works
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
                .background(
                    Rectangle() // clear not working, which is favourable now following android app
                        .fill(showPopover ? .white.opacity(0.1) : .clear)
                    
                    // tapping/swiping outside
                    .onTapGesture {
                        showPopover = false
                    }
                
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                showPopover = false
                            }
                    )
        
                )
            
            if showPopover {
                
                HStack(spacing: 25) {
                    
                    VStack {
                        
                        Image(systemName: "fuelpump.fill")
                            .font(.title)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .border(vm.fuelSelected ? .orange : .gray, width: 2)
                            )
                            
                            .onTapGesture {
                                vm.fuelSelected.toggle()
                            }
                        
                        Text("Fuel")
                    }
                    
                    VStack {
                        
                        Image(systemName: "building.fill")
                            .font(.title)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .border(vm.tollSelected ? .orange : .gray, width: 2)
                            )
                            .onTapGesture {
                                vm.tollSelected.toggle()
                            }
                        
                        Text("Toll")
                        
                    }
                    
                    VStack {
                        
                        Image(systemName: "location.north.circle.fill")
                            .font(.title)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.white)
                                    .border(vm.poiSelected ? .orange : .gray, width: 2)
                            )
                            .onTapGesture {
                                vm.poiSelected.toggle()
                            }
                        
                        Text("POI")
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.white))
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                .offset(y: -75)
                
            }
            
        }
    }
}

#Preview {
//    POIView()
}
