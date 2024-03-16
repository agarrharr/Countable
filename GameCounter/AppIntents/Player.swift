import AppIntents

enum Player: String {
    case player1 = "Player 1"
    case player2 = "Player 2"
}

extension Player: AppEnum {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: LocalizedStringResource(stringLiteral: "Player"))
    
    static var caseDisplayRepresentations: [Player : DisplayRepresentation] = [
        .player1: "Player 1",
        .player2: "Player 2"
    ]
}
