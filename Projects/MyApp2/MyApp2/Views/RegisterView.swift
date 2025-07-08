//
//  RegisterView.swift
//  MyApp2
//
//  Created by Nirmal kumar on 26/06/25.
//

import SwiftUI

import RealmSwift


struct RegisterView: View {
    
    @ObservedObject var realmManager: RealmManager

    @State private var user_name: String = ""
    @State private var user_email: String = ""
    @State private var user_password: String = ""
    @State private var bank_name: String = ""
    @State private var account_number: String = ""
    @State private var register_success: Bool = false
    
    let layoutProperties: UserRegisterViewLayoutProperties = UserRegisterViewgetPreviewLayoutProperties()
    
    @Environment(\.dismiss) var dismiss

    
    enum Field {
        case name
        case email
        case password
        case bank_name
        case account_number
    }
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        
        // rescaling only in potrait mode
        
//        GeometryReader { _ in // so this geometry reader was messing up with the scroll View, without it ScrollView works as Intended
        
    
//                ViewThatFits(in: .vertical) {
                
                    mainContent(
                        
                        titleFont: layoutProperties.customFontSize.large,
                        fieldTitleFont: layoutProperties.customFontSize.large,
                        fieldFont: layoutProperties.customFontSize.large,
                        fieldHeight: layoutProperties.dimensValues.large,
                        buttonHeight: layoutProperties.dimensValues.large,
                        buttonFont: layoutProperties.customFontSize.large
                        
                    )
                    
                    
//                    mainContent(
//                        
//                        titleFont: layoutProperties.customFontSize.mediumLarge,
//                        fieldTitleFont: layoutProperties.customFontSize.mediumLarge,
//                        fieldFont: layoutProperties.customFontSize.mediumLarge,
//                        fieldHeight: layoutProperties.dimensValues.mediumLarge,
//                        buttonHeight: layoutProperties.dimensValues.mediumLarge,
//                        buttonFont: layoutProperties.customFontSize.mediumLarge
//                        
//                    )
//                    
//                    
//                    mainContent(
//                        
//                        titleFont: layoutProperties.customFontSize.medium,
//                        fieldTitleFont: layoutProperties.customFontSize.medium,
//                        fieldFont: layoutProperties.customFontSize.medium,
//                        fieldHeight: layoutProperties.dimensValues.medium,
//                        buttonHeight: layoutProperties.dimensValues.medium,
//                        buttonFont: layoutProperties.customFontSize.medium
//                        
//                    )
//                    
//                    mainContent(
//                        
//                        titleFont: layoutProperties.customFontSize.smallMedium,
//                        fieldTitleFont: layoutProperties.customFontSize.smallMedium,
//                        fieldFont: layoutProperties.customFontSize.smallMedium,
//                        fieldHeight: layoutProperties.dimensValues.smallMedium,
//                        buttonHeight: layoutProperties.dimensValues.smallMedium,
//                        buttonFont: layoutProperties.customFontSize.smallMedium
//                        
//                    )
//                    
//                    mainContent(
//                        
//                        titleFont: layoutProperties.customFontSize.small,
//                        fieldTitleFont: layoutProperties.customFontSize.small,
//                        fieldFont: layoutProperties.customFontSize.small,
//                        fieldHeight: layoutProperties.dimensValues.small,
//                        buttonHeight: layoutProperties.dimensValues.small,
//                        buttonFont: layoutProperties.customFontSize.small
//                        
//                    )
//                    
//                }
            
      
        
//        .ignoresSafeArea(.keyboard, edges: .bottom)
    
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
        
            
            VStack(spacing: 20) {
                    
                    
                    Text("Create Account")
                    // as this is the best I can think of now, evey font will be in same size, so for title I have to manually aggregate here
                    
                    // it's affecting landscape so do it only for potrait mode
                    
                        .font(Font.custom("ArialRoundedMTBold", size: titleFont))
                        .padding(.bottom)
                }
                
                
            VStack {
                    
                    ScrollView {
 
                    inputField(title: "Name", text: $user_name, titleFont: fieldTitleFont, fieldFont: fieldFont, height: fieldHeight)
                        .focused($focusedField, equals: .name)
                        .textContentType(.givenName)
                        .submitLabel(.next)
                        .disableAutocorrection(true)
                    
                    inputField(title: "Email", text: $user_email, titleFont: fieldTitleFont, fieldFont: fieldFont, height: fieldHeight)
                        .focused($focusedField, equals: .email)
                        .textContentType(.emailAddress)
                        .submitLabel(.next)
                        .disableAutocorrection(true)
                    
                    secureField(title: "Password", text: $user_password, titleFont: fieldTitleFont, fieldFont: fieldFont, height: fieldHeight)
                        .focused($focusedField, equals: .password)
                        .textContentType(.newPassword)
                        .submitLabel(.next)
                        .disableAutocorrection(true)
                    
                    inputField(title: "Bank", text: $bank_name, titleFont: fieldTitleFont, fieldFont: fieldFont, height: fieldHeight)
                        .focused($focusedField, equals: .bank_name)
                        .textContentType(.name)
                        .submitLabel(.next)
                        .disableAutocorrection(true)
                    
                    inputField(title: "Account Number", text: $account_number, titleFont: fieldTitleFont, fieldFont: fieldFont, height: fieldHeight)
                        .focused($focusedField, equals: .account_number)
                        .textContentType(.creditCardNumber)
                    
                        .toolbar {
                            
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Done") {
                                    focusedField = nil
                                }
                            }
                            
                        }
                    
                }
                .scrollIndicators(.hidden)
                .scrollBounceBehavior(.basedOnSize)
                
                .safeAreaInset(edge: .bottom) { // this under scroll view, sets button at the bottom
                    Button(action: { register_success =   realmManager.register_user(user_name: user_name, user_email: user_email, user_password: user_password, user_bank_name: bank_name, user_account_number: account_number) }) {
                        
                        Text("Register")
                            .frame(maxWidth: .infinity)
                            .frame(height: buttonHeight)
                            .background(Color.blue.gradient)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                            .font(Font.custom("ArialRoundedMTBold", size: buttonFont - buttonFont * 0.5))
                        
                    }
                    .position(x: layoutProperties.width / 2 - 14, y: layoutProperties.height - layoutProperties.height * 0.25)
            
                    .alert(isPresented: $register_success) {
                        Alert(
                            title: Text("Register Complete"),
                            message: Text("User \(user_name) Added"),
                            dismissButton: .default(Text("OK")) {
                                dismiss()
                            }
                            
                        )
                    }
                    .padding(.horizontal)
                }
                
            }
            .onSubmit {
                switch focusedField {
                    
                case .name:
                    focusedField = .email
                case .email:
                    focusedField = .password
                case .password:
                    focusedField = .bank_name
                case .bank_name:
                    focusedField = .account_number
                    
                default:
                    break
                }
            
                    
            }

        }
                   
    }
            
    
    func inputField(title: String, text: Binding<String>, titleFont: CGFloat, fieldFont: CGFloat, height: CGFloat) -> some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.custom("GillSans", size: fieldFont - fieldFont * 0.5))

                .frame(maxWidth: .infinity, alignment: .leading)
                
                
            
            TextField("Enter your \(title)", text: text)
                .frame(height: height)
                .font(Font.custom("", size: fieldFont - fieldFont * 0.5))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color(hex: 0xF1F5F9))
                )
                        }
        .padding(.horizontal)
    }
    
    func secureField(title: String, text: Binding<String>, titleFont: CGFloat, fieldFont: CGFloat, height: CGFloat) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.custom("GillSans", size: fieldFont - fieldFont * 0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
               
            
            SecureField("Enter your \(title)", text: text)
                .frame(height: height)
                .font(Font.custom("", size: fieldFont - fieldFont * 0.5))
                .foregroundColor(.black)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .foregroundStyle(Color(hex: 0xF1F5F9))
                )
        }
        .padding(.horizontal)
    
    
}


#Preview {
    
    RegisterView(realmManager: RealmManager())
    
}
