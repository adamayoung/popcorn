//
//  ViewStateTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

@testable import TCAFoundation
import Testing

@Suite("ViewState")
struct ViewStateTests {

    @Test("isInitial returns true only for initial state")
    func isInitial() {
        let initial: ViewState<String> = .initial
        let loading: ViewState<String> = .loading
        let ready: ViewState<String> = .ready("content")
        let error: ViewState<String> = .error(ViewStateError(message: "error"))

        #expect(initial.isInitial == true)
        #expect(loading.isInitial == false)
        #expect(ready.isInitial == false)
        #expect(error.isInitial == false)
    }

    @Test("isLoading returns true only for loading state")
    func isLoading() {
        let initial: ViewState<String> = .initial
        let loading: ViewState<String> = .loading
        let ready: ViewState<String> = .ready("content")
        let error: ViewState<String> = .error(ViewStateError(message: "error"))

        #expect(initial.isLoading == false)
        #expect(loading.isLoading == true)
        #expect(ready.isLoading == false)
        #expect(error.isLoading == false)
    }

    @Test("isReady returns true only for ready state")
    func isReady() {
        let initial: ViewState<String> = .initial
        let loading: ViewState<String> = .loading
        let ready: ViewState<String> = .ready("content")
        let error: ViewState<String> = .error(ViewStateError(message: "error"))

        #expect(initial.isReady == false)
        #expect(loading.isReady == false)
        #expect(ready.isReady == true)
        #expect(error.isReady == false)
    }

    @Test("isError returns true only for error state")
    func isError() {
        let initial: ViewState<String> = .initial
        let loading: ViewState<String> = .loading
        let ready: ViewState<String> = .ready("content")
        let error: ViewState<String> = .error(ViewStateError(message: "error"))

        #expect(initial.isError == false)
        #expect(loading.isError == false)
        #expect(ready.isError == false)
        #expect(error.isError == true)
    }

    @Test("content returns value only for ready state")
    func content() {
        let initial: ViewState<String> = .initial
        let loading: ViewState<String> = .loading
        let ready: ViewState<String> = .ready("content")
        let error: ViewState<String> = .error(ViewStateError(message: "error"))

        #expect(initial.content == nil)
        #expect(loading.content == nil)
        #expect(ready.content == "content")
        #expect(error.content == nil)
    }

    @Test("error returns value only for error state")
    func error() {
        let viewStateError = ViewStateError(message: "error")
        let initial: ViewState<String> = .initial
        let loading: ViewState<String> = .loading
        let ready: ViewState<String> = .ready("content")
        let error: ViewState<String> = .error(viewStateError)

        #expect(initial.error == nil)
        #expect(loading.error == nil)
        #expect(ready.error == nil)
        #expect(error.error == viewStateError)
    }

}

@Suite("ViewStateError")
struct ViewStateErrorTests {

    @Test("initializes with message")
    func initWithMessage() {
        let error = ViewStateError(message: "Something went wrong")

        #expect(error.message == "Something went wrong")
        #expect(error.underlyingError == nil)
        #expect(error.isRetryable == true)
    }

    @Test("initializes with all parameters")
    func initWithAllParameters() {
        let error = ViewStateError(
            message: "Something went wrong",
            underlyingError: "NetworkError",
            isRetryable: false
        )

        #expect(error.message == "Something went wrong")
        #expect(error.underlyingError == "NetworkError")
        #expect(error.isRetryable == false)
    }

}
