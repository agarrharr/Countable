import WidgetKit
import SwiftUI

struct SinglePlayerProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SinglePlayerEntry {
        SinglePlayerEntry(date: Date(), score: 0, configuration: SinglePlayerConfigurationAppIntent())
    }

    func snapshot(for configuration: SinglePlayerConfigurationAppIntent, in context: Context) async -> SinglePlayerEntry {
        SinglePlayerEntry(date: Date(), score: getScore(player: configuration.player), configuration: configuration)
    }
    
    func timeline(for configuration: SinglePlayerConfigurationAppIntent, in context: Context) async -> Timeline<SinglePlayerEntry> {
        let entries: [SinglePlayerEntry] = [
            SinglePlayerEntry(
                date: Date(),
                score: getScore(player: configuration.player),
                configuration: configuration
            )
        ]

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    private func getScore(player: Player) -> Int {
        let store = UserDefaults(suiteName: "group.com.garrett-harris.adam")!
        let key = switch player {
        case .myself: "player1Score"
        case .opponent: "player2Score"
        }
        return store.integer(forKey: key)
    }
}

struct SinglePlayerEntry: TimelineEntry {
    let date: Date
    let score: Int
    let configuration: SinglePlayerConfigurationAppIntent
}

struct SinglePlayerWidgetEntryView : View {
    var entry: SinglePlayerProvider.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                Text("\(entry.configuration.player)")
                Text("\(entry.score)")
                HStack {
                    Button(intent: AddPointsIntent(player: entry.configuration.$player)) {
                        Text("-")
                    }
                    
                    Spacer()
                    
                    Button(intent: AddPointsIntent(player: entry.configuration.$player)) {
                        Text("+")
                    }
                }
            }
        default:
            Text("\(entry.score)")
        }
    }
}

struct SinglePlayerWidget: Widget {
    let kind: String = "com.garrett-harris.adam.game-counter-app.singleplayerwidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SinglePlayerConfigurationAppIntent.self, provider: SinglePlayerProvider()) { entry in
            SinglePlayerWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Single Player")
        .description("Keep track of one player's score")
        #if os(watchOS)
        .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular])
        #else
        .supportedFamilies([.accessoryCircular, .accessoryInline, .accessoryRectangular, .systemSmall])
        #endif
    }
}

extension SinglePlayerConfigurationAppIntent {
    fileprivate static var myself: SinglePlayerConfigurationAppIntent {
        let intent = SinglePlayerConfigurationAppIntent()
        intent.player = .myself
        return intent
    }
    
    fileprivate static var opponent: SinglePlayerConfigurationAppIntent {
        let intent = SinglePlayerConfigurationAppIntent()
        intent.player = .opponent
        return intent
    }
}

#Preview(as: .systemSmall) {
    SinglePlayerWidget()
} timeline: {
    SinglePlayerEntry(date: .now, score: 20, configuration: .myself)
    SinglePlayerEntry(date: .now, score: 22, configuration: .opponent)
}

#Preview(as: .accessoryCircular) {
    SinglePlayerWidget()
} timeline: {
    SinglePlayerEntry(date: .now, score: 20, configuration: .myself)
    SinglePlayerEntry(date: .now, score: 22, configuration: .opponent)
}

#Preview(as: .accessoryInline) {
    SinglePlayerWidget()
} timeline: {
    SinglePlayerEntry(date: .now, score: 20, configuration: .myself)
    SinglePlayerEntry(date: .now, score: 22, configuration: .opponent)
}

#Preview(as: .accessoryRectangular) {
    SinglePlayerWidget()
} timeline: {
    SinglePlayerEntry(date: .now, score: 20, configuration: .myself)
    SinglePlayerEntry(date: .now, score: 22, configuration: .opponent)
}
