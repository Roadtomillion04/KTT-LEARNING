//
//  TripExpensesAddView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 25/09/25.
//

import SwiftUI

struct AddTripExpensesView: View {
    
    @StateObject private var vm: AddTripExpensesViewModel = .init()
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    @EnvironmentObject private var languageManager: LanguageManager
    
    let isEditing: Bool
    let assetId: Int
    let tripId: Int
    let expenseId: Int
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                
                Label(apiService.driverStatusAttributes.trip.lplate ?? "", systemImage: "truck.box.fill")
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                
                HStack(alignment: .center, spacing: 10) {
                    
                    Image(systemName: "rectangle.grid.3x1.fill")
                        .foregroundColor(.gray)
                    
                    Text(LocalizedStringResource("select_type"))
                        .foregroundStyle(Color(.systemGray))
                    
                    Spacer()
                    
                    
                    if languageManager.selectedLanguage == Locale(identifier: "ta") {
                        
                        Picker("", selection: $vm.zoneType) {
                            
                            Text("None") // None option
                                .tag(nil as String?)
                            
                            
                            ForEach(vm.getTypesinTamil(), id: \.self) { types in
                                Text(types)
                                    .tag(types)
                                
                            }
                            
                        }
                        .tint(.black)
                    }
                    
                    else  {
                    
                    Picker("", selection: $vm.zoneType) {
                        
                        Text("None") // None option
                            .tag(nil as String?)
                        
                        ForEach(apiService.expenseTypesAttributes.results, id: \.self) { types in
                            Text(types.text ?? "")
                                .tag(types.text)
                        }
                        
                    }
                    .tint(.black)
                    
                }
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                
                HStack {
                    
                    Image(systemName: "clock")
                        .foregroundColor(.gray)
                    
                    DatePicker("Date", selection: $vm.date, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                
                CustomTextField(icon: "building.2", title: "Location", text: $vm.location)
                
                CustomTextField(icon: "indianrupeesign.circle", title: "Cost/Ltr", text: $vm.costPerLiter, show: vm.zoneType == "Fuel" ? true : false)
                
                CustomTextField(icon: "receipt", title: "Bill No", text: $vm.billNo, show: vm.zoneType == "Fuel" ? true : false)
                
                CustomTextField(icon: "fuelpump", title: "Litres", text: $vm.liters, show: vm.zoneType == "Fuel" || vm.zoneType == "Adblue" ? true : false)
                
                CustomTextField(icon: "gauge", title: "Odo", text: $vm.odo, show: vm.zoneType == "Fuel" || vm.zoneType == "Adblue" ? true : false)
                
                
                CustomTextField(icon: "car.rear.waves.up.fill", title: "Select Toll", text: $vm.toll, show: vm.zoneType == "Toll" ? true : false)
                
                
                CustomTextField(icon: "banknote", title: "Amount", text: $vm.amount)
                
                // payment mode Picker
                HStack(alignment: .center, spacing: 10) {
                    
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    Text("Payment Mode")
                        .foregroundStyle(Color(.systemGray))
                    
                    Spacer()
                    
                    Picker("", selection: $vm.paymentMode) {
                        
                        ForEach(AddTripExpensesViewModel.PaymentMode.allCases) { type in
                            Text("\(type.rawValue)")
                                .tag(type)
                            
                        }
                    }
                    .tint(.black)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                
                
                CustomTextField(icon: "ellipsis.message.fill", title: "Comments", text: $vm.comments)
                
                
                Section {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        
                        HStack {
                            
                            ForEach(vm.imageArray, id: \.self) { image in
                                
                                ImagePreview(uiImage: image)
                                    .overlay {
                                        
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .background(Circle().fill(.white))
                                            .foregroundStyle(.red)
                                            .offset(x: 42, y: -42)
                                        
                                            .onTapGesture {
                                                
                                                vm.imageArray.removeAll(where: { $0 == image })
                                                
                                            }
                                        
                                    }
                            }
                        }
                        
                    }
                    
                    
                    .alert("lbl_set_profile_photo", isPresented: $vm.showImagePicker) {
                        
                        Button(LocalizedStringKey("lbl_take_camera_picture")) {
                            coordinator.push(.miscellaneous(.cameraCapture(image: $vm.selectedImage, sourceType: .camera)))
                        }
                        
                        Button(LocalizedStringKey("lbl_choose_from_gallery")) {
                            coordinator.push(.miscellaneous(.cameraCapture(image: $vm.selectedImage, sourceType: .photoLibrary)))
                        }
                        
                    }
                    
                    
                } header: {
                    
                    HStack {
                        
                        Image(systemName: "camera.fill")
                            .font(.title)
                        
                        Text(LocalizedStringResource("upload"))
                            .font(Font.custom("ArialRoundedMTBold", size: 20))
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.thinMaterial)
                    .foregroundStyle(Color(.systemGray))
                    
                    .onTapGesture {
                        vm.showImagePicker = true
                    }
                    
                }
                
            }
            .padding(.horizontal)
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            
            //
            .onAppear {
                vm.checkCapturedImage()
                
                vm.assetId = "\(assetId)"
                
                vm.tripId = "\(tripId)"
                
                vm.expenseId = "\(expenseId)"
            }
            
            // onAppear calls before tripExpenseAttributes set up, onChange works
            .onChange(of: apiService.tripExpenseAttributes.result) { old, new in
                vm.getData(new)
                
            }
            
            
            Button {
                
                if isEditing {
                    
                    vm.putData(apiService)
                    
                } else {
                    
                    vm.postData(apiService)
                }
                
            } label: {
                Text(LocalizedStringResource("save"))
                    .modifier(SaveButtonModifier())
                    .padding(.horizontal)
            }
            
        }
        .ignoresSafeArea(.keyboard)
        
        .loadingScreen(isLoading: vm.isLoading)
        
        .successAlert(success: $vm.success, failed: $vm.failed, message: "Expense saved successfully", coordinator: coordinator)
    }
    
}

@MainActor
fileprivate class AddTripExpensesViewModel: ObservableObject {
    
    @Published var vehicleNumber = ""
    @Published var zoneType: String?
    @Published var date = Date()
    @Published var location = ""
    @Published var costPerLiter = ""
    @Published var billNo = ""
    @Published var liters = ""
    @Published var odo = ""
    @Published var toll = ""
    @Published var amount = ""
    @Published var comments = ""
    
    @Published var showImagePicker: Bool = false
    @Published var selectedImage: UIImage = .init()
    @Published var imageArray: [UIImage] = []
    
    @Published var isLoading: Bool = false
    @Published var success: Bool = false
    @Published var failed: Bool = false
    
    var assetId: String = ""
    var tripId: String = ""
    var expenseId: String = ""
    
    enum PaymentMode: String, CaseIterable, Identifiable {
        case cash = "Cash"
        
        var id: String { self.rawValue }
    }
    
    @Published var paymentMode: String = "Cash"
    
    func getData(_ expenseData: APIService.TripExpense.Result) {
        
        zoneType = expenseData.type ?? ""
        costPerLiter = expenseData.details.costPerLiter ?? ""
        billNo = expenseData.details.billNumber ?? ""
        odo = expenseData.details.odo ?? ""
        liters = expenseData.details.liters ?? ""
        
        location = expenseData.location.name ?? ""
        amount = expenseData.amount ?? ""
        comments = expenseData.comments ?? ""
        
        imageArray = expenseData.images
        
    }
        
    func postData(_ apiService: APIService) {
        
        Task {
            
            do {
                isLoading = true
                
                try await apiService.postTripExpense(
                    assetId: assetId,
                    tripId: tripId,
                    paymentMode: paymentMode,
                    date: date.toString(format: "dd-MM-yyyy HH:mm:a"),
                    type: zoneType ?? "",
                    location: location,
                    details: #"{ "billNumber": "\#(billNo)", "costPerLiter": "\#(costPerLiter)", "liters": "\#(liters)", "odo": "\#(odo)" }"#,
                    amount: amount,
                    comments: comments,
                    images: imageArray
                )
                
                try await apiService.getTripsData(cachePolicy: .reloadIgnoringLocalCacheData)
                
                isLoading = false
                success = true
                
            } catch {
                isLoading = false
                failed = true
            }
            
        }
        
    }
    
    func putData(_ apiService: APIService) {
        
        Task {
            
            do {
                                
                try await apiService.putTripExpense(
                    assetId: assetId,
                    tripId: tripId,
                    expenseId: expenseId,
                    paymentMode: paymentMode,
                    date: date.toString(format: "dd-MM-yyyy HH:mm:a"),
                    type: zoneType ?? "",
                    location: #"{ "lat": "0.0", lon: "0.0", name: "\#(location)" }"#,
                    details: #"{ "billNumber": "\#(billNo)", "costPerLiter": "\#(costPerLiter)", "liters": "\#(liters)", "odo": "\#(odo)" }"#,
                    amount: amount,
                    comments: comments,
                    images: imageArray
                )
                
            } catch {
                print("catched \(error)")
            }
            
        }
        
    }
    
 
    func checkCapturedImage() {
        if selectedImage.size.width > 0 && selectedImage.size.height > 0 {
            imageArray.append(selectedImage)
        }
        
        selectedImage = UIImage()
    }
    
    
    func getTypesinTamil() -> [String] {
        
        let tamilExpenseTypes = [
            "டீசல்",
            "சுங்கச்சாவடி",
            "அட்ப்ளூ",
            "ஆர்டிஓ",
            "போலிஸ்",
            "லோடிங்",
            "அன்லோடிங்",
            "நிறுத்துதல்",
            "வேய் பிரிட்ஜ் - லோடிங்",
            "வேய் பிரிட்ஜ் - அன்லோடிங்",
            "பார்க்கிங்",
            "பூஜை",
            "பழுதுபார்க்கும் செலவு w/ பில்",
            "பழுதுபார்க்கும் செலவு w/o பில்",
            "மிஸ்க்",
            "கேட் என்ட்ரி",
            "கிளீனர்",
            "அட்ஜஸ்ட்மென்ட்",
            "ஓட்டுநர் சம்பளம்",
            "அலொவன்ஸ்",
            "ஊக்கத்தொகை",
            "டிரைவர் பட்டா",
            "பழுதுபார்க்கும் பணிகள்",
            "ஆர்டிஓ செலவுகள்",
            "கிரீசிங்",
            "வாட்டர் சர்வீஸ்",
            "பஞ்சர்",
            "மோர்த் - ஓடிசி பர்மிஷன்",
            "உணவு",
            "பாதை வழிகாட்டி",
            "பண்டில் சார்ஜஸ்",
            "அதர்ஸ்",
            "டிடக்‌ஷன் ரீயம்பர்ஸ்மெண்ட்",
            "டயர் ரொட்டேஷன் / பவுடர்",
            "பிளாப்",
            "நியூ டயர்",
            "அலைனஂமெண்ட்",
            "சர்வீஸ்",
            "ஆயில் சர்வீஸ்",
            "அதர்ஸ் சர்வீஸ்",
            "பிரேக்டௌன்",
            "கிரீசிங் / ஆட்டோ",
            "எலக்ட்ரிகல்",
            "அசிஸ்சொரிஸ்",
            "அதிக சுமை"
        ]

        return tamilExpenseTypes
       
    }
    
}


#Preview {
//    TripExpensesAddView()
}
