//
//  TimerManager.swift
//  QRCode-Generator
//
//  Created by Ibrahim Hassan on 29/03/23.
//

import Foundation

class TimerManager {
    private var timer: Timer?
    var timerInterval: Double = 1
    
    func startTimer(timerBlock: @escaping (Timer) -> Void) {
        timer = Timer.scheduledTimer(
            withTimeInterval: timerInterval,
            repeats: true,
            block: timerBlock
        )
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}
