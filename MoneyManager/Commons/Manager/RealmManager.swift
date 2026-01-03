//
//  RealmManager.swift
//  MoneyManager
//
//  Created by VanTuan8802 on 3/1/26.
//


import RealmSwift
import Foundation

/// RealmManager
public class RealmManager: @unchecked Sendable {

    private enum RealmVersion: UInt64 {
        case v1 = 1
        case v2 = 2
        case v3 = 3
    }

    /// Share instant
    public static let shared = RealmManager()
    internal let realmQueue = DispatchQueue(label: "realm.background_\(Date().timeIntervalSince1970)")

    private init() {
        configureRealm()
    }

    private func configureRealm() {
        let currentVersion: RealmVersion = .v2

        let config = Realm.Configuration(
            schemaVersion: currentVersion.rawValue,
            migrationBlock: { migration, oldSchemaVersion in
                // Migration code removed - no models available
                if oldSchemaVersion < RealmVersion.v3.rawValue {
                    // Migration v2 -> v3
                }
            }
        )

        Realm.Configuration.defaultConfiguration = config
        print("✅ Realm configured at: \(String(describing: config.fileURL))")
    }
}

// MARK: - Queue handler
extension RealmManager {
    internal func withRealmContinuation<T>(
        execute: @escaping (Realm) throws -> T
    ) async throws -> T {
        // Unsafe: bypass @Sendable check
        let unsafeExecute = unsafeBitCast(execute, to: (@Sendable (Realm) throws -> T).self)

        return try await withCheckedThrowingContinuation { continuation in
            realmQueue.async {
                do {
                    let realm = try self.realmInstance()
                    let result = try unsafeExecute(realm)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

// MARK: - Instance
extension RealmManager {
    internal func realmInstance() throws -> Realm {
        return try Realm()
    }
}

// MARK: - Add
extension RealmManager {
    /// :nodoc:
    public func addOrUpdate<T: Object & Sendable>(_ object: T) async throws {
        try await withRealmContinuation { realm in
            try realm.write {
                realm.add(object, update: .modified)
            }
        }
    }

    /// :nodoc:
    @discardableResult
    public func addOrUpdateAndReturn<T: Object & Sendable>(_ object: T) async throws -> T {
        try await withRealmContinuation { realm in
            try realm.write {
                realm.add(object, update: .modified)
            }
            return object
        }
    }

    /// :nodoc:
    public func addElementToList<T: Object, U: Object>(
        to objectType: T.Type,
        primaryKey: Any,
        keyPath: ReferenceWritableKeyPath<T, List<U>>,
        child: U
    ) async throws {
        try await withRealmContinuation { realm in
            // Find the parent object by primary key
            guard let object = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else {
                throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Parent object not found"])
            }

            try realm.write {
                // Add child object to the list
                object[keyPath: keyPath].append(child)
            }
        }
    }
}

// MARK: - Get
extension RealmManager {
    /// :nodoc:
    public func findByPKId<T: Object, K: Any>(_ id: K, type: T.Type) async throws -> T? {
        return try await withRealmContinuation { realm in
            let result = realm.object(ofType: T.self, forPrimaryKey: id)
            return result
        }
    }

    /// :nodoc:
    public func getAll<T: Object>(_ type: T.Type) async throws -> [T] {
        return try await withRealmContinuation { realm in
            return Array(realm.objects(type))
        }
    }

    @available(*, deprecated, message: "Used the getAllV2 instead.")
    /// :nodoc:
    public func getAll<T: Object>(
        _ type: T.Type,
        predicate: NSPredicate? = nil,
        sortedBy sortKeyPath: String? = nil,
        ascending: Bool = true) async throws -> [T] {
            return try await withRealmContinuation { realm in
                var results = realm.objects(T.self)

                if let predicate = predicate {
                    results = results.filter(predicate)
                }

                if let keyPath = sortKeyPath {
                    results = results.sorted(byKeyPath: keyPath, ascending: ascending)
                }

                return Array(results)
            }
        }

    /// :nodoc:
    public func getAllV2<T: Object>(_ type: T.Type) async throws -> [T] {
        return try await withRealmContinuation { realm in
            return Array(realm.objects(T.self))
        }
    }

    /// :nodoc:
    public func getAllV2<T: Object>(
        _ type: T.Type,
        where filter: @escaping ((Query<T>) -> Query<Bool>)) async throws -> [T] {
        return try await withRealmContinuation { realm in
            let results = realm.objects(T.self).where(filter)
            return Array(results)
        }
    }

    /// :nodoc:
    public func getOne<T: Object>(_ type: T.Type) async throws -> T? {
        try await withRealmContinuation { realm in
            return realm.objects(type).first
        }
    }

    @available(*, deprecated, message: "Used the getOneV2 instead.")
    /// :nodoc:
    public func getOne<T: Object>(
        _ type: T.Type,
        predicate: NSPredicate? = nil,
        sortedBy sortKeyPath: String? = nil,
        ascending: Bool = true
    ) async throws -> T? {
        return try await withRealmContinuation { realm in
            var results = realm.objects(T.self)

            if let predicate = predicate {
                results = results.filter(predicate)
            }

            if let keyPath = sortKeyPath {
                results = results.sorted(byKeyPath: keyPath, ascending: ascending)
            }

            return results.first
        }
    }

    /// :nodoc:
    public func getOneV2<T: Object>(
        _ type: T.Type,
        where filter: @escaping ((Query<T>) -> Query<Bool>)) async throws -> T? {
        return try await withRealmContinuation { realm in
            let results = realm.objects(T.self).where(filter)
            return results.first
        }
    }
}

// MARK: - Add Or Update
extension RealmManager {
    /// :nodoc:
    public func update<T: Object>(_ object: T, with updates: @escaping (T) -> Void) async throws {
        try await withRealmContinuation { realm in
            try realm.write {
                updates(object) // Apply updates to the object
            }
        }
    }

    /// :nodoc:
    public func updateOrAddElementToList<T: Object, U: Object & Identifiable>(
        for objectType: T.Type,
        primaryKey: Any,
        keyPath: ReferenceWritableKeyPath<T, List<U>>,
        newList: [U],
        idKeyPath: KeyPath<U, UUID>
    ) async throws {
        try await withRealmContinuation { realm in
            guard let object = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else {
                throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Object not found"])
            }
            try realm.write {
                let existingItems = Dictionary(uniqueKeysWithValues: object[keyPath: keyPath].map { ($0[keyPath: idKeyPath], $0) })

                for newItem in newList {
                    if existingItems[newItem[keyPath: idKeyPath]] != nil {
                        // Update existing object
                        realm.create(U.self, value: newItem, update: .modified)
                    } else {
                        // Add new object
                        object[keyPath: keyPath].append(newItem)
                    }
                }
            }
        }
    }

    /// :nodoc:
    public func updateChild<T: Object, V>(
        for objectType: T.Type,
        primaryKey: Any,
        keyPath: ReferenceWritableKeyPath<T, V>,
        newValue: V
    ) async throws {

        try await withRealmContinuation { realm in

            guard let object = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else {
                throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Object not found"])
            }

            try realm.write {
                object[keyPath: keyPath] = newValue
            }
        }
    }

    /// :nodoc:
    public func updateChildInList<T: Object, U: Object, V>(
        for objectType: T.Type,
        primaryKey: Any,
        listKeyPath: ReferenceWritableKeyPath<T, List<U>>,
        childID: UUID,
        idKeyPath: KeyPath<U, UUID>,
        childKeyPath: ReferenceWritableKeyPath<U, V>,
        newValue: V
    ) async throws {
        try await withRealmContinuation { realm in

            guard let object = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else {
                throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Parent object not found"])
            }

            guard let childObject = object[keyPath: listKeyPath].first(where: { $0[keyPath: idKeyPath] == childID }) else {
                throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Child object not found"])
            }

            try realm.write {
                childObject[keyPath: childKeyPath] = newValue
            }
        }
    }

    /// :nodoc:
    public func updateElementInList<T: Object, U: Object>(
        for objectType: T.Type,
        primaryKey: Any,
        listKeyPath: ReferenceWritableKeyPath<T, List<U>>,
        childID: UUID,
        idKeyPath: KeyPath<U, UUID>,
        updateBlock: @escaping (U) -> Void
    ) async throws {
        try await withRealmContinuation { realm in
            guard let object = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else {
                throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Parent object not found"])
            }

            try realm.write {
                let list = object[keyPath: listKeyPath]

                guard let index = list.firstIndex(where: { $0[keyPath: idKeyPath] == childID }) else {
                    throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Child object not found"])
                }

                let oldObject = list[index]
                updateBlock(oldObject)
            }
        }
    }

    /// :nodoc:
    public func overideChildList<T: Object, U: Object & Identifiable>(
        for objectType: T.Type,
        primaryKey: Any,
        keyPath: ReferenceWritableKeyPath<T, List<U>>,
        newList: [U]
    ) async throws {
        try await withRealmContinuation { realm in

            guard let object = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else {
                throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Object not found"])
            }

            try realm.write {
                // Remove and delete all existing child objects
                let existingChildren = object[keyPath: keyPath]
                realm.delete(existingChildren)
                object[keyPath: keyPath].removeAll()

                // Add new objects to the list
                object[keyPath: keyPath].append(objectsIn: newList)
            }
        }
    }
}

// MARK: - Delete
extension RealmManager {
    /// :nodoc:
    public func delete<T: Object>(_ object: T) async throws {
        try await withRealmContinuation { realm in
            try realm.write {
                realm.delete(object) // Delete the object
            }
        }
    }

    /// :nodoc:
    public func deleteById<T: Object, K: Any>(
        _ id: K,
        type: T.Type) async throws {
            try await withRealmContinuation { realm in
                if let object = realm.object(ofType: T.self, forPrimaryKey: id) {
                    try realm.write {
                        realm.delete(object)
                    }
                }
            }
        }

    /// :nodoc:
    public func deleteById<T: Object, K: Any, U: Object, V: Object>(
        _ id: K,
        type: T.Type,
        firstKeyPath: KeyPath<T, List<U>>,
        secondKeyPath: KeyPath<T, List<V>>,
        firstCleanup: ((Realm, U) -> Void)? = nil,
        secondCleanup: ((Realm, V) -> Void)? = nil
    ) async throws {
        try await withRealmContinuation { realm in
            if let object = realm.object(ofType: T.self, forPrimaryKey: id) {
                try realm.write {
                    let firstObjects = object[keyPath: firstKeyPath]
                    firstObjects.forEach { firstCleanup?(realm, $0) }
                    realm.delete(firstObjects)

                    let secondObjects = object[keyPath: secondKeyPath]
                    secondObjects.forEach { secondCleanup?(realm, $0) }
                    realm.delete(secondObjects)

                    realm.delete(object)
                }
            }
        }
    }

    /// :nodoc:
    public func deleteById<T: Object, K: Any, U: Object>(
        _ id: K,
        type: T.Type,
        firstKeyPath: KeyPath<T, List<U>>,
        firstCleanup: ((Realm, U) -> Void)? = nil
    ) async throws {
        try await withRealmContinuation { realm in
            if let object = realm.object(ofType: T.self, forPrimaryKey: id) {
                try realm.write {
                    let firstObjects = object[keyPath: firstKeyPath]
                    firstObjects.forEach { firstCleanup?(realm, $0) }
                    realm.delete(firstObjects)

                    realm.delete(object)
                }
            }
        }
    }

    /// :nodoc:
    public func deleteElementInList<T: Object, U: Object, K: Equatable>(
        from objectType: T.Type,
        primaryKey: Any,
        keyPath: ReferenceWritableKeyPath<T, List<U>>,
        elementPrimaryKey: K
    ) async throws where U: Object {
        try await withRealmContinuation { realm in
            // Find the parent object by primary key
            guard let object = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else {
                throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Parent object not found"])
            }

            try realm.write {
                let list = object[keyPath: keyPath]

                // Find the index of the element to delete
                if let index = list.firstIndex(where: { ($0.value(forKey: "id") as? K) == elementPrimaryKey }) {
                    let elementToDelete = list[index]

                    // 🔹 Remove from list first
                    list.remove(at: index)

                    // 🔹 Delete from Realm after removing from the list
                    realm.delete(elementToDelete)
                } else {
                    throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Element not found in the list"])
                }
            }
        }
    }

    /// :nodoc:
    public func delete<T: Object>(
        _ type: T.Type,
        where filter: @escaping ((Query<T>) -> Query<Bool>)
    ) async throws {
        try await withRealmContinuation { realm in
            let results = realm.objects(T.self).where(filter)

            try realm.write {
                realm.delete(results)
            }
        }
    }

    /// :nodoc:
    public func clearAllRealm() throws {
        let realm = try realmInstance()

        try realm.write {
            realm.deleteAll()
        }
    }
}

// MARK: - Calculate
extension RealmManager {

    /// :nodoc:
    public func additionChild<T: Object>(
        for objectType: T.Type,
        primaryKey: Any,
        keyPath: ReferenceWritableKeyPath<T, Double>,
        addValue: Double
    ) async throws {
        try await withRealmContinuation { realm in

            guard let object = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else {
                throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Object not found"])
            }

            try realm.write {
                object[keyPath: keyPath] += addValue
            }
        }
    }

    /// :nodoc:
    public func subtractionChild<T: Object>(
        for objectType: T.Type,
        primaryKey: Any,
        keyPath: ReferenceWritableKeyPath<T, Double>,
        subtractValue: Double
    ) async throws {
        try await withRealmContinuation { realm in

            guard let object = realm.object(ofType: objectType, forPrimaryKey: primaryKey) else {
                throw NSError(domain: "RealmManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Object not found"])
            }

            try realm.write {
                object[keyPath: keyPath] -= subtractValue
            }
        }
    }
}