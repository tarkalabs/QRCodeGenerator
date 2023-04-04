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
        TimerManager().startTimer { timer in
            let pasteBoardColor = NSPasteboardHelper.getRecentPickedColor()
            
            if pasteBoardColor.isValidColor {
                self.pickedColor = pasteBoardColor
            }
        }
    }
}
