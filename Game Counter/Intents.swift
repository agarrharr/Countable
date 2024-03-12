import AppIntents
import Foundation

struct AddIntent: AppIntent {
    static var title: LocalizedStringResource = "Add to Score"
    
    func perform() async throws -> some IntentResult {
        let store = UserDefaults()
        let score = store.integer(forKey: "player1Score")
        store.setValue(score + 1, forKey: "player1Score")
        return .result()
    }
}
