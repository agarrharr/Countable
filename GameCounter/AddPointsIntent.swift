import AppIntents
import SwiftUI
import WidgetKit

enum Player: String {
    case player1 = "Player 1"
    case player2 = "Player 2"
}

extension Player: AppEnum {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: LocalizedStringResource(stringLiteral: "Player"))
    
    static var caseDisplayRepresentations: [Player : DisplayRepresentation] = [
        .player1: "Player 1",
        .player2: "Player 2"
    ]
}

struct SnippetView: View {
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

struct AddPointsIntent: AppIntent {
    static var title: LocalizedStringResource = "Add to Score"
    
    @Parameter(title: "Amount", default: 1, requestValueDialog: "How many points?")
    var amount: Int
    
    @Parameter(title: "Player", requestValueDialog: "Which player?")
    var player: Player

    func perform() async throws -> some IntentResult & ShowsSnippetView & ReturnsValue<Int> {
        return .result(value: addToScore(amount, for: player)) {
            SnippetView()
        }
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$amount) to \(\.$player)")
    }
}

struct SubtractPointsIntent: AppIntent {
    static var title: LocalizedStringResource = "Subtract from Score"
    
    @Parameter(title: "Amount", default: 1, requestValueDialog: "How many points?")
    var amount: Int
    
    @Parameter(title: "Player", requestValueDialog: "Which player?")
    var player: Player
    
    func perform() async throws -> some IntentResult & ShowsSnippetView & ReturnsValue<Int> {
        return .result(value: addToScore(-amount, for: player)) {
            SnippetView()
        }
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$amount) to \(\.$player)")
    }
}

func addToScore(_ amount: Int, for player: Player) -> Int {
    let store = UserDefaults(suiteName: "group.com.garrett-harris.adam")!
    let key = switch player {
    case .player1: "player1Score"
    case .player2: "player2Score"
    }
    
    let score = store.integer(forKey: key)
    let newScore = score + amount
    store.setValue(newScore, forKey: key)
    return newScore
}

//struct GameCounterAutoShortcuts: AppShortcutsProvider {
//    static var appShortcuts: [AppShortcut] {
//        AppShortcut(
//            intent: AddPointsIntent(),
//            phrases: ["Add to my score in \(.applicationName)"],
//            shortTitle: "Add to my score",
//            systemImageName: "plus.circle"
//        )
//    }
//}
