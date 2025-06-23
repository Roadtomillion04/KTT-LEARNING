//
//  LoginView.swift
//  Expense Mangement
//
//  Created by Nirmal kumar on 12/06/25.
//

import SwiftUI
import RealmSwift



struct UserLoginView: View {
    
    @ObservedResults(UserRegisterInfo.self) var userInfos
    @State private var wrongUser: Bool = false
    @Binding var sign_in_success: Bool
    @State private var user_name: String = ""
    @State private var user_password: String = ""
    @State private var device_model: String = UIDevice().type.rawValue
    
    let layoutProperties: UserLoginViewLayoutProperties = UserLoginViewgetPreviewLayoutProperties()
    
    
    var body: some View {
        
        // Putting NavigationStack under ViewThatFits causes no resizing
        NavigationStack {
            // One drawback to this is I can think of, everything will be in same size, so if any size adjustments has to done manually, for Example if I want title to be bigger, I have to aggregate by titleFont + 10
            ViewThatFits(in: .vertical) {
                
                mainContent(
                    
                    smallFont: layoutProperties.customFontSize.tiny,
                    titleFont: layoutProperties.customFontSize.extraLarge,
                    fieldTitleFont: layoutProperties.customFontSize.extraLarge,
                    fieldFont: layoutProperties.customFontSize.extraLarge,
                    fieldHeight: layoutProperties.dimensValues.extraLarge,
                    buttonHeight: layoutProperties.dimensValues.extraLarge,
                    buttonFont: layoutProperties.customFontSize.extraLarge
                    
                )
                
                
                mainContent(
                    
                    smallFont: layoutProperties.customFontSize.tiny,
                    titleFont: layoutProperties.customFontSize.large,
                    fieldTitleFont: layoutProperties.customFontSize.large,
                    fieldFont: layoutProperties.customFontSize.large,
                    fieldHeight: layoutProperties.dimensValues.large,
                    buttonHeight: layoutProperties.dimensValues.large,
                    buttonFont: layoutProperties.customFontSize.large
                    
                )
                
                
                mainContent(
                    
                    smallFont: layoutProperties.customFontSize.tiny,
                    titleFont: layoutProperties.customFontSize.mediumLarge,
                    fieldTitleFont: layoutProperties.customFontSize.mediumLarge,
                    fieldFont: layoutProperties.customFontSize.mediumLarge,
                    fieldHeight: layoutProperties.dimensValues.mediumLarge,
                    buttonHeight: layoutProperties.dimensValues.mediumLarge,
                    buttonFont: layoutProperties.customFontSize.mediumLarge
                    
                )
                
                
                mainContent(
                    
                    smallFont: layoutProperties.customFontSize.tiny,
                    titleFont: layoutProperties.customFontSize.medium,
                    fieldTitleFont: layoutProperties.customFontSize.medium,
                    fieldFont: layoutProperties.customFontSize.medium,
                    fieldHeight: layoutProperties.dimensValues.medium,
                    buttonHeight: layoutProperties.dimensValues.medium,
                    buttonFont: layoutProperties.customFontSize.medium
                    
                )
                
                mainContent(
                    
                    smallFont: layoutProperties.customFontSize.tiny,
                    titleFont: layoutProperties.customFontSize.smallMedium,
                    fieldTitleFont: layoutProperties.customFontSize.smallMedium,
                    fieldFont: layoutProperties.customFontSize.smallMedium,
                    fieldHeight: layoutProperties.dimensValues.smallMedium,
                    buttonHeight: layoutProperties.dimensValues.smallMedium,
                    buttonFont: layoutProperties.customFontSize.smallMedium
                    
                )
                
                mainContent(
                    
                    smallFont: layoutProperties.customFontSize.tiny,
                    titleFont: layoutProperties.customFontSize.small,
                    fieldTitleFont: layoutProperties.customFontSize.small,
                    fieldFont: layoutProperties.customFontSize.small,
                    fieldHeight: layoutProperties.dimensValues.small,
                    buttonHeight: layoutProperties.dimensValues.small,
                    buttonFont: layoutProperties.customFontSize.small
                    
                )
                
            }
        }
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
                  
                  title(titleFont: titleFont)
                  
                  
                  loginTitle(titleFont: titleFont)
                  
                  inputFields(fieldTitleFont: fieldTitleFont, fieldFont: fieldFont, smallFont: smallFont, fieldHeight: fieldHeight)
                  
                  // some space
                  Divider()
                      .hidden()
                  
                  loginButton(buttonHeight: buttonHeight, buttonFont: buttonFont)
                  
                  // some space
                  Divider()
                      .hidden()
                  
                  socialLoginSection(smallFont: smallFont, buttonHeight: buttonHeight)
                  
                  signUpLink(smallFont: smallFont)
                  
              }
              .padding(.horizontal)
          }
      
      
      private func title(titleFont: CGFloat) -> some View {
          Text("Expenset")
              .font(.custom("ArialRoundedMTBold", size: titleFont))
              .foregroundColor(Color(hex: 0x007AFF))
      }
      
      private func loginTitle(titleFont: CGFloat) -> some View {
          Text("Login")
              .font(.custom("GillSans", size: titleFont))
      }
      
    private func inputFields(fieldTitleFont: CGFloat, fieldFont: CGFloat, smallFont: CGFloat, fieldHeight: CGFloat) -> some View {
          VStack(spacing: 10) {
              
              emailField(fieldTitleFont: fieldTitleFont, fieldFont: fieldFont, fieldHeight: fieldHeight)
              
              passwordField(fieldTitleFont: fieldTitleFont, fieldFont: fieldFont, fieldHeight: fieldHeight)
              
              HStack {
                  Spacer()
                  forgotPasswordButton(smallFont: smallFont)
              }
              
          }
      }
      
    private func emailField(fieldTitleFont: CGFloat, fieldFont: CGFloat, fieldHeight: CGFloat) -> some View {
        
          VStack(alignment: .leading, spacing: 5) {
              
              Text("Email")
                  .font(.custom("optima", size: fieldTitleFont))
              
              TextField("Enter your email", text: $user_name)
                  .textFieldStyle(.plain)
                  .padding(.horizontal)
                  .frame(height: fieldHeight)
                  .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: 0xF1F5F9)))
                  .font(.system(size: fieldFont - fieldFont * 0.5))
          }
      }
      

    private func passwordField(fieldTitleFont: CGFloat, fieldFont: CGFloat, fieldHeight: CGFloat) -> some View {
        
          VStack(alignment: .leading, spacing: 5) {
              
              Text("Password")
                  .font(.custom("optima", size: fieldTitleFont))
              
              SecureField("Enter your password", text: $user_password)
                  .textFieldStyle(.plain)
                  .padding(.horizontal)
                  .frame(height: fieldHeight)
                  .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: 0xF1F5F9)))
                  .font(.system(size: fieldFont - fieldFont * 0.5))
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
          Button(action: {
              if userInfos.filter({ $0.user_name == user_name && $0.user_password == user_password }).count > 0 {
                  sign_in_success = true
              } else {
                  wrongUser  = true
              } }) {
              Text("Login")
                      .font(.custom("GillSans", size: buttonFont))
                  .frame(maxWidth: .infinity)
                  .frame(height: buttonHeight)
                  .background(Color.blue)
                  .foregroundColor(.white)
                  .cornerRadius(5)
          }
          .alert("Invalid Credentials", isPresented: $wrongUser ) {
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
                          .resizable()
                          .frame(height: buttonHeight)
                  }
                  
                  Button(action: {}) {
                      Image("output-onlinepngtools (1)")
                          .resizable()
                          .frame(height: buttonHeight)
                  }
              }
          }
      }
      
    private func signUpLink(smallFont: CGFloat) -> some View {
        NavigationLink(destination: UserRegisterView()) {
            HStack(spacing: 4) {
                
                Text("Didn't have an account?")
                    .font(.system(size: smallFont))
                
                Text("Sign Up")
                    .font(.system(size: smallFont, weight: .semibold))
                    .underline()
                
            }
            .foregroundColor(Color(hex: 0x007AFF))
        
        }
    
    }

}



struct UserRegisterView: View {
    
    @ObservedResults(UserRegisterInfo.self) var userInfos
    @State private var user_name: String = ""
    @State private var user_email: String = ""
    @State private var user_password: String = ""
    @State private var bank_name: String = ""
    @State private var account_number: String = ""
    @State private var register_success: Bool = false
    
    let layoutProperties: UserRegisterViewLayoutProperties = UserRegisterViewgetPreviewLayoutProperties()
    
    @State private var orientation: String = ""
    
    
    var body: some View {
        
        // rescaling only in potrait mode
        
        if layoutProperties.height > layoutProperties.width {
            
            
            ViewThatFits(in: .vertical) {
                
                mainContent(
                    
                    titleFont: layoutProperties.customFontSize.extraLarge,
                    fieldTitleFont: layoutProperties.customFontSize.extraLarge,
                    fieldFont: layoutProperties.customFontSize.extraLarge,
                    fieldHeight: layoutProperties.dimensValues.extraLarge,
                    buttonHeight: layoutProperties.dimensValues.extraLarge,
                    buttonFont: layoutProperties.customFontSize.extraLarge
                    
                )
                
                
                mainContent(
                    
                    titleFont: layoutProperties.customFontSize.large,
                    fieldTitleFont: layoutProperties.customFontSize.large,
                    fieldFont: layoutProperties.customFontSize.large,
                    fieldHeight: layoutProperties.dimensValues.large,
                    buttonHeight: layoutProperties.dimensValues.large,
                    buttonFont: layoutProperties.customFontSize.large
                    
                )
                
                
                mainContent(
                    
                    titleFont: layoutProperties.customFontSize.mediumLarge,
                    fieldTitleFont: layoutProperties.customFontSize.mediumLarge,
                    fieldFont: layoutProperties.customFontSize.mediumLarge,
                    fieldHeight: layoutProperties.dimensValues.mediumLarge,
                    buttonHeight: layoutProperties.dimensValues.mediumLarge,
                    buttonFont: layoutProperties.customFontSize.mediumLarge
                    
                )
                
                
                mainContent(
                    
                    titleFont: layoutProperties.customFontSize.medium,
                    fieldTitleFont: layoutProperties.customFontSize.medium,
                    fieldFont: layoutProperties.customFontSize.medium,
                    fieldHeight: layoutProperties.dimensValues.medium,
                    buttonHeight: layoutProperties.dimensValues.medium,
                    buttonFont: layoutProperties.customFontSize.medium
                    
                )
                
                mainContent(
                    
                    titleFont: layoutProperties.customFontSize.smallMedium,
                    fieldTitleFont: layoutProperties.customFontSize.smallMedium,
                    fieldFont: layoutProperties.customFontSize.smallMedium,
                    fieldHeight: layoutProperties.dimensValues.smallMedium,
                    buttonHeight: layoutProperties.dimensValues.smallMedium,
                    buttonFont: layoutProperties.customFontSize.smallMedium
                    
                )
                
                mainContent(
                    
                    titleFont: layoutProperties.customFontSize.small,
                    fieldTitleFont: layoutProperties.customFontSize.small,
                    fieldFont: layoutProperties.customFontSize.small,
                    fieldHeight: layoutProperties.dimensValues.small,
                    buttonHeight: layoutProperties.dimensValues.small,
                    buttonFont: layoutProperties.customFontSize.small
                    
                )
                
            }
        } else { // landscape mode
            
            ScrollView {
                mainContent(
                    
                    titleFont: layoutProperties.customFontSize.extraLarge,
                    fieldTitleFont: layoutProperties.customFontSize.extraLarge,
                    fieldFont: layoutProperties.customFontSize.extraLarge,
                    fieldHeight: layoutProperties.dimensValues.extraLarge,
                    buttonHeight: layoutProperties.dimensValues.extraLarge,
                    buttonFont: layoutProperties.customFontSize.extraLarge
                    
                )
                
            }
        }
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
            if layoutProperties.height > layoutProperties.width {
                
                Text("Create Account")
                // as this is the best I can think of now, evey font will be in same size, so for title I have to manually aggregate here
            
            // it's affecting landscape so do it only for potrait mode
            
                .font(Font.custom("GillSans", size: titleFont + 10))
                .padding(.bottom)
            } else { // landscape
                Text("Create Account")
                    .font(Font.custom("GillSans", size: titleFont))
            }
                
                
            Group {
                inputField(title: "Name", text: $user_name, titleFont: fieldTitleFont, fieldFont: fieldFont, height: fieldHeight)
                inputField(title: "Email", text: $user_email, titleFont: fieldTitleFont, fieldFont: fieldFont, height: fieldHeight)
                secureField(title: "Password", text: $user_password, titleFont: fieldTitleFont, fieldFont: fieldFont, height: fieldHeight)
                inputField(title: "Bank", text: $bank_name, titleFont: fieldTitleFont, fieldFont: fieldFont, height: fieldHeight)
                inputField(title: "Account Number", text: $account_number, titleFont: fieldTitleFont, fieldFont: fieldFont, height: fieldHeight)
            }
            
            
            Spacer()
            
            

            Text("Register")
                .frame(maxWidth: .infinity)
                .frame(height: buttonHeight)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .font(Font.custom("GillSans", size: buttonFont))
                .alert(isPresented: $register_success) {
                    Alert(
                        title: Text("Register Complete"),
                        message: Text("Go back and Login"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .padding(.horizontal)
        
                
            
            
        }
            }
    
    private func inputField(title: String, text: Binding<String>, titleFont: CGFloat, fieldFont: CGFloat, height: CGFloat) -> some View {
        VStack(spacing: 5) {
            Text(title)
                .font(Font.custom("optima", size: titleFont))
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
    
    private func secureField(title: String, text: Binding<String>, titleFont: CGFloat, fieldFont: CGFloat, height: CGFloat) -> some View {
        VStack(spacing: 10) {
            Text(title)
                .font(Font.custom("optima", size: titleFont))
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
    
    private func createUser() {
        let newUser = UserRegisterInfo(
            user_name: user_name,
            user_password: user_password,
            user_email: user_email,
            bank_name: bank_name,
            account_numer: account_number
        )
        $userInfos.append(newUser)
        register_success = true
        user_name = ""
        user_password = ""
        user_email = ""
        bank_name = ""
        account_number = ""
    }
}



struct AdminLoginView: View {
    
    @State var admin_name: String = ""
    @State var admin_password: String = ""
    
    var body: some View {
        VStack {
            Text("Admin Login")
                .font(.largeTitle)
            
            HStack {
                Text("AdminName: ")
                TextField("AdminName: ", text: $admin_name)
                    
            }
            .padding()
            .font(.title)
            .frame(width: .infinity, height: 100, alignment: .center)
            
            
            HStack {
                Text("Password: ")
                TextField("Password", text: $admin_password)
        
            }
            .padding()
            .font(.title)
            .frame(width: .infinity, height: 100, alignment: .center)
            
            
            
            Spacer()
                
            Button(action: {  },
                   label: { Text("Login") })
            .frame(width: 200, height: 75)
            .background(Color.red)
            .foregroundStyle(.black)
            .cornerRadius(240)
        }
        
    }
    
}




struct LoginView: View {
    
//    @State var selectedTab: Int = 0
    
    @State var sign_in_success: Bool = false
    
    var body: some View {
        
        // $ is binding, binding is like sending reference
//        TabView(selection: $selectedTab) {
//            
//            
//            Tab("User", systemImage: "person.fill",value: 0) {
//                UserLoginView()
//            }
//            
//            
//            Tab("Admin", systemImage: "person.badge.shield.checkmark.fill", value: 1) {
//                AdminLoginView()
//            }
//            
//            
//        }
        
        return Group {
            if sign_in_success {
                ExpensesView()
            }
            
            else {
                
                UserLoginView(sign_in_success: self.$sign_in_success)
                
            }
        }
                
    }
    
}




#Preview {
    @Previewable @State var is_false: Bool = false
    
//    UserLoginView(sign_in_success: $is_false)
    
    UserRegisterView()
    
}
