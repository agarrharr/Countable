import AppIntents

struct SubtractPointsIntent: AppIntent {
    static var title: LocalizedStringResource = "Subtract from Score"
    
    @Parameter(title: "Amount", default: 1, requestValueDialog: "How many points?")
    var amount: Int
    
    @Parameter(title: "Player", requestValueDialog: "Which player?")
    var player: Player
    
    func perform() async throws -> some IntentResult & ShowsSnippetView & ReturnsValue<Int> {
        return .result(value: addToScore(-amount, for: player)) {
            ShortcutsSnippetView()
        }
    }
    
    static var parameterSummary: some ParameterSummary {
        Summary("Subtract \(\.$amount) from \(\.$player)")
    }
}
