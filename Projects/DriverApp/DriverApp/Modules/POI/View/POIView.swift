//
//  POIView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI

struct POIView: View {
    
    @StateObject private var vm: POIViewModel = .init()
    
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var apiService: APIService
    
    @State var showPopover: Bool = false
    
    @State var showAlert: Bool = false
    
 
    var body: some View {
        
        GoogleMapViewControllerWrapper(vm: vm) // uikit view display
        
            .task {
                await vm.onAppear(apiService: apiService, locationManager: locationManager)
            }
        
            .overlay {
                
                Image(systemName: "square.stack.3d.up.fill")
                    .font(.headline)
                    .padding()
                    .background(Circle().fill(.white))
                    .padding()
                
                    // positioning like this finally works
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                
                    .onTapGesture {
                        showPopover.toggle()
                    }
                
                
                if showPopover {
                    
                    HStack(spacing: 25) {
                        
                        VStack {
                            
                            Image(systemName: "fuelpump.fill")
                                .font(.title)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.white)
                                        .border(vm.fuelSelected ? .orange : .gray)
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
                                        .border(vm.tollSelected ? .orange : .gray)
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
                                        .border(vm.poiSelected ? .orange : .gray)
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
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .offset(y: 75)
                    
                }
                
            }
        
        
        
    }
}


#Preview {
//    POIView()
}



