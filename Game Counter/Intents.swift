import AppIntents
import Foundation

enum Person: String {
    case myself
    case opponent
}

extension Person: AppEnum {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: LocalizedStringResource(stringLiteral: "Person"))
    
    static var caseDisplayRepresentations: [Person : DisplayRepresentation] = [
        .myself: "Myself",
        .opponent: "Opponent"
    ]
}

struct AddIntent: AppIntent {
    static var title: LocalizedStringResource = "Add to Score"
    
    @Parameter(title: "Amount")
    var amount: Int
    
    @Parameter(title: "Person")
    var person: Person

    func perform() async throws -> some IntentResult {
        let store = UserDefaults()
        let key = switch person {
        case .myself: "player1Score"
        case .opponent: "player2Score"
        }
        let score = store.integer(forKey: key)
        store.setValue(score + amount, forKey: key)
        return .result()
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$amount) to \(\.$person)")
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
