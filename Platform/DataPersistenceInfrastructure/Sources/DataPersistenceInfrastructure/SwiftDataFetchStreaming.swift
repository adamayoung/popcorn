//
//  SwiftDataFetchStreaming.swift
//  DataPersistenceInfrastructure
//
//  Created by Adam Young on 02/12/2025.
//

import CoreData
import Foundation
import SwiftData

public protocol SwiftDataFetchStreaming: ModelActor {

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
