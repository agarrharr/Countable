import WidgetKit
import SwiftUI

struct SinglePlayerProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SinglePlayerEntry {
        SinglePlayerEntry(date: Date(), configuration: SinglePlayerConfigurationAppIntent())
    }

    func snapshot(for configuration: SinglePlayerConfigurationAppIntent, in context: Context) async -> SinglePlayerEntry {
        SinglePlayerEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: SinglePlayerConfigurationAppIntent, in context: Context) async -> Timeline<SinglePlayerEntry> {
        let entries: [SinglePlayerEntry] = [SinglePlayerEntry(date: Date(), configuration: configuration)]

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SinglePlayerEntry: TimelineEntry {
    let date: Date
    let configuration: SinglePlayerConfigurationAppIntent
}

struct SinglePlayerWidgetEntryView : View {
    var entry: SinglePlayerProvider.Entry
    
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

struct SinglePlayerWidget: Widget {
    let kind: String = "Single Player Widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: SinglePlayerConfigurationAppIntent.self, provider: SinglePlayerProvider()) { entry in
            SinglePlayerWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Single Player")
        .description("Keep track of one player's score")
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
    SinglePlayerEntry(date: .now, configuration: .myself)
    SinglePlayerEntry(date: .now, configuration: .opponent)
}
