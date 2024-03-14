import AppIntents
import SwiftUI
import WidgetKit

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

//struct OpenCounter: AppIntent {
//    static var title: LocalizedStringResource = "Open Counter"
//    
//    func perform() async throws -> some IntentResult {
//        .result()
//    }
//}

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

//extension UserDefaults {
//    static var shared: UserDefaults {
//        return UserDefaults(suiteName: "group.com.garrett-harris.adam.game-counter-app")!
//    }
//}

struct AddPointsIntent: AppIntent {
    static var title: LocalizedStringResource = "Add to Score"
    
    @Parameter(title: "Amount", default: 1, requestValueDialog: "How many points?")
    var amount: Int
    
    @Parameter(title: "Player", requestValueDialog: "Which player?")
    var player: Player

    func perform() async throws -> some IntentResult & ShowsSnippetView & ReturnsValue<Int> {
        let store = UserDefaults(suiteName: "group.com.garrett-harris.adam")!
        switch player {
        case .myself:
            let key = "player1Score"
            let score = store.integer(forKey: key)
            let score2 = store.integer(forKey: "player2Score")
            let newScore = score + amount
            store.setValue(newScore, forKey: key)
//            WidgetCenter.shared.reloadTimelines(ofKind: "com.garrett-harris.adam.game-counter-app.singleplayerwidget")
            return .result(value: newScore) {
                SnippetView(player1: newScore, player2: score2)
            }
        case .opponent:
            let key = "player2Score"
            let score = store.integer(forKey: key)
            let score1 = store.integer(forKey: "player1Score")
            let newScore = score + amount
            store.setValue(newScore, forKey: key)
//            WidgetCenter.shared.reloadTimelines(ofKind: "com.garrett-harris.adam.game-counter-app.singleplayerwidget")
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
//            intent: AddPointsIntent(),
//            phrases: ["Add to my score in \(.applicationName)"],
//            shortTitle: "Add to my score",
//            systemImageName: "plus.circle"
//        )
//    }
//}
