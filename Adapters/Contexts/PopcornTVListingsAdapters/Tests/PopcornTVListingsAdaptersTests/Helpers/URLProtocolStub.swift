//
//  URLProtocolStub.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// URLProtocol stub for intercepting URLSession requests in tests.
///
/// Install per-test via `URLProtocolStub.setHandler(...)` on a session configured with
/// `URLProtocolStub.self` in its `protocolClasses`.
///
class URLProtocolStub: URLProtocol {

    private nonisolated(unsafe) static var handler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data?))?
    private static let handlerLock = NSLock()

    static func setHandler(_ handler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data?))?) {
        handlerLock.withLock { self.handler = handler }
    }

    static func session() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        return URLSession(configuration: config)
    }

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        let handler = Self.handlerLock.withLock { Self.handler }
        guard let handler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badServerResponse))
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch let error {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}

}
