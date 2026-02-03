import Foundation
import OSLog

enum AppLogger {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.joiefull",
        category: "error"
    )

    static func error(_ error: Error) {
        logger.error("\(error.localizedDescription)")
    }
}

enum JoieFullError: LocalizedError {
    case invalidRating(value: Int)
    case saveFavorite
    case saveRating
    case saveComment

    var errorDescription: String? {
        switch self {
        case .invalidRating(let value):
            return "Note invalide: \(value)"
        case .saveFavorite:
            return "Impossible de sauvegarder le favori"
        case .saveRating:
            return "Impossible de sauvegarder la note"
        case .saveComment:
            return "Impossible de sauvegarder le commentaire"
        }
    }
}

