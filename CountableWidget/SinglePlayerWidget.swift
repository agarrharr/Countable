import WidgetKit
import SwiftUI
import AppIntents

extension Player {
    var buttonColor: Color {
        switch self {
        case .player1: Color("DarkBlue")
        case .player2: Color("LightBlue")
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .player1: Color("DarkBlueBackground")
        case .player2: Color("LightBlueBackground")
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .player1: .white
        case .player2: .black
        }
    }
}

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
        case .player1: "player1Score"
        case .player2: "player2Score"
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
            ZStack {
                entry.configuration.player.backgroundColor
                VStack {
                    Text("\(entry.configuration.player.rawValue)")
                        .foregroundStyle(entry.configuration.player.foregroundColor)
                        .font(.body)
                    
                    Text("\(entry.score)")
                        .foregroundStyle(entry.configuration.player.foregroundColor)
                        .font(.title)
                        .contentTransition(.numericText())
                        .privacySensitive()
                    
                    Spacer()
                    
                    HStack {
                        Button(
                            intent: SubtractPointsIntent(
                                amount: entry.configuration.$amountToSubtract,
                                player: entry.configuration.$player
                            )
                        ) {
                            Text("-\(entry.configuration.amountToSubtract)")
                                .foregroundStyle(entry.configuration.player.foregroundColor)
                                .clipShape(Circle())
                        }
                        .background(
                            Circle()
                                .fill(entry.configuration.player.buttonColor)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 4, y: 4)
                                .shadow(color: .white.opacity(0.2), radius: 5, x: 0, y: -1)
                        )
                        
                        Spacer()
                        
                        Button(
                            intent: AddPointsIntent(
                                amount: entry.configuration.$amountToAdd,
                                player: entry.configuration.$player
                            )
                        ) {
                            Text("+\(entry.configuration.amountToAdd)")
                                .foregroundStyle(entry.configuration.player.foregroundColor)
                                .clipShape(Circle())
                        }
                        .background(
                            Circle()
                                .fill(entry.configuration.player.buttonColor)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 4, y: 4)
                                .shadow(color: .white.opacity(0.2), radius: 5, x: 0, y: -1)
                        )
                    }
                }
                .padding()
            }
        case .accessoryCircular:
            VStack {
                Text("\(entry.score)")
                    .font(.title)
                Text("\(entry.configuration.player.shortString)")
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .background(.black)
            .clipShape(Circle())
        case .accessoryInline:
            ViewThatFits {
                Text("\(entry.configuration.player.rawValue): \(entry.score) points")
                Text("\(entry.configuration.player.shortString): \(entry.score) points")
                Text("\(entry.configuration.player.shortString): \(entry.score)")
            }
        case .accessoryRectangular:
            VStack(alignment: .center) {
                Text("\(entry.score)")
                    .font(.title)
                Text("\(entry.configuration.player.rawValue)")
            }
            .padding()
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
        .contentMarginsDisabled()
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
    fileprivate static var player1: SinglePlayerConfigurationAppIntent {
        let intent = SinglePlayerConfigurationAppIntent()
        intent.player = .player1
        return intent
    }
    
    fileprivate static var player2: SinglePlayerConfigurationAppIntent {
        let intent = SinglePlayerConfigurationAppIntent()
        intent.player = .player2
        return intent
    }
}

#Preview("System Small Player 1", as: .systemSmall) {
    SinglePlayerWidget()
} timeline: {
    SinglePlayerEntry(date: .now, score: 20, configuration: .player1)
    SinglePlayerEntry(date: .now, score: 22, configuration: .player1)
}

#Preview("System Small Player 2", as: .systemSmall) {
    SinglePlayerWidget()
} timeline: {
    SinglePlayerEntry(date: .now, score: 20, configuration: .player2)
    SinglePlayerEntry(date: .now, score: 22, configuration: .player2)
}

#Preview("Accessory Circular", as: .accessoryCircular) {
    SinglePlayerWidget()
} timeline: {
    SinglePlayerEntry(date: .now, score: 20, configuration: .player2)
    SinglePlayerEntry(date: .now, score: 22, configuration: .player2)
}

#Preview("Accessory Inline", as: .accessoryInline) {
    SinglePlayerWidget()
} timeline: {
    SinglePlayerEntry(date: .now, score: 20, configuration: .player1)
    SinglePlayerEntry(date: .now, score: 22, configuration: .player1)
}

#Preview("Accessory Rectangular", as: .accessoryRectangular) {
    SinglePlayerWidget()
} timeline: {
    SinglePlayerEntry(date: .now, score: 20, configuration: .player2)
    SinglePlayerEntry(date: .now, score: 22, configuration: .player2)
}
