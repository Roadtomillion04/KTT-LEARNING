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
    let tripId: Int
    let assetId: Int
    let expenseId: Int
    let startDate: String
    let endDate: String
    
    var body: some View {
        
        VStack {
            
            ScrollView {
                
                Label(apiService.driverStatusModel.trip?.lplate ?? "", systemImage: "truck.box.fill")
                    .font(Font.custom("Monaco", size: 14))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
                
                HStack(alignment: .center, spacing: 10) {
                    
                    Image(systemName: "rectangle.grid.3x1.fill")
                        .foregroundColor(.gray)
                    
                    Text(LocalizedStringResource("select_type"))
                        .font(Font.custom("Monaco", size: 13))
                        .foregroundStyle(Color(.systemGray))
                    
                    Spacer()
                    
                    
                    if languageManager.selectedLanguage == Locale(identifier: "ta") {
                        
                        Picker("", selection: $vm.zoneType) {
                            
                            Text("None") // None option
                                .tag(nil as String?)
                            
                            
                            ForEach(vm.getTypesinTamil(), id: \.self) { types in
                                Text(types)
                                    .font(Font.custom("Monaco", size: 12.5))
                                    .tag(types)
                                
                            }
                            
                        }
                        .tint(.black)
                    }
                    
                    else  {
                    
                    Picker("", selection: $vm.zoneType) {
                        
                        ForEach(vm.expenseZoneTypes, id: \.self) { types in
                            Text(types.text ?? "")
                                .font(Font.custom("Monaco", size: 12.5))
                                .tag(types.text ?? "")
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
                
                CustomTextField(icon: "indianrupeesign.circle", title: "Cost/Ltr", text: $vm.costPerLiter, show: vm.zoneType == "Fuel" ? true : false, keyboardType: .decimalPad)
                    .formatDouble($vm.costPerLiter)
                
                    .onChange(of: vm.costPerLiter) { old, new in
                        if vm.liters != "" {
                            vm.amount = String((Double(new) ?? 0) * (Double(vm.liters) ?? 0))
                        }
                    }
                
                CustomTextField(icon: "receipt", title: "Bill No", text: $vm.billNo, show: vm.zoneType == "Fuel" ? true : false)
                
                CustomTextField(icon: "fuelpump", title: "Litres", text: $vm.liters, show: vm.zoneType == "Fuel" || vm.zoneType == "Adblue" ? true : false, keyboardType: .decimalPad)
                    .formatDouble($vm.liters)
                
                    .onChange(of: vm.liters) { old, new in
                        if vm.costPerLiter != "" {
                            vm.amount = String((Double(new) ?? 0) * (Double(vm.costPerLiter) ?? 0))
                        }
                    }
                
                CustomTextField(icon: "gauge", title: "Odo", text: $vm.odo, show: vm.zoneType == "Fuel" || vm.zoneType == "Adblue" ? true : false, keyboardType: .decimalPad)
                    .formatDouble($vm.odo)
                
                
                CustomTextField(icon: "car.rear.waves.up.fill", title: "Select Toll", text: $vm.toll, show: vm.zoneType == "Toll" ? true : false)
                
                
                CustomTextField(icon: "banknote", title: "Amount", text: $vm.amount, keyboardType: .decimalPad)
                    .formatDouble($vm.amount)
                
                
                // payment mode Picker
                HStack(alignment: .center, spacing: 10) {
                    
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                    
                    Text("Payment Mode")
                        .font(Font.custom("Monaco", size: 12.5))
                        .foregroundStyle(Color(.systemGray))
                    
                    Spacer()
                    
                    Picker("", selection: $vm.paymentMode) {
                        
                        ForEach(AddTripExpensesViewModel.PaymentMode.allCases) { type in
                            Text("\(type.rawValue)")
                                .font(Font.custom("Monaco", size: 12.5))
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
                                            .font(.headline)
                                            .background(Circle().fill(.white))
                                            .foregroundStyle(.red)
                                            .offset(x: 35, y: -35)
                                        
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
                            .font(.headline)
                        
                        Text(LocalizedStringResource("upload"))
                            .font(Font.custom("ArialRoundedMTBold", size: 15))
                        
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
                
                vm.expenseId = "\(expenseId)"
                
                vm.tripId = "\(tripId)"
                
                vm.assetId = "\(assetId)"
                
                vm.isEditing = isEditing
                
                vm.startDate = startDate
                vm.endDate = endDate
                
                print("add view appeared")
                print(expenseId, tripId, assetId, isEditing)
                
            }
           
            .task {
                if !vm.sceneEntered {
                    await vm.onAppear(apiService)
                    vm.sceneEntered = true // only ffresets on pop/back
                }
            }
            
            Button {
                
                Task {
                    
                    await vm.saveAction(apiService)
                }
                
            } label: {
                Text(LocalizedStringResource("save"))
                    .modifier(SaveButtonModifier())
                    .padding(.horizontal)
            }
            
        }
        .ignoresSafeArea(.keyboard)
        
        .loadingScreen(isLoading: vm.isLoading)
        
        .successAlert(success: $vm.success, message: "Expense saved successfully", coordinator: coordinator)
        
        .toast(message: $vm.toastMessage)
        
        .toolbar {
            
            ToolbarItem(placement: .keyboard) {
                    
                Button("done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }

    }
    
}

@MainActor
fileprivate class AddTripExpensesViewModel: ObservableObject {
    
    @Published var vehicleNumber = ""
    @Published var zoneType: String = ""
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
    
    var assetId: String = ""
    var tripId: String = ""
    var expenseId: String = ""
    var isEditing: Bool = false
    var startDate: String = ""
    var endDate: String = ""
    
    @Published var expenseZoneTypes: [APIService.ExpenseZoneTypesModel.Results] = []
    
    enum PaymentMode: String, CaseIterable, Identifiable {
        case cash = "Cash"
        
        var id: String { self.rawValue }
    }
    
    @Published var paymentMode: String = "Cash"
    
    @Published var sceneEntered: Bool = false
    
    enum FieldValidation: String {
        case location = "Location Mandatory"
        case amount = "Amount Mandatory"
    }
    
    @Published var toastMessage: String?
    
    
    func onAppear(_ apiService: APIService) async {
        
        var expenseData: APIService.TripExpenseEditModel.Result?
        
        do {
            if isEditing {
                expenseData = try await apiService.getTripExpense(expenseId)
                
                await parseData(expenseData!, apiService)
            }
            
            expenseZoneTypes = try await apiService.getTripExpenseZoneTypes()
            
            // expenseType api has to finish first
            if !isEditing {
                zoneType = expenseZoneTypes.first?.text ?? ""
            }
            
        } catch {
            
        }
        
    }
    
    func parseData(_ expenseData: APIService.TripExpenseEditModel.Result, _ apiService: APIService) async {
        
        zoneType = expenseData.type ?? ""
        costPerLiter = expenseData.details?.costPerLiter ?? ""
        billNo = expenseData.details?.billNumber ?? ""
        odo = expenseData.details?.odo ?? ""
        liters = expenseData.details?.liters ?? ""
        
        location = expenseData.location?.name ?? ""
        amount = expenseData.amount ?? ""
        comments = expenseData.comments ?? ""
        
        
        for imageUrl in expenseData.images {
            imageArray.append( await apiService.downloadImage(urlString: imageUrl) )
        }
    }
    
    func saveAction(_ apiService: APIService) async {
        
        if location.isEmpty {
            toastMessage = FieldValidation.location.rawValue
            return
        }
        
        if amount.isEmpty {
            toastMessage = FieldValidation.amount.rawValue
            return
        }
        
        if isEditing {
        
            await putData(apiService)
            
        } else {
            
            await postData(apiService)
            
        }
    }
        
    func postData(_ apiService: APIService) async {

        do {
            isLoading = true
            
            print(tripId, assetId, "POST")
            
            success = try await apiService.postTripExpense(
                assetId: assetId,
                tripId: tripId,
                paymentMode: paymentMode,
                date: date.toString(format: "dd-MM-yyyy HH:mm:a"),
                type: zoneType,
                location: location,
                details: #"{ "billNumber": "\#(billNo)", "costPerLiter": "\#(costPerLiter)", "liters": "\#(liters)", "odo": "\#(odo)" }"#,
                amount: amount,
                comments: comments,
                images: imageArray
            )
            
            try await apiService.getTripsData(startDate: startDate, endDate: endDate)
            
            isLoading = false
            
        } catch {
            isLoading = false
        }
        
        
    }
    
    func putData(_ apiService: APIService) async {
    
        do {
                       
            isLoading = true
            
            print(tripId, assetId, "PUT")
            
            success = try await apiService.putTripExpense(
                assetId: assetId,
                tripId: tripId,
                expenseId: expenseId,
                paymentMode: paymentMode,
                date: date.toString(format: "dd-MM-yyyy HH:mm:a"),
                type: zoneType,
                location: location,
                details: #"{ "billNumber": "\#(billNo)", "costPerLiter": "\#(costPerLiter)", "liters": "\#(liters)", "odo": "\#(odo)" }"#,
                amount: amount,
                comments: comments,
                images: imageArray
            )
            
            try await apiService.getTripsData(startDate: startDate, endDate: endDate)
            
            isLoading = false
            
        } catch {
            isLoading = false
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

// Model
extension APIService {
    
    // for editing data in addTripExpense
    struct TripExpenseEditModel: Decodable {
        var success: Bool?
        var result: Result?
        var error: String?
        
        enum CodingKeys: String, CodingKey {
            case success
            case result = "TripExpense"
            case error
        }
        
        struct Result: Hashable, Decodable {
            var id: Int?
            var date, type: String?
            var location: Location?
            var details: Details?
            var amount, paymentMode: String?
            var comments: String?
            var images: [String] = []
            
            enum CodingKeys: String, CodingKey {
                case id
                case date
                case type
                case location
                case details
                case amount
                case paymentMode
                case comments
                case images
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<APIService.TripExpenseEditModel.Result.CodingKeys> = try decoder.container(keyedBy: APIService.TripExpenseEditModel.Result.CodingKeys.self)
                
                self.id = try container.decodeIfPresent(Int.self, forKey: APIService.TripExpenseEditModel.Result.CodingKeys.id)
                
                self.date = try container.decodeIfPresent(String.self, forKey: APIService.TripExpenseEditModel.Result.CodingKeys.date)
                
                self.type = try container.decodeIfPresent(String.self, forKey: APIService.TripExpenseEditModel.Result.CodingKeys.type)
                
                self.location = try container.decodeIfPresent(APIService.TripExpenseEditModel.Location.self, forKey: APIService.TripExpenseEditModel.Result.CodingKeys.location)
                
                self.details = try container.decodeIfPresent(APIService.TripExpenseEditModel.Details.self, forKey: APIService.TripExpenseEditModel.Result.CodingKeys.details)
                
                self.amount = try container.decodeIfPresent(String.self, forKey: APIService.TripExpenseEditModel.Result.CodingKeys.amount)
                
                self.paymentMode = try container.decodeIfPresent(String.self, forKey: APIService.TripExpenseEditModel.Result.CodingKeys.paymentMode)
                
                self.comments = try container.decodeIfPresent(String.self, forKey: APIService.TripExpenseEditModel.Result.CodingKeys.comments)
                
                let imageUrls = try container.decodeIfPresent([String].self, forKey: APIService.TripExpenseEditModel.Result.CodingKeys.images) ?? []
                
                self.images = imageUrls.map( { "https://dev.ktt.io/api/upload/file" + $0 } )
                
            }
        }
        
        struct Details: Hashable, Decodable {
            var billNumber: String?
            var costPerLiter: String?
            var liters: String?
            var odo: String?
        }
        
        struct Location: Hashable , Decodable {
            var name: String?
        }

    }
    
    struct ExpenseZoneTypesModel: Hashable, Decodable {
        var success: Bool?
        var results: [Results] = []
        var error: String?
        
        enum CodingKeys: CodingKey {
            case success
            case results
            case error
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            success = try container.decodeIfPresent(Bool.self, forKey: .success)
            results = try container.decodeIfPresent([Results].self, forKey: .results) ?? []
            error = try container.decodeIfPresent(String.self, forKey: .error)
        }
        
        struct Results: Hashable, Decodable {
            var text: String?
        }
        
    }
    
}

#Preview {
//    TripExpensesAddView()
}

