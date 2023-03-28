//
//  QRCodeView.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 21/03/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct QRCodeView: View {
    @ObservedObject var viewModel: QRCodeViewModel
    @State var showingHistory = false
    @State var showingSettings = false

    var body: some View {
        VStack(alignment: .center) {
            if !viewModel.isSuccess {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                
                Text("Please copy a valid URL")
                    .padding()
            }
            
            if let qrCodeImageData = viewModel.qrCodeImageData, let qrCodeImage = NSImage(data: qrCodeImageData) {
                Image(nsImage: qrCodeImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .onDrag {
                        let url = viewModel.lastValidURL ?? ""
                        let fileURL = FileManager.sharedContainerURL?.appendingPathComponent("qrCode.png")
                        
                        do {
                            try QRCodeGenerator.getQRCodeImage(content: url)?.savePngTo(url: fileURL!)
                        } catch {
                            print (error)
                        }
                                    
                        return NSItemProvider(item: fileURL! as NSSecureCoding, typeIdentifier: UTType.fileURL.identifier)
                    }
            }
            
            Divider()

            HStack {
                Button {
                    self.showingHistory.toggle()
                } label: {
                    HStack {
                        Image(systemName: "clock")
                        
                        Text("History")
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .sheet(isPresented: $showingHistory) {
                    HistoryView(historyViewModel: viewModel.historyManager, showingHistory: $showingHistory)
                }
                
                Button {
                    self.showingSettings.toggle()
                } label: {
                    HStack {
                        Image(systemName: "gearshape.fill")
                        
                        Text("Settings")
                    }
                }
                .buttonStyle(.automatic)
                .padding()
                .sheet(isPresented: $showingSettings) {
                    ConfigurationView(showingSettings: $showingSettings)
                }
            }
        }
        .frame(width: 320, height: 400)
    }
}
