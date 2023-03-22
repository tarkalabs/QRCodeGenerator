//
//  QRCodeView.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 21/03/23.
//

import SwiftUI

struct QRCodeView: View {
    @ObservedObject var viewModel: QRCodeViewModel

    var body: some View {
        VStack {
            if let image = viewModel.qrCodeImage {
                Image(nsImage: image)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .padding()
                
                
                if !viewModel.isSuccess {
                    Text("Please copy a valid URL")
                        .padding()
                }
            }
        }
        .frame(width: 320, height: 320)
    }
}
