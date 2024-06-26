import AppIntents

struct SinglePlayerConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Single Player"
    // static var description = IntentDescription("This is an example widget.")

    @Parameter(title: "Player", default: Player.player1)
    var player: Player
    
    @Parameter(title: "Amount to add", default: 1)
    var amountToAdd: Int
    
    @Parameter(title: "Amount to subtract", default: 1)
    var amountToSubtract: Int
}
