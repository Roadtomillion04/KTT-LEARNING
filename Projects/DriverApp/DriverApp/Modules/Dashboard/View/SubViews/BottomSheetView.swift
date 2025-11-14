//
//  BottomSheetView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 31/10/25.
//

import SwiftUI

struct ZoneInfoView: View {
    let location: String
    let inTime: String
    let lrNumber: String
    let loadingCharges: String
    let unloadingCharges: String
    let lrImage: [APIService.DriverStatusAttributes.ImageShare]
    let podImage: [APIService.DriverStatusAttributes.ImageShare]
    let docImage: [APIService.DriverStatusAttributes.ImageShare]
    
    // no of columns for VGrid
    let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
    
    var body: some View {
        
        ScrollView {
        
            VStack(alignment: .leading, spacing: 16) {
                
                IconData(icon: "mappin", title: "Zone", value: location)
                
                IconData(icon: "clock", title: "Date", value: inTime)
                
                IconData(icon: "pencil.circle", title: "LR Number", value: lrNumber)
                
                if !loadingCharges.isEmpty {
                    IconData(icon: "banknote.fill", title: "Loading Charge", value: loadingCharges)
                }
                
                if !unloadingCharges.isEmpty {
                    IconData(icon: "banknote.fill", title: "Unloading Charge", value: unloadingCharges)
                }
                
                LazyVGrid(columns: columns, spacing: 30) {
                    
                    if !lrImage.isEmpty {
                        
                        Section {
                            
                            ForEach(lrImage.map( { $0.url ?? "" } ), id: \.self) { url in
                                ImagePreview(imageUrl: url)
                            }
                            
                        } header: {
                            Text("Lorry Receipt (LR)")
                                .font(Font.custom("ArialRoundedMTBold", size: 15))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.ultraThinMaterial)
                                .foregroundStyle(Color(.systemGray))

                        }
                    }
                    
                    if !podImage.isEmpty {
                        
                        Section {
                            
                            ForEach(podImage.map( { $0.url ?? "" } ), id: \.self) { url in
                                ImagePreview(imageUrl: url)
                            }
                            
                        } header: {
                            Text("Proof of Delivery (POD)")
                                .font(Font.custom("ArialRoundedMTBold", size: 15))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.ultraThinMaterial)
                                .foregroundStyle(Color(.systemGray))

                        }
                    }
                    
                    if !docImage.isEmpty {
                        
                        Section {
                            
                            ForEach(docImage.map( { $0.url ?? "" } ), id: \.self) { url in
                                ImagePreview(imageUrl: url)
                            }
                            
                            
                        } header: {
                            Text("Documents")
                                .font(Font.custom("ArialRoundedMTBold", size: 15))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(.ultraThinMaterial)
                                .foregroundStyle(Color(.systemGray))

                        }
                    }
                }
            }
            
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
        
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemGray6)))

        
    }
}

#Preview {
//    BottomSheetView()
}
