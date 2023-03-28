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
            HStack {
                Spacer()

                Button(action: {
                    showingSettings = false
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                })
                .font(.title2)
                .buttonStyle(.borderless)
                .padding()
            }

            GroupBox {
                Text("Select Color for QR Code")
                    .font(.subheadline)
                    .padding()

                HStack {
                    RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                        .fill(Color(nsColor: NSColor(fromHex: rgbHex)))
                        .frame(width: 60, height: 40)
                        .border(.primary, width: 2)

                    TextField("Color Hex:", text: $rgbHex)
                }.padding()
            }

            GroupBox {
                Text("Select Icon to embedd in QR Code")
                    .font(.subheadline)
                    .padding()

                HStack {
                    Image(nsImage: NSImage(data: pickedImageData ?? Data()) ?? NSImage())
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .border(.primary, width: 2)

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

                    Spacer()
                }.padding()
            }
            
            if pickedImageData != nil {
                GroupBox {
                    Text("Select Icon Size")
                        .font(.subheadline)
                        .padding()
                    
                    Slider(value: $iconSize, in: 10...100)
                }
            }

            GroupBox {
                Text("Preview")
                    .padding()

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
                }

                Button("Save") {
                    configurationViewModel.saveIcon(pickedImageData)
                    configurationViewModel.saveColor(rgbHex)
                    configurationViewModel.saveIconSize(NSSize(width: iconSize, height: iconSize))
                    showingSettings = false
                    
                    if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
                        appDelegate.qrCodeViewModel.lastValidURL = nil
                    }
                }.padding()
            }
        }.onAppear {
            rgbHex = configurationViewModel.getSavedColor()
            pickedImageData = configurationViewModel.getIconData()
            iconSize = configurationViewModel.getIconSize().width
        }
        .frame(width: 320)
    }
}
