//
//  LoginView.swift
//  Expense Mangement
//
//  Created by Nirmal kumar on 12/06/25.
//

import SwiftUI
import RealmSwift


struct LoginView: View {
    
    @ObservedObject var realmManager: RealmManager
    
    @State private var login_failed: Bool = false
    
    
    @State private var user_name: String = ""
    @State private var user_password: String = ""
    
    let layoutProperties: UserLoginViewLayoutProperties = UserLoginViewgetPreviewLayoutProperties()
    
    
    // focus field for move to next field on keyboard press return
    enum Field {
        case user_name
        case password
    }
    
    @FocusState private var focusedField: Field?
    
        
    var body: some View {
        
        
        NavigationStack {
            
          
                
                //            GeometryReader { _ in // removing this just fixes landscape scrolling too
                
                //            ScrollView {
                
                // Putting NavigationStack under ViewThatFits causes no resizing
                //        NavigationStack {
                // One drawback to this is I can think of, everything will be in same size, so if any size adjustments has to done manually, for Example if I want title to be bigger, I have to aggregate by titleFont + 10
                
                //                if layoutProperties.height > layoutProperties.width {
                
                //                    ViewThatFits(in: .vertical) {
                
                
                mainContent(
                    
                    smallFont: layoutProperties.customFontSize.tiny,
                    titleFont: layoutProperties.customFontSize.large,
                    fieldTitleFont: layoutProperties.customFontSize.large,
                    fieldFont: layoutProperties.customFontSize.large,
                    fieldHeight: layoutProperties.dimensValues.large,
                    buttonHeight: layoutProperties.dimensValues.large,
                    buttonFont: layoutProperties.customFontSize.large
                    
                )
                
                //                        mainContent(
                //
                //                            smallFont: layoutProperties.customFontSize.tiny,
                //                            titleFont: layoutProperties.customFontSize.mediumLarge,
                //                            fieldTitleFont: layoutProperties.customFontSize.mediumLarge,
                //                            fieldFont: layoutProperties.customFontSize.mediumLarge,
                //                            fieldHeight: layoutProperties.dimensValues.mediumLarge,
                //                            buttonHeight: layoutProperties.dimensValues.mediumLarge,
                //                            buttonFont: layoutProperties.customFontSize.mediumLarge
                //
                //                        )
                //
                //                        mainContent(
                //
                //                            smallFont: layoutProperties.customFontSize.tiny,
                //                            titleFont: layoutProperties.customFontSize.medium,
                //                            fieldTitleFont: layoutProperties.customFontSize.medium,
                //                            fieldFont: layoutProperties.customFontSize.medium,
                //                            fieldHeight: layoutProperties.dimensValues.medium,
                //                            buttonHeight: layoutProperties.dimensValues.medium,
                //                            buttonFont: layoutProperties.customFontSize.medium
                //
                //                        )
                //
                //                        mainContent(
                //
                //                            smallFont: layoutProperties.customFontSize.tiny,
                //                            titleFont: layoutProperties.customFontSize.smallMedium,
                //                            fieldTitleFont: layoutProperties.customFontSize.smallMedium,
                //                            fieldFont: layoutProperties.customFontSize.smallMedium,
                //                            fieldHeight: layoutProperties.dimensValues.smallMedium,
                //                            buttonHeight: layoutProperties.dimensValues.smallMedium,
                //                            buttonFont: layoutProperties.customFontSize.smallMedium
                //
                //                        )
                //
                //                        mainContent(
                //
                //                            smallFont: layoutProperties.customFontSize.tiny,
                //                            titleFont: layoutProperties.customFontSize.small,
                //                            fieldTitleFont: layoutProperties.customFontSize.small,
                //                            fieldFont: layoutProperties.customFontSize.small,
                //                            fieldHeight: layoutProperties.dimensValues.small,
                //                            buttonHeight: layoutProperties.dimensValues.small,
                //                            buttonFont: layoutProperties.customFontSize.small
                //
                //                        )
                
                //                    }
                //                }
                
                //                else {
                //
                //                    ScrollView {
                //
                //                        mainContent(
                //
                //                            smallFont: layoutProperties.customFontSize.tiny,
                //                            titleFont: layoutProperties.customFontSize.large,
                //                            fieldTitleFont: layoutProperties.customFontSize.large,
                //                            fieldFont: layoutProperties.customFontSize.large,
                //                            fieldHeight: layoutProperties.dimensValues.large,
                //                            buttonHeight: layoutProperties.dimensValues.large,
                //                            buttonFont: layoutProperties.customFontSize.large
                //
                //                        )
                //
                //                    }
                //
                //                }
                
                //
                
                
                //        .ignoresSafeArea(.keyboard, edges: .all)
                
            }
            .navigationViewStyle(.stack)
//            .frame(maxHeight: .infinity)
//            .background(.red)
            
 
        
        
}

    @ViewBuilder
    private func mainContent(
        
        smallFont: CGFloat,
        titleFont: CGFloat,
        fieldTitleFont: CGFloat,
        fieldFont: CGFloat,
        fieldHeight: CGFloat,
        buttonHeight: CGFloat,
        buttonFont: CGFloat
        
    ) -> some View {
          
           
        VStack(spacing: 20) {
            
            ScrollView {  
            
            title(titleFont: titleFont)
            
            Divider()
                .hidden()
            
            loginTitle(titleFont: titleFont)
            
            Divider()
                .hidden()
            
            inputFields(fieldTitleFont: fieldTitleFont, fieldFont: fieldFont, smallFont: smallFont, fieldHeight: fieldHeight)
            
            // some space
            Divider()
                .hidden()
            
            loginButton(buttonHeight: buttonHeight, buttonFont: buttonFont)
            
            // some space
            Divider()
                .hidden()
            
            socialLoginSection(smallFont: smallFont, buttonHeight: buttonHeight)
            

        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        .safeAreaInset(edge: .bottom) { // this should be under scroll view to set this at bottom
            signUpLink(smallFont: smallFont)
            }
        
        }
        .padding(.horizontal)
        
        
    }

    private func title(titleFont: CGFloat) -> some View {
        Text("Expernse")
            .font(.custom("ArialRoundedMTBold", size: titleFont * 0.9))
            .foregroundColor(Color(hex: 0x007AFF))
    }
    
    private func loginTitle(titleFont: CGFloat) -> some View {
        Text("Login")
            .font(.custom("ArialRoundedMTBold", size: titleFont * 0.9))
    }
    
    private func inputFields(fieldTitleFont: CGFloat, fieldFont: CGFloat, smallFont: CGFloat, fieldHeight: CGFloat) -> some View {
        
        VStack(spacing: 15) {
            
            emailField(fieldTitleFont: fieldTitleFont, fieldFont: fieldFont, fieldHeight: fieldHeight)
            
            passwordField(fieldTitleFont: fieldTitleFont, fieldFont: fieldFont, fieldHeight: fieldHeight)
            
            .toolbar {
                
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil
                    }
                }
                
            }
            
            HStack {
                Spacer()
                forgotPasswordButton(smallFont: smallFont)
            }
        }
        .onSubmit {
            switch focusedField {
            case .user_name:
                focusedField = .password
            
            default:
                break
            }
            
        }
    }
    
    private func emailField(fieldTitleFont: CGFloat, fieldFont: CGFloat, fieldHeight: CGFloat) -> some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            Text("Username")
                .font(.custom("GillSans", size: fieldTitleFont - fieldFont * 0.5))
            
            TextField("Enter your username", text: $user_name)
                .padding(.horizontal)
                .frame(height: fieldHeight)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: 0xF1F5F9)))
                .font(.system(size: fieldFont - fieldFont * 0.5))
                .foregroundColor(.black)
                
                .focused($focusedField, equals: .user_name)
                .textContentType(.givenName)
                .submitLabel(.next)
                .disableAutocorrection(true)
                  
        }
    }
    
    
    private func passwordField(fieldTitleFont: CGFloat, fieldFont: CGFloat, fieldHeight: CGFloat) -> some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            Text("Password")
                .font(.custom("GillsSans", size: fieldTitleFont - fieldTitleFont * 0.5))
            
            SecureField("Enter your password", text: $user_password)
                .padding(.horizontal)
                .frame(height: fieldHeight)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: 0xF1F5F9)))
                .font(.system(size: fieldFont - fieldFont * 0.5))
                .foregroundColor(.black)
            
                .focused($focusedField, equals: .password)
                .textContentType(.password)
                .submitLabel(.return)
                
        }
    }
    

    private func forgotPasswordButton(smallFont: CGFloat) -> some View
    
        {
        
        Button("Forgot Password?") {
            
        }
        .font(.system(size: smallFont))
        .frame(maxWidth: .infinity, alignment: .trailing)
        
    }
    
    private func loginButton(buttonHeight: CGFloat, buttonFont: CGFloat) -> some View {
        
        Button(action: { login_failed = realmManager.login_user(user_name: user_name, user_password: user_password) } ) {
                Text("Login")
                    .font(.custom("GillSans", size: buttonFont - buttonFont * 0.25))
                    .frame(maxWidth: .infinity)
                    .frame(height: buttonHeight)
                    .background(Color.blue.gradient)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }
            .alert("Invalid Credentials", isPresented: $login_failed ) {
                Button("OK", role: .cancel) { }
            }
    }
    
    private func socialLoginSection(smallFont: CGFloat, buttonHeight: CGFloat) -> some View {
        VStack {
            
            Text("Or login with")
                .font(.system(size: smallFont))
                .foregroundColor(.gray)
            
            VStack {
                
                Button(action: {}) {
                    Image("ios_light_rd_ctn")
                }
                
                Button(action: {}) {
                    Image("output-onlinepngtools (1)")
                        .resizable()
                        .frame(width: 199, height: 40)
                    // size of google svg
                    
                }
            }
        }
    }
  
    private func signUpLink(smallFont: CGFloat) -> some View {
        
        NavigationLink(destination: RegisterView(realmManager: realmManager)) {
            
            HStack(spacing: 4) {
                
                Text("Didn't have an account?")
                    .font(.system(size: smallFont))
                
                    Text("Sign Up")
                        .font(.system(size: smallFont, weight: .semibold))
                        .underline()
                
                }
                
            }
            .foregroundColor(Color(hex: 0x007AFF))
        
//        }
    
    }

}




#Preview {
    
        LoginView(realmManager: RealmManager())
//            .background(.red)

    
//    UserLoginView(sign_in_success: $is_false)
    
//    UserRegisterView()
    
}
