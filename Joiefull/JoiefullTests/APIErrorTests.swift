import Testing
import Foundation
@testable import Joiefull

struct APIErrorTests {
    @Test("invalidURL has correct description")
    func invalidURLDescription() {
        let error = APIError.invalidURL
        #expect(error.localizedDescription == "URL invalide")
    }

    @Test("invalidResponse has correct description")
    func invalidResponseDescription() {
        let error = APIError.invalidResponse
        #expect(error.localizedDescription == "Réponse invalide")
    }

    @Test("httpError has correct description with status code")
    func httpErrorDescription() {
        let error = APIError.httpError(statusCode: 404)
        #expect(error.localizedDescription == "Erreur HTTP: 404")
    }

    @Test("decodingError has correct description")
    func decodingErrorDescription() {
        let underlying = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "bad json"])
        let error = APIError.decodingError(underlying)
        #expect(error.localizedDescription.contains("Erreur de décodage"))
    }

    @Test("networkError has correct description")
    func networkErrorDescription() {
        let underlying = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "no connection"])
        let error = APIError.networkError(underlying)
        #expect(error.localizedDescription.contains("Erreur réseau"))
    }

    @Test("unknown has correct description")
    func unknownDescription() {
        let error = APIError.unknown
        #expect(error.localizedDescription == "Erreur inconnue")
    }
}
