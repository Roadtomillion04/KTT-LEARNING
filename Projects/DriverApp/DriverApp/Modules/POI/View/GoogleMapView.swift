//
//  GoogleMapView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 15/11/25.


import Combine
import UIKit
import GoogleMaps
import SwiftUI

final class MarkerInfoWindowViewController: UIViewController {
    
    let vm: POIViewModel
    
    init(vm: POIViewModel, observation: NSKeyValueObservation? = nil, location: CLLocation? = nil) {
        self.vm = vm
        self.observation = observation
        self.location = location
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // poi
    var poiSelected: Bool = false {
        didSet {
            updateMapMarkers()
        }
    }
    
    var poiList: [APIService.PoiListModel.Result] = [] {
        didSet {
            updateMapMarkers()
        }
    }
    
    
    // fuel
    var fuelSelected: Bool = false {
        didSet {
            updateMapMarkers()
        }
    }
    
    var fuelList: [APIService.FuelListModel.Results] = [] {
        didSet {
            updateMapMarkers()
        }
    }
    
    var poiListMarker: [GMSMarker] = []
    var fuelListMarker: [GMSMarker] = []
    

    private let cameraLatitude: CLLocationDegrees = -33.868
    private let cameraLongitude: CLLocationDegrees = 151.2086
    private let cameraZoom: Float = 12

    lazy var mapView: GMSMapView = {
      let camera = GMSCameraPosition(
        latitude: cameraLatitude, longitude: cameraLongitude, zoom: cameraZoom)
      return GMSMapView(frame: .zero, camera: camera)
    }()

    var observation: NSKeyValueObservation?
    var location: CLLocation? {
      didSet {
        guard oldValue == nil, let firstLocation = location else { return }
        mapView.camera = GMSCameraPosition(target: firstLocation.coordinate, zoom: 14)
      }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        view = mapView
        
        observation = mapView.observe(\.myLocation, options: [.new]) {
            [weak self] mapView, _ in
            self?.location = mapView.myLocation
        }
        
        setupBindings()
        updateMapMarkers()
    }

    
    deinit {
      observation?.invalidate()
    }

    private func updateMapMarkers() {
        
        // hide/deinit the marker
        for marker in poiListMarker {
            marker.map = nil
        }
        
        poiListMarker.removeAll()
        
        if poiSelected {
            
            for poi in poiList  {
                
                let position = CLLocationCoordinate2D(latitude: poi.geojson?.point.first?.lat ?? 0, longitude: poi.geojson?.point.first?.lng ?? 0)
                
                let marker = GMSMarker(position: position)
                
                marker.title = poi.fullName
                marker.snippet = """
                Name: \(poi.name ?? "")
                City: \(poi.city ?? "")
                Phone: \(poi.phone ?? "")
                """
                
                marker.icon = UIImage(systemName: "location.square.fill")?.resized(to: CGSize(width: 28, height: 28)).withColor(.red)
                    
                marker.map = mapView
                
                poiListMarker.append(marker)
                
            }
            
        }
        
        for marker in fuelListMarker {
            marker.map = nil
        }
        
        fuelListMarker.removeAll()
        
        if fuelSelected {
            
            for fuel in fuelList  {
                
                let position = CLLocationCoordinate2D(latitude: fuel.lat ?? 0, longitude: fuel.lng ?? 0)
                
                let marker = GMSMarker(position: position)
                
                marker.title = fuel.roname ?? ""
                marker.snippet = """
                \(fuel.lo ?? "")
                \(fuel.cn ?? "") (\(fuel.cp ?? ""))
                """
                
                marker.icon = UIImage(systemName: "fuelpump.fill")?.resized(to: CGSize(width: 28, height: 28)).withColor(fuel.co == 1 ? .orange : .blue)
                    
                
                marker.map = mapView
                
                fuelListMarker.append(marker)
                
            }
            
        }
    }
    
    private func setupBindings() {
        
        vm.$poiList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] new in
                self?.poiList = new
            }
            .store(in: &cancellables)
        
        vm.$poiSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] new in
                self?.poiSelected = new
            }
            .store(in: &cancellables)
        
        vm.$fuelList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] new in
                self?.fuelList = new
            }
            .store(in: &cancellables)
        
        vm.$fuelSelected
            .receive(on: DispatchQueue.main)
            .sink { [weak self] new in
                self?.fuelSelected = new
            }
            .store(in: &cancellables)
    }
    
}

extension MarkerInfoWindowViewController: GMSMapViewDelegate {
    
}


   
struct GoogleMapViewControllerWrapper: UIViewControllerRepresentable {

    let vm: POIViewModel
    
    func makeUIViewController(context: Context) -> MarkerInfoWindowViewController {
        
        return MarkerInfoWindowViewController(vm: vm)
    }

    func updateUIViewController(_ uiViewController: MarkerInfoWindowViewController, context: Context) {
        
    }
}
