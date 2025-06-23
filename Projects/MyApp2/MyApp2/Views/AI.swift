//
//  AI.swift
//  MyApp2
//
//  Created by Nirmal kumar on 23/06/25.
//

import SwiftUI
import RealmSwift

struct deprecated: View {
        @ObservedResults(UserRegisterInfo.self) var userInfos
        
        @State private var wrongUser: Bool = false
        
        @Binding var sign_in_success: Bool
        
    //    @EnvironmentObject var appState: AppState
        
            
        // This all has to be var, as TextField is Used
        // @State is observed by Views (acts as on_change in js, reload View with new changes)
        @State private var user_name: String = ""
        @State private var user_password: String = ""
        
        @State private var visibility: NavigationSplitViewVisibility = .automatic
        
        // device find
        @State private var device_model: String = UIDevice().type.rawValue
        
        
    let layoutProperties: UserRegisterViewLayoutProperties = UserRegisterViewgetPreviewLayoutProperties()
        
        var body: some View {
            
            ViewThatFits(in: .vertical) {
                
                // NavigationStack with NavigationLink destination init, for one view navigate
                NavigationStack {

                    
                    Text("\(device_model)")
                        .font(Font.custom("ArialRoundedMTBold", size: layoutProperties.customFontSize.extraLarge))
                        .foregroundStyle(Color(hex: 0x007AFF))
                    
                    
                    
                    VStack(spacing: 0) {
                        
                        
                        Text("Login")
                            .font(Font.custom("GillSans", size: 42.5))
                            .padding(.vertical)
                        
                        
                        Group {
                            
                            VStack(spacing: 15) {
                                Text("Email")
                                    .font(Font.custom("", size: 30))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                
                                
                                TextField("Enter your Name", text: $user_name)
                                    .frame(width: .infinity, height: 70)
                                    .font(Font.custom("optima", size: 30))
                                    .foregroundStyle(Color.black)
                                
                                
                                
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal)
                                
                                    .background(RoundedRectangle(cornerRadius: 10)
                                    ).foregroundStyle(Color(hex:0xF1F5F9))
                                    .padding(.horizontal, 20)
                                
                                
                            }
                            
                            
                            VStack(spacing: 15) {
                                Text("Password")
                                    .font(Font.custom("", size: 30))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                
                                
                                TextField("Password", text: $user_password)
                                    .frame(width: .infinity, height: 70)
                                    .font(Font.custom("optima", size: 30))
                                    .foregroundStyle(Color.black)
                                
                                
                                    .multilineTextAlignment(.leading)
                                    .padding(.horizontal)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                    ).foregroundStyle(Color(hex:0xF1F5F9))
                                    .padding(.horizontal, 20)
                                
                            }
                            
                        }
                        .padding(.vertical, 15)
                        
                        
                        
                        HStack {
                            Button( action: {  } ) {
                                Text("Forget Password")
                                    .font(Font.custom("GillSans", size: 22.5))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .padding(.horizontal)
                                    .padding(.bottom, 15)
                            }
                            
                        }
                        
                        
                        
                        Button(action: {
                            
                            if userInfos.filter({$0.user_name == user_name && $0.user_password == user_password}).count > 0 {
                                
                                sign_in_success = true
                                
                                
                            } else {
                                wrongUser = true
                            }
                            
                            
                            
                        },
                               label: { Text("Login")
                            
                                .frame(maxWidth: .infinity, maxHeight: 75)
                                .background(Color.blue)
                                .foregroundStyle(.white)
                                .cornerRadius(10)
                            
                                .font(Font.custom("", size: 30))
                                .padding(.horizontal, 20)
                            
                                .alert(isPresented: $wrongUser) {
                                    Alert(title: Text("Username or Password is Incorrect"), message: Text("Please try again"), dismissButton: .default(Text("OK")))
                                    
                                }
                        })
                        .padding(.vertical, 20)
                        
                        
                        
                        VStack(spacing: 20) {
                            Text("Or Login with")
                                .font(Font.custom("", size: 22))
                            
                                   
                                Button(action: {  }) {
                                    Label {
                                        Text("")
                                    } icon: {
                                        Image("ios_light_rd_ctn")
                                            .resizable()
                                            .frame(maxWidth: .infinity, maxHeight: 72)
                                            .padding(.horizontal, 20)
                                    }
                                }
                                
                            
                                
                                Button(action: {  }) {
                                    Label {
                                        Text("")
                                    } icon: {
                                        Image("output-onlinepngtools (1)")
                                            .resizable()
                                            .frame(maxWidth: .infinity, maxHeight: 70)
                                        
                                            .padding(.horizontal, 20)
                                        
                                    }
                                }
                                
                                
                                                    
                            
                            
                        }
                        
                        
                        Spacer()
                        
                        NavigationLink(destination: UserRegisterView(),
                                       label: {
                            
                            HStack(spacing: 0) {
                                
                                Text("Didn't have an account?")
                                
                                    .foregroundStyle(Color(hex:0xefeae))
                                    .font(Font.custom("", size: 25))
                                
                                Text(" Sign Up")
                                    .foregroundStyle(Color(hex: 0x007AFF))
                                    .underline()
                                
                                    .font(Font.custom("", size: 23))
                                
                                
                                
                                
                                
                            }
                            .frame(maxWidth: .infinity, alignment: .bottom)
                            
                            
                        })
                        
                        
                        //                    Divider()
                        
                        
                        
                    }
                    
                    
                }
                
                // Alternative size choosing for different screens
                //            -------------
                
                
                
                
                
            } // View that fits
                
                
        }
            
    }

//
//struct UserRegisterView: View {
//    @ObservedResults(UserRegisterInfo.self) var userInfos
//    
//    @State var user_name: String = ""
//    @State var user_email: String = ""
//    @State var user_password: String = ""
//    @State var bank_name: String = ""
//    @State var account_number: String = ""
//    
//    @State var register_success: Bool = false
//    
//    
//    
//    var body: some View {
//            
//            VStack(spacing: 20) {
//                Text("Create Account")
//                    .font(Font.custom("GillSans", size: 35))
//                    .padding(.top, -40)
//                    
//                
//                
//                Group {
//                    
//                    VStack(spacing: 15) {
//                        Text("Name")
//                            .font(Font.custom("", size: 30))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.horizontal)
//                        
//                        
//                        TextField("Enter your Name", text: $user_name)
//                            .frame(width: .infinity, height: 70)
//                            .font(Font.custom("optima", size: 30))
//                            .foregroundStyle(Color.black)
//
//                            
//                            .multilineTextAlignment(.leading)
//                            .padding(.horizontal)
//                            .background(RoundedRectangle(cornerRadius: 10)
//                            ).foregroundStyle(Color(hex:0xF1F5F9))
//                            .padding(.horizontal, 20)
//                            
//                        
//                    }
//                    
//                    VStack(spacing: 15) {
//                        Text("Email")
//                            .font(Font.custom("", size: 30))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.horizontal)
//                        
//                        
//                        TextField("Enter your Email", text: $user_email)
//                            .frame(width: .infinity, height: 70)
//                            .font(Font.custom("optima", size: 30))
//                            .foregroundStyle(Color.black)
//
//                            
//                            .multilineTextAlignment(.leading)
//                            .padding(.horizontal)
//                            .background(RoundedRectangle(cornerRadius: 10)
//                            ).foregroundStyle(Color(hex:0xF1F5F9))
//                            .padding(.horizontal, 20)
//                                                }
//                    
//                    
//                    VStack(spacing: 15) {
//                        Text("Password")
//                            .font(Font.custom("", size: 30))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.horizontal)
//                        
//                        
//                        TextField("Enter your Password", text: $user_password)
//                            .frame(width: .infinity, height: 70)
//                            .font(Font.custom("optima", size: 30))
//                            .foregroundStyle(Color.black)
//
//                            
//                            .multilineTextAlignment(.leading)
//                            .padding(.horizontal)
//                            .background(RoundedRectangle(cornerRadius: 10)
//                            ).foregroundStyle(Color(hex:0xF1F5F9))
//                            .padding(.horizontal, 20)
//                            
//                        
//                    }
//                    
//                    VStack(spacing: 15) {
//                        Text("Bank")
//                            .font(Font.custom("", size: 30))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.horizontal)
//                        
//                        
//                        TextField("Enter your Bank Name", text: $bank_name)
//                            .frame(width: .infinity, height: 70)
//                            .font(Font.custom("optima", size: 30))
//                            .foregroundStyle(Color.black)
//
//                            
//                            .multilineTextAlignment(.leading)
//                            .padding(.horizontal)
//                            .background(RoundedRectangle(cornerRadius: 10)
//                            ).foregroundStyle(Color(hex:0xF1F5F9))
//                            .padding(.horizontal, 20)
//                            
//                    }
//                    
//                    VStack(spacing: 15) {
//                        Text("Account Number")
//                            .font(Font.custom("", size: 30))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.horizontal)
//                        
//                        
//                        TextField("Enter your Account Number", text: $account_number)
//                            .frame(width: .infinity, height: 70)
//                            .font(Font.custom("optima", size: 30))
//                            .foregroundStyle(Color.black)
//
//                            
//                            .multilineTextAlignment(.leading)
//                            .padding(.horizontal)
//                            .background(RoundedRectangle(cornerRadius: 10)
//                            ).foregroundStyle(Color(hex:0xF1F5F9))
//                            .padding(.horizontal, 20)
//                            
//                    }
//                }
//               
//                
//                
//                
//                Button(action: { createUser() }) {
//                    Text("Register")
//                        .frame(maxWidth: .infinity, maxHeight: 75)
//                        .background(Color.blue)
//                        .foregroundStyle(.white)
//                        .cornerRadius(10)
//                    
//                        .font(Font.custom("GillSans", size: 30))
//                        .padding(.horizontal, 20)
//                        .offset(y: 10)
//                    
//                    
//                    
//                        .alert(isPresented: $register_success) {
//                            Alert(title: Text("Register Complete"), message: Text("Go back and Login"), dismissButton: .default(Text("OK"))) }
//                    
//                }
//                
//                
////                Divider()
//                Spacer()
//                
//                
//            }
//            
//    }
//    
//    
//    func createUser() {
//        let newUserInfo = UserRegisterInfo(user_name: user_name, user_password: user_password, user_email: user_email, bank_name: bank_name, account_numer: account_number)
//        
//        var newUserAccount = UserBank(bank_name: bank_name, account_number: account_number)
//        
//        $userInfos.append(newUserInfo)
//    
//        
//        
//        UserLoginView.init(userInfos: $userInfos, sign_in_success: $register_success)
//        
//        register_success = true
//        user_name = ""
//        user_password = ""
//        user_email = ""
//        bank_name = ""
//        account_number = ""
//    }
//    
//}

 
