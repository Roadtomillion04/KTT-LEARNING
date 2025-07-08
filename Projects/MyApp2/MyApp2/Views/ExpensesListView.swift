//
//  AppView.swift
//  MyApp2
//
//  Created by Nirmal kumar on 16/06/25.
//

import SwiftUI
import RealmSwift

import Foundation

struct ExpensesView: View {
    
    @ObservedObject var realmManager: RealmManager
    
    // Tab buttons to present in sheet
    @State private var show_add_view: Bool = false
    @State private var show_profile_view: Bool = false
    
    let layoutProperties: ExpenseViewLayoutProperties = ExpenseViewgetPreviewLayoutProperties()
    
    private let category_icon: [String: String] = [
        "Food" : "fork.knife.circle",
        "Transport": "car.circle",
        "Entertainment": "theatermasks.circle",
        "Bills": "receipt",
        "Groceries": "cart.circle",
        "Credit": "creditcard"
    ]
    
    @State private var selected_expense: Expense?
    
    @State private var show_section: Bool = true
    
    private let date_formatter = DateFormatter()
    
    private let time_formatter = DateFormatter()
    
    init(realmManager: RealmManager) {
        self.realmManager = realmManager
        
        date_formatter.dateFormat = "yyyy-MM-dd" // without specifying dateFormat, converting string to date does not work
        
        time_formatter.dateFormat = "h:mm a"
        time_formatter.amSymbol = "AM"
        time_formatter.pmSymbol = "PM"
    }

 
    var body: some View {
        
//        ViewThatFits(in: .vertical) {
            
        NavigationStack {
            
            mainContent(
                
                smallFont: layoutProperties.customFontSize.tiny,
                titleFont: layoutProperties.customFontSize.smallMedium,
                listTitleFont: layoutProperties.customFontSize.smallMedium,
                listFont: layoutProperties.customFontSize.smallMedium,
                listHeight: layoutProperties.dimensValues.smallMedium,
                iconHeight: layoutProperties.dimensValues.smallMedium,
                iconWidth: layoutProperties.dimensValues.smallMedium
                
            )
            
            //            mainContent(
            //
            //                smallFont: layoutProperties.customFontSize.tiny,
            //                titleFont: layoutProperties.customFontSize.small,
            //                listTitleFont: layoutProperties.customFontSize.small,
            //                listFont: layoutProperties.customFontSize.small,
            //                listHeight: layoutProperties.dimensValues.small,
            //                iconHeight: layoutProperties.dimensValues.small,
            //                iconWidth: layoutProperties.dimensValues.small
            //
            //            )
            
            //        }
            
        }
    
    }
    
    
    @ViewBuilder
    private func mainContent(
        
        smallFont: CGFloat,
        titleFont: CGFloat,
        listTitleFont: CGFloat,
        listFont: CGFloat,
        listHeight: CGFloat,
        iconHeight: CGFloat,
        iconWidth: CGFloat
        
    ) -> some View {
        
        VStack(spacing: 10) {
            
            ZStack { // for illusion
                
                VStack {
                    title(titleFont: titleFont)
                        .zIndex(1)
                    
                    card(titleFont: titleFont, smallFont: smallFont, listFont: listFont, listTitleFont: listTitleFont, iconHeight: iconHeight, iconWidth: iconWidth)
                }
            }
            
            expensesList(smallFont: smallFont, titleFont: titleFont, listFont: listFont, listTitleFont: listTitleFont, listHeight: listHeight, iconWidth: iconWidth, iconHeight: iconHeight)
            
            Spacer()
            
            
            tabBar(iconWidth: iconWidth, iconHeight: iconHeight)
            
        }
        
    }
    
    private func title(titleFont: CGFloat) -> some View {
        
        HStack {
         
            Text("Good Morning, \(realmManager.get_name())")
                .font(Font.custom("", size: titleFont * 0.9))
                .frame(maxWidth: .infinity)
                .foregroundStyle(Color.white)
            
                .background(.blue)
            
        }

    }
    
    private func card(titleFont: CGFloat, smallFont: CGFloat, listFont: CGFloat, listTitleFont: CGFloat, iconHeight: CGFloat, iconWidth: CGFloat) -> some View {
                
        ZStack {
            
            RoundedRectangle(cornerRadius: 10)
                .frame(maxWidth: .infinity)
                .frame(height: layoutProperties.height - layoutProperties.height * 0.75)
                .offset(y: layoutProperties.height * -0.075)
                .ignoresSafeArea()
                .foregroundStyle(.blue)
                .zIndex(-1)
            
            
            VStack(spacing: layoutProperties.height - layoutProperties.height * 0.95) {
                
                HStack {
                    
                    VStack(alignment: .leading) {
                        
                        Text("Total Balance")
                            .font(Font.custom("GillSans", size: listTitleFont))
                        
                        Text("₹\(realmManager.get_bank_balance())")
                            .font(Font.custom("ArialRoundedMTBold", size: titleFont * 1.25))
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 10)
                    
                    Button(action: { show_profile_view.toggle() }) {
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: iconWidth * 2, height: iconHeight * 2)
                            .foregroundStyle(Color.white)
                            
                        
                    }
                    .padding(.horizontal)
                    
                    
                    .alert(isPresented: $show_profile_view) {
                        
                        Alert(
                          
                            title: Text("User Profile"),
                            message:
                                Text("Name: \(realmManager.get_name()) \n Email: \(realmManager.get_email()) \n Password: \(realmManager.get_password()) \n Bank Name: \(realmManager.get_bank_name()) \n Account Number: \(realmManager.get_account_number())"),
                            dismissButton: .cancel(Text("Close"))
                        )
                        
                    }
                    
                    
                }
                
                incomeExpenseSection(listFont: listFont)
                
            }
            .padding(.horizontal, 25)
            .padding(.bottom)
            .padding(.top)
            .background(RoundedRectangle(cornerRadius: 30).foregroundStyle(Color.indigo.gradient))
            .padding(.horizontal)
            .shadow(radius: 10)
        }
        
    }
    
    private func incomeExpenseSection(listFont: CGFloat) -> some View {
        
        ZStack {
            
            HStack {
                
                incomeView(listFont: listFont)
                expensesView(listFont: listFont)
                
            }
            .foregroundStyle(Color.white)
            .padding(.horizontal, 10)
        }
    }
    
    private func incomeView(listFont: CGFloat) -> some View {
        
        VStack(alignment: .leading, spacing: 5) {
            
            Label {
                Text("Income")
            } icon: {
                Image(systemName: "arrowshape.down.fill")
            }
            .font(Font.custom("GillSans", size: listFont - listFont * 0.25))
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("₹\(realmManager.get_income_amount())")
                .font(Font.custom("ArialRoundedMTBold", size: listFont - listFont * 0.25))
        }
    }
    
    private func expensesView(listFont: CGFloat) -> some View {
        
        VStack(alignment: .trailing, spacing: 5) {
            
            Label {
                Text("Expenses")
            } icon: {
                Image(systemName: "arrowshape.up.fill")
            }
            .font(Font.custom("GillSans", size: listFont - listFont * 0.25))
            .frame(maxWidth: .infinity, alignment: .trailing)
            
            Text("₹\(realmManager.get_spent_amount())")
                .font(Font.custom("ArialRoundedMTBold", size: listFont - listFont * 0.25))
            
        }
    }
    
    private func expensesList(smallFont: CGFloat, titleFont: CGFloat, listFont: CGFloat, listTitleFont: CGFloat, listHeight: CGFloat, iconWidth: CGFloat, iconHeight: CGFloat) -> some View {
        
        NavigationStack {
            
            List {
                
                // ForEach expects id to be unique, here we give self itself saying we have all unique values
                
                // sorted(by: >) is desc, and < is asc in array
                ForEach(Array(realmManager.expense_dict.keys).sorted(by: >), id: \.self) { dates in
                    
                    Section {
                        
                        ForEach(realmManager.expense_dict[dates] ?? [], id: \._id) { expense in
                            
                            expenseRow(expense: expense, smallFont: smallFont, titleFont: titleFont, listFont: listFont, listTitleFont: listTitleFont, listHeight: listHeight, iconWidth: iconWidth, iconHeight: iconHeight)
                            
                                .swipeActions(edge: .trailing) {
                                    
                                    Button(role: .destructive) {
                                        realmManager.delete_expense(id: expense._id)
                                        
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                              
                                    Button(action: { selected_expense = expense }) {
                                        Label("Update", systemImage: "text.document.fill")
                                    }
                                }
                        }
                    } header: {
                        
                        Text(date_formatter.date(from: dates) ?? Date(), format: .dateTime.day().month().year())
                            .font(Font.custom("ArialRoundedMTBold", size: listFont - listFont * 0.25))
                    }
                }
                
            }
            .listRowSpacing(15)
            .shadow(radius: 1)
            
            .sheet(item: $selected_expense) { expense in
                ExpenseEditView(realmManager: realmManager, name: expense.name, amount: expense.amount, notes: "", default_category_selection: expense.category, date: expense.date, _id: expense._id)
                        .presentationDetents([.fraction(0.66)])

            }
            
        }
        // sheet presented is not working, in that case create a identifier on swipe left gesture store the swiped expense and sheet item at end of List
        

    }
        
    private func expenseRow(expense: Expense, smallFont: CGFloat, titleFont: CGFloat, listFont: CGFloat, listTitleFont: CGFloat, listHeight: CGFloat, iconWidth: CGFloat, iconHeight: CGFloat) -> some View {
    
            ZStack {
    
                HStack {
                    Image(systemName: category_icon[expense.category]!)
                        .resizable()
                        .frame(width: iconWidth, height: iconHeight)
    
                    VStack {
                        expenseDetails(expense: expense, smallFont: smallFont, titleFont: titleFont, listFont: listFont, listTitleFont: listTitleFont, listHeight: listHeight, iconWidth: iconWidth, iconHeight: iconHeight)
                    }
                }
            }
        }
    
    private func expenseDetails(expense: Expense, smallFont: CGFloat, titleFont: CGFloat, listFont: CGFloat, listTitleFont: CGFloat, listHeight: CGFloat, iconWidth: CGFloat, iconHeight: CGFloat) -> some View {
    
            VStack {
    
                HStack(spacing: 0) {

                    Text("\(expense.category)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(Font.custom("ArialRoundedMTBold", size: listFont - listFont * 0.25))

                    Text(expense.category != "Credit" ? "- ₹\(expense.amount)" : "+ ₹\(expense.amount)")
                        .frame(width: .infinity, alignment: .trailing)
                        .font(Font.custom("ArialRoundedMTBold", size: listFont - listFont * 0.25))
                    
                }
                .padding(.bottom, 10)
    
                HStack {
                    
                    Text("\(expense.name)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text( time_formatter.string(from: expense.date) )
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .font(Font.custom("", size: smallFont))
            }
        }

    
    private func tabBar(iconWidth: CGFloat, iconHeight: CGFloat) -> some View {
        
        // not sure how, but for n buttons n + 1 H spacing works as I intended
        HStack(spacing: layoutProperties.width / 4) {
            
            NavigationLink(destination: ExpenseChartView(realmManager: realmManager)) {
            
                Image(systemName: "chart.bar.horizontal.page")
                        .resizable()
                        .frame(width: iconWidth, height: iconHeight)
                        .foregroundStyle(Color.green)
            }
            .shadow(radius: 1)
         
            
            ZStack {
                
                Circle()
                    .frame(width: iconWidth * 1.25)
                    .foregroundStyle(.blue.gradient)
                
                Text("+")
                    .font(Font.custom("GillSans", size: iconHeight))
                    .foregroundStyle(.white)
                
                    .onTapGesture {
                        show_add_view.toggle()
                    }
                    .sheet(isPresented: $show_add_view) {
                        ExpenseAddView(realmManager: realmManager)
                            .presentationDetents([.fraction(0.66)])
                           
                    }
                
            }
            .shadow(radius: 1)
            
            
            Button(action: { realmManager.logout() }) {
                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
                        .resizable()
                        .frame(width: iconWidth, height: iconHeight)
                        .foregroundStyle(Color.red)
            }
            .shadow(radius: 1)
            
            
//            Button(action: { realmManager.logout() }) {
//                Image(systemName: "rectangle.portrait.and.arrow.right.fill")
//                        .resizable()
//                        .frame(width: iconWidth, height: iconHeight)
//                        .foregroundStyle(Color.red)
//            }
//            .shadow(radius: 1)
            
        }
        
    }
    
}

#Preview {
    
    ExpensesView(realmManager: RealmManager())
    
}
