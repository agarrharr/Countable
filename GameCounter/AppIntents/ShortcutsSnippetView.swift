import SwiftUI

struct ShortcutsSnippetView: View {
    var score1: Int
    var score2: Int
    
    let store = UserDefaults(suiteName: "group.com.garrett-harris.adam")!
    
    init() {
        self.score1 = store.integer(forKey: "player1Score")
        self.score2 = store.integer(forKey: "player2Score")
    }

    var body: some View {
        VStack {
            Text("Player 1: \(score1)")
                .font(.title2)
            Text("Player 2: \(score2)")
                .font(.title2)
        }
    }
}
