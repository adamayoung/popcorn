//
//  SwiftDataFetchStreaming.swift
//  DataPersistenceInfrastructure
//
//  Copyright © 2025 Adam Young.
//

import CoreData
import Foundation
import SwiftData

///
/// A protocol for streaming SwiftData fetch results as they change.
///
/// Conforming actors can observe changes to persistent models and emit updates
/// through an async stream. The stream automatically updates when the model
/// context saves or CloudKit sync events occur.
///
public protocol SwiftDataFetchStreaming: ModelActor {

    ///
    /// Creates an async stream that emits transformed fetch results.
    ///
    /// The stream emits an initial snapshot immediately, then updates whenever
    /// the model context saves or CloudKit sync events occur.
    ///
    /// - Parameters:
    ///   - descriptor: The fetch descriptor defining the query criteria.
    ///   - map: A closure that transforms the fetched entities into the output type.
    /// - Returns: An async throwing stream that emits transformed results.
    ///
    func stream<Entity: PersistentModel, Output: Equatable & Sendable>(
        for descriptor: FetchDescriptor<Entity>,
        map: @escaping @Sendable ([Entity]) -> Output
    ) -> AsyncThrowingStream<Output, Error>

}

extension SwiftDataFetchStreaming {

    public func stream<Entity: PersistentModel, Output: Equatable & Sendable>(
        for descriptor: FetchDescriptor<Entity>,
        map: @escaping @Sendable ([Entity]) -> Output
    ) -> AsyncThrowingStream<Output, Error> {
        AsyncThrowingStream { continuation in
            let task = Task { [actorSelf = self] in
                await actorSelf.runStream(
                    descriptor: descriptor,
                    notificationName: ModelContext.didSave,
                    map: map,
                    continuation: continuation
                )
            }
            let taskCK = Task { [actorSelf = self] in
                await actorSelf.runStreamCK(
                    descriptor: descriptor,
                    map: map,
                    continuation: continuation
                )
            }

            continuation.onTermination = { @Sendable _ in
                task.cancel()
                taskCK.cancel()
            }
        }
    }

    private func runStream<Entity: PersistentModel, Output: Equatable & Sendable>(
        descriptor: FetchDescriptor<Entity>,
        notificationName: Notification.Name,
        map: @escaping @Sendable ([Entity]) -> Output,
        continuation: AsyncThrowingStream<Output, Error>.Continuation
    ) async {
        func yieldSnapshot() {
            do {
                let entities = try modelContext.fetch(descriptor)
                let value = map(entities)
                continuation.yield(value)
            } catch {
                continuation.finish(throwing: error)
            }
        }

        yieldSnapshot()

        let notifications = NotificationCenter.default.notifications(
            named: ModelContext.didSave
        )

        for await _ in notifications {
            if Task.isCancelled { break }

            yieldSnapshot()
        }

        if !Task.isCancelled {
            continuation.finish()
        }
    }

    private func runStreamCK<Entity: PersistentModel, Output: Equatable & Sendable>(
        descriptor: FetchDescriptor<Entity>,
        map: @escaping @Sendable ([Entity]) -> Output,
        continuation: AsyncThrowingStream<Output, Error>.Continuation
    ) async {
        func yieldSnapshot() {
            do {
                let entities = try modelContext.fetch(descriptor)
                let value = map(entities)
                continuation.yield(value)
            } catch {
                continuation.finish(throwing: error)
            }
        }

        yieldSnapshot()

        let notifications = NotificationCenter.default.notifications(
            named: NSPersistentCloudKitContainer.eventChangedNotification
        )

        for await _ in notifications {
            if Task.isCancelled { break }

            yieldSnapshot()
        }

        if !Task.isCancelled {
            continuation.finish()
        }
    }

}
