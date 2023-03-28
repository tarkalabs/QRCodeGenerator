//
//  ConfigurationView.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 28/03/23.
//

import SwiftUI

struct ConfigurationView: View {
    @State private var rgbHex: String = ""
    @Binding var showingSettings: Bool
    @State private var pickedImageData: Data?
    private let configurationViewModel = ConfigurationHelper()
    @State private var iconSize: Double = 10

    var body: some View {
        VStack {
            GroupBox {
                Text("Color")
                    .font(.title)

                HStack {
                    RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                        .fill(Color(nsColor: NSColor(fromHex: rgbHex)))
                        .frame(width: 60, height: 40)
                        .border(.primary, width: 2)

                    TextField("Color Hex:", text: $rgbHex)
                }.padding(.horizontal)
            }

            GroupBox {
                Text("Icon")
                    .font(.title)

                HStack {
                    Image(nsImage: NSImage(data: pickedImageData ?? Data()) ?? NSImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .border(.primary, width: 2)
                        .padding(.horizontal)

                    Button("Select Icon") {
                        let openPanel = NSOpenPanel()
                        openPanel.prompt = "Select File"
                        openPanel.allowsMultipleSelection = false
                        openPanel.canChooseDirectories = false
                        openPanel.canCreateDirectories = false
                        openPanel.canChooseFiles = true
                        openPanel.allowedContentTypes = [.png, .jpeg]
                        openPanel.begin { (result) -> Void in
                            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                                if let openPanelURL = openPanel.url {
                                    if let imageData = try? Data(contentsOf: openPanelURL) {
                                        pickedImageData = imageData
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                
                Slider(value: $iconSize, in: 10...100)
                    .padding(.horizontal)
            }

            GroupBox {
                if let image = QRCodeGenerator.previewConfigQRCode(
                    content: "www.google.com",
                    tintColor: NSColor(fromHex: rgbHex),
                    logo: NSImage(data: pickedImageData ?? Data()),
                    iconSize: NSSize(width: iconSize, height: iconSize)
                ) {
                    Image(nsImage: image)
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 300)
                        .border(.primary, width: 2)
                }
            }
            
            GroupBox {
                HStack {
                    Button(role: .cancel) {
                        showingSettings = false
                    } label: {
                        Text("Cancel")
                    }
                    .padding()
                    
                    Spacer()
                    
                    Button("Save") {
                        configurationViewModel.saveIconData(pickedImageData)
                        configurationViewModel.saveColor(rgbHex)
                        configurationViewModel.saveIconSize(NSSize(width: iconSize, height: iconSize))
                        showingSettings = false
                        
                        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                            appDelegate.qrCodeViewModel.reset()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()
                }
            }
        }.onAppear {
            rgbHex = configurationViewModel.getColor()
            pickedImageData = configurationViewModel.getIconData()
            iconSize = configurationViewModel.getIconSize().width
        }
        .frame(width: 320)
    }
}
