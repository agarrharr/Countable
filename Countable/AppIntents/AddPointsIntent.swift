//import Dependencies
import AppIntents

struct AddPointsIntent: AppIntent {
    static var title: LocalizedStringResource = "Add to Score"
    
    @Parameter(title: "Amount", default: 1, requestValueDialog: "How many points?")
    var amount: Int
    
    @Parameter(title: "Player", requestValueDialog: "Which player?")
    var player: Player
    
    func perform() async throws -> some IntentResult & ShowsSnippetView & ReturnsValue<Int> {
        return .result(value: addToScore(amount, for: player)) {
            ShortcutsSnippetView()
        }
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$amount) to \(\.$player)")
    }
}

func addToScore(_ amount: Int, for player: Player) -> Int {
//    @Dependency(\.appStorage) var appStorage
//    let newScore = appStorage.incrementScore(by: amount, for: player)
//    return newScore
    
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
