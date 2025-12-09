//
//  POIViewModel.swift
//  DriverApp
//
//  Created by Nirmal kumar on 06/11/25.
//

import Foundation
import MapKit

// selection fuel, toll and poi has to retain value accross views

class POIViewModel: ObservableObject {
    
    @Published var fuelSelected: Bool = false
    @Published var tollSelected: Bool = false
    @Published var poiSelected: Bool = false
    
    @Published var poiList: [APIService.PoiListModel.Result] = []
    @Published var fuelList: [APIService.FuelListModel.Results] = []
    
    // user location
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var userLocation: CLLocation = .init()
    
    @MainActor
    func onAppear(apiService: APIService, locationManager: LocationManager) async {
        
        userLatitude = locationManager.location?.latitude ?? 0
        userLongitude = locationManager.location?.longitude ?? 0
        
        userLocation = CLLocation(latitude: userLatitude, longitude: userLongitude)

        
        do {
            poiList = try await apiService.getPoiZones()
            fuelList = try await apiService.getFuelList()
        } catch {
            
        }
        
        filterFuelList()
        
    }
    
    func filterFuelList() {
        
        fuelList = fuelList.filter( { userLocation.distance(from: CLLocation(latitude: $0.lat ?? 0, longitude: $0.lng ?? 0)) < 200000 } )
    }
    
}
