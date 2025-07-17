//
//  RowTimer.swift
//  SwiftUIPractice
//
//  Created by Chi-Hsien Wu on 7/16/25.
//

import SwiftUI

final class RowTimer: ObservableObject, Identifiable {
    
    @Published var time: TimeInterval = 0
    @Published var isManuallyPaused: Bool = false
    
    private var timer: Timer?
    
    func start() {
        guard timer == nil else { return }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
            guard let self else { return }
            if !self.isManuallyPaused {
                self.time += 1
            }
        })
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func toggleManualPause() {
        isManuallyPaused.toggle()
    }
}
