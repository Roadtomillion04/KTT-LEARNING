//
//  ExpenseChartView.swift
//  MyApp2
//
//  Created by Nirmal kumar on 04/07/25.
//

import SwiftUI
import Charts


// Charts Plotabble either have to be Class, Enum or Struct

struct ExpenseCategory: Identifiable { // it has to be identifiable because of forEach
    
    var _id: UUID
    var category: String
    var sum: Int
    var id: UUID { _id } // idk what's the issue, I don't find it in online anywhere
    
}

struct ExpenseChartView: View {
    
    @ObservedObject var realmManager: RealmManager
    
    // let's set start date to last week
    @State private var start_date: Date = Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date() // -6 because: starting date is also counted
    
    @State private var end_date: Date = Date()

    
    // Back to @State because Im using button to handle
    @State private var expense_chart: [ExpenseCategory] = [] // so was using @State before, and nothing was displayed so I think, calling it everytime refresh the view, and it emptied array?  -> only one init call!!
    // I get it now, is the reason toggle() works, it resets to default false on refresh view (@State) -- is false lol toggle is just one true one false
  
    
    @State private var show_popover_menu: Bool = false

    @State private var show_annotations: Bool = false
  
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Date Range: ")
                .font(Font.custom("ArialRoundedMTBold", size: 20))
            
            // display only date
            DatePicker("From", selection: $start_date, displayedComponents: .date)
                .font(Font.custom("GillSans", size: 20))
            
            DatePicker("To", selection: $end_date, displayedComponents: .date)
                .font(Font.custom("GillSans", size: 20))
            
            // on button action, no need for () calling func
            Button(action: display_chart ) {
                Text("Show Chart")
                    .padding(7.5)
                    .background(Color.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
            }
            
        }
        .padding(.horizontal)
        
        
        Spacer()
        
        HStack {
            
            Text("Total Expenses    : ₹\(self.expense_chart.filter({ $0.category != "Credit" }).map({ $0.sum }).reduce(0, +)) \nCredits Received : ₹\(self.expense_chart.filter({ $0.category == "Credit" }).map({ $0.sum }).reduce(0, +))")
                .foregroundStyle(.primary)
                .font(Font.custom("GillSans", size: 20))
            
     
            
            Menu("Summary ⌄") {
                                                    // desc sort
                ForEach(self.expense_chart.sorted(by: { $0.sum < $1.sum }).filter({$0.sum > 0})) { entry in
                    Text("\(entry.category) : ₹\(entry.sum)")
                }
                
            }
            
//            Button("Annotation") { show_annotations.toggle() }
            .padding(.vertical, 5)
            .padding(.horizontal)
            .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: 0xF1F5F9)))
            .foregroundStyle(Color.black)
            .font(Font.custom("ArialRoundedMTBold", size: 20))
            .disabled(!show_popover_menu)
            .opacity(show_popover_menu ? 1 : 0)
            
        }
        .padding(.horizontal)
        .padding(.bottom)
        .onAppear(perform: display_chart)
        
        VStack {

            Chart {
                
                // let's display Credit at last, and change color
                ForEach(self.expense_chart.filter({ $0.category != "Credit" })) { entry in
                    
                    BarMark(
                        x: .value("Category", entry.category),
                        y: .value("Spent", entry.sum)
                    )
                    .foregroundStyle(.blue.gradient)
                    
//                    .annotation(position: .trailing) {
//                        if show_annotations {
//                            Text("₹\(entry.sum)")
//                                .font(Font.custom("GillSans", size: 10))
//                        }
//                    }
                    
                }

        
                BarMark(
                    x: .value("Category", self.expense_chart.filter( { $0.category == "Credit" }).first?.category ?? ""),
                    
                    y: .value("Spent", self.expense_chart.filter( { $0.category == "Credit" }).first?.sum ?? 0)
                )
                .foregroundStyle(.green.gradient)
                
//                .annotation(position: .trailing) {
//                    if show_annotations {
//                        Text("₹\(self.expense_chart.filter( { $0.category == "Credit" }).first?.sum ?? 0)")
//                            .font(Font.custom("GillSans", size: 10))
//                    }
//                }
                
                
            }
            
            // this adding manual legend
            .chartForegroundStyleScale(["Expenses": Color.blue.gradient, "Credit": Color.green.gradient])
            
            .chartYAxis {
                
                AxisMarks(stroke: StrokeStyle(lineWidth: 0)) // this remove the stroke grid in the background
                
                AxisMarks(position: .leading) // by default y axis is placed at right side
            }
            
            
            .chartXAxis{
                AxisMarks(stroke: StrokeStyle(lineWidth: 0))
            }
            
//            .chartYScale(domain: 0...1000) --> setting Y axis scale manually
            
        }
        .padding(.horizontal)
        .onAppear(perform: display_chart) // onAppear works, where init() isn't
        
    }
    
    
    private func display_chart() {
        
        // menu breaks on click without graph
        show_popover_menu = true
        
        self.expense_chart = []
        
        // so, Date() by default sets to UTC time, so setting time to 00:00 and 23:59 is more appropriate here
        
        let start_of_date = Calendar.current.startOfDay(for: start_date)
        
        let end_of_date = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: end_date) ?? end_date // avoid ! unwrap
        
        
        for (category, expenses) in realmManager.chart_dict {
            self.expense_chart.append(
                .init(_id: UUID(), category: category, sum: expenses.filter({ $0.date >= start_of_date && $0.date <= end_of_date }).map({$0.amount}).reduce(0, +))
            )

        }
        
        // menu breaks on click, when there are no entries
        if self.expense_chart.map({ $0.sum }).reduce(0, +) == 0 {
            show_popover_menu = false
        }
   
    }
    
}

#Preview {
    
//    ExpenseChartView(realmManager: RealmManager())
    
}

