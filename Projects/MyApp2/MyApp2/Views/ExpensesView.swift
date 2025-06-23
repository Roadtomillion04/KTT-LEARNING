//
//  AppView.swift
//  MyApp2
//
//  Created by Nirmal kumar on 16/06/25.
//

import SwiftUI
import RealmSwift

struct ExpensesView: View {
//    @EnvironmentObject var appState: AppState
    
//    @Binding var is_logged_in: Bool
    
    
    @ObservedResults(ExpensesInfo.self) var expensesInfos
    
    var body: some View {
        
        NavigationStack {
            
            
            VStack(spacing: 10) {
                
                
                Text("Good Morning")
                    .font(Font.custom("optima", size: 30))
                    .padding(.top, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .offset(y: 15)
                    .foregroundStyle(Color.white)
                    .padding(.bottom, 10)
                
                
                
                VStack(spacing: 30) {
                    
                    VStack(alignment: .leading) {
                        Text("Total Balance")
                            .font(Font.custom("GillSans", size: 25))
                        
                            .padding(.bottom, 5)
                        
                        Text("₹1000")
                            .font(Font.custom("ArialRoundedMTBold", size: 40))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
                    .padding(.bottom, -20)
                    
                    
                    
                    ZStack {
                        
                        
                        VStack(alignment: .leading) {
                            Label{
                                Text("Income")
                            } icon: {
                                Image(systemName: "arrowshape.down.fill")
                            }
                            .font(Font.custom("GillSans", size: 25))
                            .padding(.bottom, 5)
                            
                            Text("₹2000")
                                .font(Font.custom("ArialRoundedMTBold", size: 25))
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        
                        VStack(alignment: .leading) {
                            Label{
                                Text("Expenses")
                            } icon: {
                                Image(systemName: "arrowshape.up.fill")
                            }
                            .font(Font.custom("GillSans", size: 25))
                            .padding(.bottom, 5)
                            
                            Text("₹1000")
                                .font(Font.custom("ArialRoundedMTBold", size: 25))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        
                    }
                    .foregroundStyle(Color.white)
                    .padding()
                    .padding(.horizontal, 10)
                    
                    
                    
                    
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 20)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                ).foregroundStyle(Color.indigo)
                    .padding(.horizontal)
                    .shadow(radius: 10)
                
                    .offset(y: 20)
                
                
                
            }
            .background(Color.blue)
            .offset(y: -30)
            
            
            VStack {
                
                List {
                    //
                    ForEach(expensesInfos) {expense in
                        
                        ZStack {
                            
                            HStack {
                                
                                Image(systemName: "fork.knife.circle")
                                    .resizable()
                                    .frame(width: 64, height: 64)
                                    .padding(.trailing)
                                
                                
                                VStack {
                                    
                                    Group {
                                        
                                        ZStack {
                                            
                                            HStack {
                                                Text("\(expense.category)")
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .font(Font.custom("optima", size: 30)).bold()
                                                
                                                Text("₹\(expense.amount)")
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                            }
                                            
                                        }
                                        
                                    }
                                    .font(Font.custom("optima", size: 25)).bold()
                                    
                                    
                                    Group {
                                        
                                        ZStack {
                                            
                                            HStack {
                                                
                                                Text("\(expense.name)")
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                
                                                Text("\(expense.date.formatted(date: .abbreviated, time: .standard))")
                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                
                                                
                                            }
                                            
                                        }
                                        
                                    }
                                    .font(Font.custom("optima", size: 25))
                                    
                                    
                                }
                                
                            }
                        }
                    }
                    
        
                }
                .padding(.vertical)
                .listRowSpacing(15)
                .padding(.bottom, -20)
                .padding(.top, -30)
                
                
                
            }
            .shadow(radius: 1)
            
            ZStack {
                
                HStack(spacing: 50) {
                    
                    NavigationLink(destination: ExpenseCreateView(),
                                   label: {
                        ZStack {
                            Circle()
                                .frame(width: 75)
                                .foregroundStyle(.blue)
                            
                            Text("+")
                                .font(Font.custom("GillSans", size: 50))
                                .foregroundStyle(.white)
                            
                        }
                    })
                    .padding(.bottom, -20)
                    .shadow(radius: 2)
                    
                    
//                    ZStack {
//                        Circle()
//                            .frame(width: 75)
//                            .foregroundStyle(.blue)
//                        
//                        Image(systemName: "")
//                            .font(Font.custom("GillSans", size: 50))
//                            .foregroundStyle(.white)
//                        
//                    }
//                    .padding(.bottom, -20)
//                    .shadow(radius: 2)
                    
                }
                
            }
        }
        
        
    }
}


struct ExpenseCreateView: View {
    
    @ObservedResults(ExpensesInfo.self) var expensesInfos
    
    @State var name: String = ""
    @State var amount: String = ""
    @State var category: String = ""
    @State var date: Date = Date()
    
    
    @State var expense_create_success: Bool = false
    
    var body: some View {
        
        VStack(spacing: 35) {
            
            Text("Add Expense")
                .font(Font.custom("GillSans", size: 40))
                
  
            
            VStack(spacing: 15) {
                Text("Name")
                    .font(Font.custom("", size: 30))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                
                TextField("Meal", text: $name)
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
                Text("Amount")
                    .font(Font.custom("", size: 30))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                
                TextField("₹100", text: $amount)
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
                Text("Categories")
                    .font(Font.custom("", size: 30))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                
                TextField("Breakfast", text: $category)
                    .frame(width: .infinity, height: 70)
                    .font(Font.custom("optima", size: 30))
                    .foregroundStyle(Color.black)

                    
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 10)
                    ).foregroundStyle(Color(hex:0xF1F5F9))
                    .padding(.horizontal, 20)
                    
                
            }
            
            HStack(spacing: 15) {
                Text("Date")
                    .font(Font.custom("", size: 30))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
             
                DatePicker("", selection: $date)
                    .datePickerStyle(.compact)
                    .padding(.horizontal, 20)
                    
                    
            }
            
            
        }
        .padding(.bottom, 150)
            
            
        Button(action: { createExpense() }) {
                Text("Save")
                    .frame(maxWidth: .infinity, maxHeight: 75)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                
                    .font(Font.custom("GillSans", size: 30))
                    .padding(.horizontal, 20)
                    
                
                                
            }
            .alert(isPresented: $expense_create_success) {
                Alert(title: Text("Expense Created Successfully"), message: Text("New Expense Added"), dismissButton: .default(Text("OK")))
                }
            
            
    }
    
    
    func createExpense() {
        let newExpense = ExpensesInfo(name: name, amount: Int(amount) ?? 0, category: category, date: date)
        
        $expensesInfos.append(newExpense)
        
        ExpensesView(expensesInfos: $expensesInfos)
        
        
        expense_create_success = true
        name = ""
        amount = ""
        category = ""
        date = Date()
        
    }
    
}



#Preview {
    ExpensesView()
}
