import WidgetKit
import AppIntents

struct SinglePlayerConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Single player configuration"
    // static var description = IntentDescription("This is an example widget.")

    @Parameter(title: "Player", default: Player.player1)
    var player: Player
}
