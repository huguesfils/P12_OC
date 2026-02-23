import Testing
import Foundation
import UIKit
@testable import Joiefull

// MARK: - MockURLProtocol

final class MockURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var requestHandler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: URLError(.unknown))
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}

// MARK: - APIError Equatable

extension APIError: @retroactive Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL): return true
        case (.invalidResponse, .invalidResponse): return true
        case (.unknown, .unknown): return true
        case (.httpError(let a), .httpError(let b)): return a == b
        case (.decodingError, .decodingError): return true
        case (.networkError, .networkError): return true
        default: return false
        }
    }
}

// MARK: - Helper

private func makeMockSession(handler: @escaping @Sendable (URLRequest) throws -> (HTTPURLResponse, Data)) -> URLSession {
    MockURLProtocol.requestHandler = handler
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
}

private func make1x1ImageData() -> Data {
    let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
    return renderer.pngData { ctx in
        UIColor.red.setFill()
        ctx.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    }
}

// MARK: - Thread-safe counter

final class LockedCounter: @unchecked Sendable {
    private var _value = 0
    private let lock = NSLock()
    var value: Int { lock.lock(); defer { lock.unlock() }; return _value }
    func increment() { lock.lock(); _value += 1; lock.unlock() }
}

// MARK: - Tests (single serialized suite to protect shared MockURLProtocol)

@Suite(.serialized)
@MainActor
struct NetworkLayerTests {

    // MARK: NetworkClient - Success

    @Test("NetworkClient: request succeeds with valid JSON")
    func networkClientSuccess() async throws {
        let items = [Item(id: 1, picture: Picture(url: "https://img.com/1", description: "desc"), name: "Test", category: "tops", likes: 0, price: 10, originalPrice: 15)]
        let data = try JSONEncoder().encode(items)

        let session = makeMockSession { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        let client = NetworkClient(session: session)

        let result: [Item] = try await client.request("https://api.example.com/items")
        #expect(result.count == 1)
        #expect(result.first?.name == "Test")
    }

    // MARK: NetworkClient - Invalid URL

    @Test("NetworkClient: throws invalidURL for empty string")
    func networkClientInvalidURL() async {
        let client = NetworkClient()

        do {
            let _: [Item] = try await client.request("")
            #expect(Bool(false), "Should have thrown")
        } catch let error as APIError {
            #expect(error == .invalidURL)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    // MARK: NetworkClient - HTTP Error

    @Test("NetworkClient: throws httpError for non-2xx status")
    func networkClientHTTPError() async {
        let session = makeMockSession { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 500, httpVersion: nil, headerFields: nil)!
            return (response, Data())
        }
        let client = NetworkClient(session: session)

        do {
            let _: [Item] = try await client.request("https://api.example.com/items")
            #expect(Bool(false), "Should have thrown")
        } catch let error as APIError {
            if case .httpError(let code) = error {
                #expect(code == 500)
            } else {
                #expect(Bool(false), "Expected httpError, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    // MARK: NetworkClient - Decoding Error

    @Test("NetworkClient: throws decodingError for invalid JSON")
    func networkClientDecodingError() async {
        let session = makeMockSession { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data("not json".utf8))
        }
        let client = NetworkClient(session: session)

        do {
            let _: [Item] = try await client.request("https://api.example.com/items")
            #expect(Bool(false), "Should have thrown")
        } catch let error as APIError {
            if case .decodingError = error {
                // expected
            } else {
                #expect(Bool(false), "Expected decodingError, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    // MARK: NetworkClient - Network Error

    @Test("NetworkClient: throws networkError for connection failure")
    func networkClientNetworkError() async {
        let session = makeMockSession { _ in
            throw URLError(.notConnectedToInternet)
        }
        let client = NetworkClient(session: session)

        do {
            let _: [Item] = try await client.request("https://api.example.com/items")
            #expect(Bool(false), "Should have thrown")
        } catch let error as APIError {
            if case .networkError = error {
                // expected
            } else {
                #expect(Bool(false), "Expected networkError, got \(error)")
            }
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    // MARK: ImageDownloadService - Success

    @Test("ImageDownloadService: succeeds with valid image data")
    func imageDownloadSuccess() async throws {
        let imageData = make1x1ImageData()
        let session = makeMockSession { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, imageData)
        }
        let service = ImageDownloadService(session: session)

        let image = try await service.downloadImage(from: "https://example.com/unique-\(UUID().uuidString).png")
        #expect(image.size.width > 0)
    }

    // MARK: ImageDownloadService - Invalid URL

    @Test("ImageDownloadService: throws invalidURL for empty string")
    func imageDownloadInvalidURL() async {
        let service = ImageDownloadService()

        do {
            _ = try await service.downloadImage(from: "")
            #expect(Bool(false), "Should have thrown")
        } catch let error as APIError {
            #expect(error == .invalidURL)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    // MARK: ImageDownloadService - Invalid Image Data

    @Test("ImageDownloadService: throws invalidResponse for non-image data")
    func imageDownloadInvalidData() async {
        let session = makeMockSession { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data("not an image".utf8))
        }
        let service = ImageDownloadService(session: session)

        do {
            _ = try await service.downloadImage(from: "https://example.com/bad-\(UUID().uuidString).png")
            #expect(Bool(false), "Should have thrown")
        } catch let error as APIError {
            #expect(error == .invalidResponse)
        } catch {
            #expect(Bool(false), "Unexpected error: \(error)")
        }
    }

    // MARK: ImageDownloadService - Network Error

    @Test("ImageDownloadService: throws on network failure")
    func imageDownloadNetworkError() async {
        let session = makeMockSession { _ in
            throw URLError(.notConnectedToInternet)
        }
        let service = ImageDownloadService(session: session)

        do {
            _ = try await service.downloadImage(from: "https://example.com/error-\(UUID().uuidString).png")
            #expect(Bool(false), "Should have thrown")
        } catch {
            // Any error is expected
        }
    }

    // MARK: ImageDownloadService - Cache

    @Test("ImageDownloadService: uses cache on second call")
    func imageDownloadUsesCache() async throws {
        let imageData = make1x1ImageData()
        let callCount = LockedCounter()

        let session = makeMockSession { request in
            callCount.increment()
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, imageData)
        }
        let service = ImageDownloadService(session: session)
        let urlString = "https://example.com/cached-\(UUID().uuidString).png"

        let image1 = try await service.downloadImage(from: urlString)
        #expect(image1.size.width > 0)
        #expect(callCount.value == 1)

        let image2 = try await service.downloadImage(from: urlString)
        #expect(image2.size.width > 0)
        #expect(callCount.value == 1, "Second call should use cache")
    }
}
