import AppIntents
import SwiftUI

enum Player: String {
    case myself
    case opponent
}

extension Player: AppEnum {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: LocalizedStringResource(stringLiteral: "Player"))
    
    static var caseDisplayRepresentations: [Player : DisplayRepresentation] = [
        .myself: "Myself",
        .opponent: "Opponent"
    ]
}

struct OpenCounter: AppIntent {
    static var title: LocalizedStringResource = "Open Counter"
    
    func perform() async throws -> some IntentResult {
        .result()
    }
}

struct SnippetView: View {
    var player1: Int
    var player2: Int

    var body: some View {
        VStack {
            Text("Opponent: \(player2)")
                .font(.title2)
            Text("You: \(player1)")
                .font(.title2)
        }
    }
}

struct AddIntent: AppIntent {
    static var title: LocalizedStringResource = "Add to Score"
    
    @Parameter(title: "Amount", requestValueDialog: "How many points?")
    var amount: Int
    
    @Parameter(title: "Player", requestValueDialog: "Which player?")
    var player: Player

    func perform() async throws -> some IntentResult & ShowsSnippetView & ReturnsValue<Int> {
        let store = UserDefaults()
        switch player {
        case .myself:
            let key = "player1Score"
            let score = store.integer(forKey: key)
            let score2 = store.integer(forKey: "player2Score")
            let newScore = score + amount
            store.setValue(newScore, forKey: key)
            return .result(value: newScore) {
                SnippetView(player1: newScore, player2: score2)
            }
        case .opponent:
            let key = "player2Score"
            let score = store.integer(forKey: key)
            let score1 = store.integer(forKey: "player1Score")
            let newScore = score + amount
            store.setValue(newScore, forKey: key)
            return .result(value: newScore) {
                SnippetView(player1: score1, player2: newScore)
            }
        }
        
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$amount) to \(\.$player)")
    }
}

//struct GameCounterAutoShortcuts: AppShortcutsProvider {
//    static var appShortcuts: [AppShortcut] {
//        AppShortcut(
//            intent: AddIntent(),
//            phrases: ["Add to my score in \(.applicationName)"],
//            shortTitle: "Add to my score",
//            systemImageName: "plus.circle"
//        )
//    }
//}
