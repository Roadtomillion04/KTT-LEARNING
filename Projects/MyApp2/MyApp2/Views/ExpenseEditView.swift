//
//  ExpenseEditView.swift
//  MyApp2
//
//  Created by Nirmal kumar on 01/07/25.
//


import SwiftUI
import RealmSwift


struct ExpenseEditView: View {
    
    @ObservedObject var realmManager: RealmManager
    
    @State var name: String
    @State var amount: Int
    @State var default_category_selection: String
    @State var date: Date
    
    var _id: ObjectId // for finding the swiped expense in file
    
    @Environment(\.dismiss) var dismiss
    
//    @State private var expense_create_success: Bool = false
//    @State private var expense_greater_than_balance: Bool = false


    private let layoutProperties: UserRegisterViewLayoutProperties = UserRegisterViewgetPreviewLayoutProperties()

    
    let categories = ["Food", "Transport", "Entertainment", "Bills", "Groceries"]
    
    
    enum Field {
        case name
        case amount
    }
    
    @FocusState private var focusedField: Field?
    
    
    enum Alerts {
        case success // expense_create_success
        case fail // expense_greater_than_balance
    }
    
    @State private var alert_status: Alerts?
    @State private var show_alert: Bool = false
    
    
//    init(name: String, amount: Int, category: String, date: Date) {
//        self.name = name
//        self.amount = amount
//        self.default_category_selection = category
//        self.date = date
//    }
//    
    
    var body: some View {
            
//    GeometryReader { _ in
        ScrollView {
        
//        ViewThatFits(in: .vertical) {
            
            mainContent(
                
                titleFont: layoutProperties.customFontSize.smallMedium,
                fieldTitleFont: layoutProperties.customFontSize.smallMedium,
                fieldFont: layoutProperties.customFontSize.smallMedium,
                fieldHeight: layoutProperties.dimensValues.smallMedium,
                buttonHeight: layoutProperties.dimensValues.smallMedium,
                buttonFont: layoutProperties.customFontSize.smallMedium
                
            )
            
//            mainContent(
//
//                titleFont: layoutProperties.customFontSize.small,
//                fieldTitleFont: layoutProperties.customFontSize.small,
//                fieldFont: layoutProperties.customFontSize.small,
//                fieldHeight: layoutProperties.dimensValues.small,
//                buttonHeight: layoutProperties.dimensValues.small,
//                buttonFont: layoutProperties.customFontSize.small
//
//            )
            
//        }
    }
    .scrollIndicators(.hidden)
    .scrollBounceBehavior(.basedOnSize)
//    .ignoresSafeArea(.keyboard, edges: .all)
    
    
}
        
    @ViewBuilder
    private func mainContent(
        
        titleFont: CGFloat,
        fieldTitleFont: CGFloat,
        fieldFont: CGFloat,
        fieldHeight: CGFloat,
        buttonHeight: CGFloat,
        buttonFont: CGFloat
        
    ) -> some View {
        
            
        VStack(spacing: 25) {
            
            Text("Edit Expense")
                .font(Font.custom("ArialRoundedMTBold", size: titleFont * 1.25))
            
            Divider()
                .hidden()
            
            VStack(spacing: 10) {
                
                Text("Name")
                    .font(Font.custom("GillSans", size: fieldTitleFont))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                
                TextField("Breakfast", text: $name)
                    .frame(width: .infinity, height: fieldHeight)
                    .font(Font.custom("", size: fieldFont - fieldFont * 0.25))
                    .foregroundStyle(Color.black)
                
                
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 5)
                    ).foregroundStyle(Color(hex:0xF1F5F9))
                    .padding(.horizontal, 20)
                
                    .focused($focusedField, equals: .name)
                    .textContentType(.givenName)
                    .submitLabel(.next)
                
               
            }

            
            VStack(spacing: 10) {
                
                Text("Amount")
                    .font(Font.custom("GillSans", size: fieldTitleFont))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                
                // for Int TextField
                TextField("", value: $amount, format: .number)
                    .frame(width: .infinity, height: fieldHeight)
                    .font(Font.custom("", size: fieldFont - fieldFont * 0.25))
                    .foregroundStyle(Color.black)
                
                
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 5)
                    ).foregroundStyle(Color(hex:0xF1F5F9))
                    .padding(.horizontal, 20)
                    .keyboardType(.numberPad)
                
                    .focused($focusedField, equals: .amount)
                
                    .toolbar {
                        
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                focusedField = nil
                            }
                        }
                        
                    }
            }
            
            
            
            HStack(spacing: 0) {
                
                Text("Categories")
                    .font(Font.custom("GillSans", size: fieldTitleFont))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                
                
                Picker("Category", selection: $default_category_selection) {
                    
                    ForEach(categories, id: \.self) { category in
                        
                        Text(category)
                            .background(.black)
                    }
                    
                }
                .background(RoundedRectangle(cornerRadius: 5)
                ).foregroundStyle(Color(hex:0xF1F5F9))
                
                    .padding(.horizontal)
                
            }
            
            HStack(spacing: 10) {
                
                Text("Date")
                    .font(Font.custom("GillSans", size: fieldTitleFont))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                DatePicker("", selection: $date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal, 20)
                
            }
            
            
            Spacer()
            
            Button(action: {
                
                if amount > realmManager.get_bank_balance() {
                    
                    alert_status = .fail
                    
                    show_alert = true
                    
                    return // so no transaction
                    
                }
                
                realmManager.edit_expense(id: _id, name: name, amount: amount, category: default_category_selection, date: date)
                
                alert_status = .success
                
                show_alert = true }) {
                    
                Text("Update")
                    .frame(maxWidth: .infinity)
                    .frame(height: buttonHeight)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(5)
                
                    .font(Font.custom("ArialRoundedMTBold", size: buttonFont - buttonFont * 0.25))
                    .padding(.horizontal)
  
            }
            
            // It appears having two alerts second alert overrides first one
            
            .alert(isPresented: $show_alert) {
                
                switch alert_status {
                
                case .success:
                    
                    Alert(title: Text("Expense Edited Successfully"), message: Text("Expense \(name) changes saved"), dismissButton: .default(Text("OK")) {
                        
                        dismiss()
                        
                    })
                    
                case .fail:
                
                    Alert(title: Text("Cannot create Expense!"), message: Text("Expense \(name) costs \(amount) \n Balance left: \(realmManager.get_bank_balance())"), dismissButton:  .default(Text("Close")) {

                        
                        //                        realmManager.add_expense(name: "to \(realmManager.get_account_number())", amount: 250, category: "Credit", date: Date.now)
                        
                        
                        dismiss()
                        
                    })
                    
                default:
                    Alert(title: Text(""))
                    
                   
                    }
                
                
                }
                
            }
            .onSubmit {
                switch focusedField {
                case .name:
                    focusedField = .amount
                default:
                    break
                }
            }
            
        }
        
        
}

#Preview {
    
//    ExpenseEditView(realmManager: RealmManager())
    
}

