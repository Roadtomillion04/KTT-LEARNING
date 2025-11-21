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
                
                IconData(icon: "mappin", title: LocalizedStringResource("zone"), value: location)
                
                IconData(icon: "clock", title: LocalizedStringResource("date"), value: inTime)
                
                IconData(icon: "pencil.circle", title: LocalizedStringResource("lr_number"), value: lrNumber)
                
                if !loadingCharges.isEmpty {
                    IconData(icon: "banknote.fill", title: LocalizedStringResource("loading_charge"), value: loadingCharges)
                }
                
                if !unloadingCharges.isEmpty {
                    IconData(icon: "banknote.fill", title: LocalizedStringResource("unloading_charge"), value: unloadingCharges)
                }
                
                LazyVGrid(columns: columns, spacing: 30) {
                    
                    if !lrImage.isEmpty {
                        
                        Section {
                            
                            ForEach(lrImage.map( { $0.url ?? "" } ), id: \.self) { url in
                                ImagePreview(imageUrl: url)
                            }
                            
                        } header: {
                            Text(LocalizedStringResource("lorry_receipt_lr"))
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
                            Text(LocalizedStringResource("proof_of_delivery_pod"))
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
                            Text(LocalizedStringResource("documents"))
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
