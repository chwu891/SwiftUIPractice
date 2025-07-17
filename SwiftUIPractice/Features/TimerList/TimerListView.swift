//
//  TimerListView.swift
//  SwiftUIPractice
//
//  Created by Chi-Hsien Wu on 7/16/25.
//

import SwiftUI

final class TimerListViewModel: ObservableObject {
    
    @Published var timers: [RowTimer] = (0..<50).map { _ in RowTimer() }
}

struct TimerListView: View {
    
    @StateObject private var viewModel = TimerListViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.timers) { timer in
                TimerRowView(rowTimer: timer)
            }
        }
    }
}

#Preview {
    TimerListView()
}
