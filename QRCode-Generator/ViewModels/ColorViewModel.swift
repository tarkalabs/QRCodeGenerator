//
//  ColorViewModel.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 04/04/23.
//

import Combine

class ColorViewModel: ObservableObject {
    @Published var pickedColor = ""

    init() {
        self.pickedColor = NSPasteboardHelper.getRecentPickedColor()
    }
}
