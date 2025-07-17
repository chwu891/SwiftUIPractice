//
//  TimerRowView.swift
//  SwiftUIPractice
//
//  Created by Chi-Hsien Wu on 7/16/25.
//

import SwiftUI

struct TimerRowView: View {
    
    @ObservedObject var rowTimer: RowTimer
    
    var body: some View {
        HStack {
            Text("Time: \(Int(rowTimer.time))s")
            Spacer()
            Button(rowTimer.isManuallyPaused ? "Resume" : "Pause") {
                rowTimer.toggleManualPause()
            }
        }
        .padding()
        .background(
            rowTimer.isManuallyPaused ? Color.gray.opacity(0.2) : Color.green.opacity(0.2)
        )
        .onAppear {
            rowTimer.start()
        }
        .onDisappear {
            rowTimer.stop()
        }
    }
}

#Preview {
    TimerRowView(rowTimer: RowTimer())
}
