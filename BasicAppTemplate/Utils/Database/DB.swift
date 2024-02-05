//
//  DB.swift
//  BasicAppTemplate
//
//  Created by Kaloyan Petkov on 10.12.23.
//

import Foundation
import RealmSwift

struct DB {
    
    static var shared = DB()
    private init() {}
    
    var realm = try? Realm()
    
    func save<T: Object> (_ object: Object, shouldBeOnlyOneOfType: T.Type? = nil) {
        do {
            if shouldBeOnlyOneOfType != nil {
                try realm?.write {
                    let existingObjects = realm?.objects(T.self)
                    
                    if let existingObjects {
                        for object in existingObjects {
                            realm?.delete(object)
                        }
                    }
                    
                    realm?.add(object, update: .modified)
                }
            } else {
                try realm?.write {
                    realm?.add(object, update: .modified)
                }
            }
        } catch {
            print("FAILED SAVING MODEL TO REALM DB! \(error)")
        }
    }
    
    func fetch<T: Object>() -> Results<T>? {
        return realm?.objects(T.self)
    }
    
    @MainActor func update(code callback: () -> Void) {
        do {
            try realm?.write {
                callback()
            }
        } catch {
            print("FAILED UPDATING OBJECT IN REALM DB")
        }
    }
    
    @MainActor func delete(_ object: Object) throws {
        do {
            try realm?.write {
                realm?.delete(object)
            }
        } catch {
            throw error
        }
    }
    
    func deleteAll<T: Object>(ofType: T) {
        let results: Results<T>? = self.fetch()
        guard let results else {
            return
        }
        
        for result in results {
            realm?.delete(result)
        }
    }
    
    
}
