//
//  AttendanceView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/09/25.
//

import SwiftUI
import Foundation
import MapKit

struct AttendanceView: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var locationManager: LocationManager
    @EnvironmentObject private var apiService: APIService
    
    @StateObject private var vm: AttendanceViewModel = .init()
    
    @State private var currentDate = Date()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    
    var body: some View {
        
        VStack(spacing: 25) {
            
            timeInfo()
            
            attendanceCard()
            
            attendanceList()
            
        }
        .padding()
        
        .onAppear {
            vm.checkCapturedImage()
        }
        
        .loadingScreen(isLoading: vm.isLoading)
        
        .customAlert(isPresented: $vm.showCheckinAlert) {
            
            VStack(spacing: 25) {
                
                Image(uiImage: vm.checkinImage) // no preview here
                    .resizable()
                    .frame(width: 250, height: 250)
                
                LazyVGrid(columns: vm.columns, alignment: .leading, spacing: 25) {
                    
                    Text("Date:")
                    
                    Text(vm.date)
                    
                    Text("Time:")
                    
                    Text(vm.time)
                    
                    Text("Location:")
                        
                    Text(vm.location)
                    
                    Button("Cancel") {
                        vm.showCheckinAlert = false
                    }
                    .font(Font.custom("Monaco", size: 20))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.red))
                    .foregroundStyle(.white)
                    
                    Button("Check In") {
                        vm.postCheckIn(apiService, lat: locationManager.location?.latitude ?? 0, lng: locationManager.location?.longitude ?? 0)
                    }
                    .font(Font.custom("Monaco", size: 20))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.green))
                    .foregroundStyle(.black)
                }
            }
            
        }
        
        .alert("Success", isPresented: $vm.success) {
            Button("Ok") {
                vm.showCheckinAlert = false
            }
        } message: {
            Text("Attendance checked in successfully")
        }
        
    }
    
    @ViewBuilder
    private func timeInfo() -> some View {
        
        VStack {
            
            Text(currentDate, style: .time)
                .font(Font.custom("ArialRoundedMTBold", size: 50))
                .onReceive(timer) { input in
                    self.currentDate = input
                }
            
            Text(vm.currentDateString)
        }
        
    }
    
    @ViewBuilder
    private func attendanceCard() -> some View {
        
        VStack(alignment: .center, spacing: 10) {
            
            Text("Good Morning, \(apiService.driverStatusAttributes.driver.name ?? "")")
                .bold()
            
            Text("Location")
                .foregroundStyle(Color(.systemGray))
            
            HStack {
                Image(systemName: "truck.box.fill")
                    .font(.headline)
                    .foregroundStyle(Color(.systemGray3))
                
                Text(apiService.driverStatusAttributes.trip.lplate ?? "")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
            )
            
            Button("CHECK IN") {
                coordinator.push(.miscellaneous(.cameraCapture(image: $vm.checkinImage, sourceType: .photoLibrary)))
            }
            .font(Font.custom("ArialRoundedMTBold", size: 15))
            .padding()
            .background(RoundedRectangle(cornerRadius: 5).fill(.blue))
            .foregroundStyle(.white)
            
        }
        .frame(maxWidth: .infinity)
        .frame(height: 250)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(radius: 3)
        )
        
    }
    
    @ViewBuilder
    private func attendanceList() -> some View {
        
        HStack {
            
            Text("Today's Attendance")
            
            Spacer()
            
            Button("View All") {
                coordinator.push(.setting(.attendance(.attendanceLogs)))
            }
            
        }
        .foregroundStyle(.black)
        .font(Font.custom("ArialRoundedMTBold", size: 20))
        
        List {
            
            // Today's attendace show
            ForEach(apiService.driverCheckInAttributes.results, id: \.self) { result in
                
                HStack(alignment: .center) {
                    
                    // ios 26+, this symbol
                    Image(systemName: "\(Date().toString(format: "dd")).calendar")
                        .font(.title)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text(result.date?.dateFormatting(format: "HH:mm a") ?? "")
                            .font(Font.custom("ArialRoundedMTBold", size: 15))
                        
                        Text("\(result.geozone.name ?? ""), \(result.geozone.city ?? "")")
                            .font(Font.custom("Monaco", size: 12.5))
                    }
                    
                    Spacer()
                    
                    Image("right-arrow")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                }
                .onTapGesture {
                    coordinator.push(.setting(.attendance(.attendanceDetail(data: result))))
                }
                
            }
            
        }
        .scrollBounceBehavior(.basedOnSize)
        
    }
        
}


// fileprivate is class accessible to this file only, no outside visible
fileprivate class AttendanceViewModel: ObservableObject {
    
    private var currentDate = Date()
    private var dateFormatter = DateFormatter()
    let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
    
    @Published var currentDateString: String
    @Published var showCheckinAlert: Bool = false
    
    @Published var checkinImage: UIImage = .init()
    @Published var date: String = ""
    @Published var time: String = ""
    @Published var location: String = ""
    
    @Published var success: Bool = false
    @Published var isLoading: Bool = false
    @Published var failed: Bool = false
    
    init() {
        
        dateFormatter.dateStyle = .medium
        currentDateString =  currentDate.formatted(.dateTime.weekday(.wide).month(.abbreviated).day().year())
    }
    
    func checkCapturedImage() {
        
        if checkinImage.size.width != 0 || checkinImage.size.height != 0 {
           
            date = Date().toString(format: "dd/MM/yyyy")
            time = Date().toString(format: "HH:mm a")
            location = "long long string sas fas here to take space so don't mind, is just  a test lsadlsadl sldjsajl las djlsaj lsa ljsla lajsd ljsa jlajl las ldsal a dsad a sad "
            
            showCheckinAlert = true
            
        }
        
    }
    
    @MainActor
    func postCheckIn(_ apiService: APIService, lat: Double, lng: Double) {
        
        Task {
            do {
                isLoading = true
                
                success = try await apiService.postDriverAttendances(image: checkinImage, lat: lat, lng: lng, address: "")

                try await apiService.getDriverCheckIn()
                
                checkinImage = UIImage() // clear the image
                
                isLoading = false
                
            } catch {
                isLoading = false
                failed = true
            }
        }
        
    }
    
}



struct AttendanceLogView: View {
    
    var body: some View {
        
        Text("Attendance Log")
        
    }
}


struct AttendanceDetailView: View {
    
    @StateObject private var vm: AttendanceDetailViewModel = .init()
    
    @EnvironmentObject private var apiService: APIService
    
    let data: APIService.DriverCheckIn.Results
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15) {
            
            IconData(icon: "calendar", value: data.date?.dateFormatting(format: "dd/MM/yyyy") ?? "")
            
            IconData(icon: "clock", value: data.date?.dateFormatting(format: "HH:mm a") ?? "")
            
            IconData(icon: "mappin", value: "\(data.geozone.name ?? ""), \(data.geozone.city ?? "")")
            
            Map {
                
                Annotation(data.details.location.address ?? "", coordinate: CLLocationCoordinate2D.init(latitude: data.details.location.lat ?? 0, longitude: data.details.location.lon ?? 0)) {
                    
                    ImagePreview(imageUrl: "https://dev.ktt.io/api/upload/file" + (data.images?.first ?? ""))
                        .frame(width: 75, height: 75) // can override actually
                        .clipShape(.circle)
                        .padding(6)
                        .background(Circle().fill(.black))
                    
                    Image(systemName: "triangle.fill")
                        .font(.headline)
                        .rotationEffect(Angle(degrees: 180))
                        .offset(y: -12)
                }
                
            }
            
        }
        .padding()
    
        
    }
    
}

fileprivate class AttendanceDetailViewModel: ObservableObject {
    
    
}


#Preview {
//    AttendanceView()
}
