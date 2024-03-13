import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let entries: [SimpleEntry] = [SimpleEntry(date: Date(), configuration: configuration)]

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct Game_Counter_WidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall:
            VStack {
                Text("Hello \(entry.configuration.player)")
                Text(entry.configuration.player.localizedStringResource)
            }
        default:
            VStack {
                Text("Hello")
                Text(entry.configuration.player.localizedStringResource)
            }
        }
    }
}

struct Game_Counter_Widget: Widget {
    let kind: String = "Game_Counter_Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            Game_Counter_WidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Single Player")
        .description("Keep track of one player's score")
    }
}

extension ConfigurationAppIntent {
    fileprivate static var myself: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.player = .myself
        return intent
    }
    
    fileprivate static var opponent: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.player = .opponent
        return intent
    }
}

#Preview(as: .systemSmall) {
    Game_Counter_Widget()
} timeline: {
    SimpleEntry(date: .now, configuration: .myself)
    SimpleEntry(date: .now, configuration: .opponent)
}
