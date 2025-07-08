//
//  ExpensesAdd.swift
//  MyApp2
//
//  Created by Nirmal kumar on 26/06/25.
//

import SwiftUI
import RealmSwift


struct ExpenseAddView: View {
    
    @ObservedObject var realmManager: RealmManager
    
        
    @State var name: String = ""
    @State var amount: Int = 0
    @State var notes: String = ""
    @State private var default_category_selection: String = "Food"
    @State var date: Date = Date()
    
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
    
    @State private var credit_amount: Int = 0
    
    
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
            
            Text("Add Expense")
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
                
            //                    .toolbar {
            //
            //                        ToolbarItemGroup(placement: .keyboard) {
            //                            Spacer()
            //                            Button("Done") {
            //                                focusedField = nil
            //                            }
            //                        }
            //
            //                    }
            }
            
            
            VStack(spacing: 10) {
                
                Text("Notes")
                    .font(Font.custom("GillSans", size: fieldTitleFont))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                
                TextField("...", text: $notes)
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
            
           
                
        }
        .onSubmit {
            switch focusedField {
            case .name:
                focusedField = .amount
            default:
                break
            }
        }
        
        .disabled(show_alert)
        
        
        Button(action: {
            
            if amount > realmManager.get_bank_balance() {
                alert_status = .fail
                
                show_alert = true
                
                return // so no transaction
                
            }
            
            realmManager.create_expense(name: name, amount: amount, notes: notes, category: default_category_selection, date: date)
            
            
            alert_status = .success
            
            show_alert = true
            
            //
            //                if realmManager.get_bank_balance() < 100 {
            //
            //                    realmManager.add_expense(name: "to \(realmManager.get_account_number())", amount: 250, category: "Credit", date: Date.now)
            //                }
            
            
        }) {
            Text("Save")
                .frame(maxWidth: .infinity)
                .frame(height: buttonHeight)
                .background(Color.blue.gradient)
                .foregroundStyle(.white)
                .cornerRadius(5)
            
                .font(Font.custom("ArialRoundedMTBold", size: buttonFont - buttonFont * 0.25))
                .padding(.horizontal)
            
        }
        
        // It appears having two alerts second alert overrides first one
        // .alert cannot be used as with switch case in this case, as I need TextField for fail, so this is overlay way with manually creatign Rounded Rectangle
        
        .overlay() {
            
            if show_alert {
                
                switch alert_status {
                    
                case .success:
                    
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(.bar)
                        .frame(width: UIScreen.main.bounds.height / 3, height: UIScreen.main.bounds.width / 3.5)
                        .overlay {
                            
                            VStack(alignment: .center) {
                                
                                Text("Expense \(name) Created")
                                    .font(Font.custom("ArialRoundedMTBold", size: buttonFont - buttonFont * 0.25))
                                
                                Spacer()
                                Divider()
                                
                                Button("Okay") {
                                    
                                    show_alert = false
                                    dismiss()
                                }
                                
                            }
                            .padding(.vertical, 20)
                            
                        }
                        .padding(.bottom, 150)
                    
                    
                    
                    
                case .fail:
                    
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(.bar)
                        .frame(width: UIScreen.main.bounds.height / 2.5, height: UIScreen.main.bounds.width / 2)
                        .overlay {
                            
                            VStack(alignment: .center) {
                                
                                Text("Cannot Create Expense \n Enter the amount to be credited")
                                    .font(Font.custom("ArialRoundedMTBold", size: buttonFont - buttonFont * 0.25))
                                
                                
                                TextField("", value: $credit_amount, format: .number)
                                    .textFieldStyle(.roundedBorder)
                                    .padding(.horizontal,50)
                                    .padding(.vertical, 15)
                                    .font(Font.custom("ArialRoundedMTBold", size: buttonFont - buttonFont * 0.25))
                                
                                
                                HStack {
                                    Button("cancel", role: .cancel) {
                                        show_alert = false
                                    }
                                    
                                    Spacer()
                                    
                                    Button("Confirm") {
                                        realmManager.create_expense(name: "to \(realmManager.get_account_number())", amount: credit_amount, notes: "", category: "Credit", date: Date.now)
                                        
                                        dismiss()
                                        
                                    }
                                }
                                .padding(.horizontal,50)
                            }
                        }
                        .padding(.bottom, 175)
                    
                    
                default:
                    Text("") // this will never called anyway
                    
                }
            }
        }
            
    }
        
}
    



#Preview {
    
    ExpenseAddView(realmManager: RealmManager())
    
}
