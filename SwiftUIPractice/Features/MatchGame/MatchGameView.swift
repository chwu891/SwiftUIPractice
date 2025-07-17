//
//  MatchGameView.swift
//  SwiftUIPractice
//
//  Created by Chi-Hsien Wu on 7/16/25.
//

import SwiftUI

struct Card: Identifiable {
    let id = UUID()
    let image: Image
    var isMatched = false
    var isFlipped = false
}

final class MatchGameViewModel: ObservableObject {
    
    @Published var cards: [Card] = []
    @Published var steps = 0
    @Published var isGameFinished = false
    @Published var isBusy: Bool = false
    @Published var elapsedTime: TimeInterval = 0
    
    private var firstFlippedCardIndex: Int?
    private var gameStartDate: Date?
    private var timer: Timer?
    
    func startGame() {
        let images: [Image] = [
            Image(systemName: "house"),
            Image(systemName: "heart"),
            Image(systemName: "paperplane"),
            Image(systemName: "tray"),
            Image(systemName: "ruler"),
            Image(systemName: "pencil")
        ]
        var deck = (images + images).map { Card(image: $0) }
        deck.shuffle()
        cards = deck
        steps = 0
        isGameFinished = false
        firstFlippedCardIndex = nil
        elapsedTime = 0
        gameStartDate = Date()
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.gameStartDate else { return }
            self.elapsedTime = Date().timeIntervalSince(start)
        }
    }
    
    func flipCard(at index: Int) {
        guard !cards[index].isMatched,
              !cards[index].isFlipped,
              !isBusy else { return }
        
        cards[index].isFlipped = true
        
        if let first = firstFlippedCardIndex {
            isBusy = true
            steps += 1
            if cards[first].image == cards[index].image {
                cards[first].isMatched = true
                cards[index].isMatched = true
                firstFlippedCardIndex = nil
                isBusy = false
                
                if cards.allSatisfy(\.isMatched) {
                    isGameFinished = true
                    timer?.invalidate()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.cards[first].isFlipped = false
                    self.cards[index].isFlipped = false
                    self.isBusy = false
                }
                self.firstFlippedCardIndex = nil
            }
        } else {
            firstFlippedCardIndex = index
        }
    }
}

struct MatchGameView: View {
    
    @StateObject private var viewModel = MatchGameViewModel()
    
    private let columns = [GridItem(.adaptive(minimum: 100))]
    
    var body: some View {
        VStack(spacing: 10) {
            Button("Start Game") {
                viewModel.startGame()
            }
            .padding()
            .background(Color.white)
            .clipShape(Capsule())
            
            Text(String(format: "Time: %.1fs", viewModel.elapsedTime))
            Text("Steps: \(viewModel.steps)")
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Array(viewModel.cards.enumerated()), id: \.element.id) { index, card in
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(card.isFlipped ? Color.white : Color.blue)
                            .frame(height: 100)
                        
                        if card.isFlipped || card.isMatched {
                            card.image
                                .resizable()
                                .scaledToFit()
                                .frame(width:50, height: 50)
                        }
                    }
                    .onTapGesture {
                        viewModel.flipCard(at: index)
                    }
                    .animation(.default, value: card.isFlipped)
                }
            }
            .padding()
            
            if viewModel.isGameFinished {
                Text("🎉 Congrats!")
                    .font(.title)
                    .foregroundColor(.green)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.4))
    }
}

#Preview {
    MatchGameView()
}
