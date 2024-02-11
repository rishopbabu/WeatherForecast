//
//  RealmManager.swift
//  WeatherForcast
//
//  Created by Rishop Babu on 11/02/24.
//

import Foundation
import RealmSwift


class RealmManager {
    
    static let shared = RealmManager()
    
    private init() {}
    
    func configureRealm() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previous version.
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with a schema version
            // lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // If you haven't set up any migration code yet, just set the new properties directly.
                    // For example, in this case, you can set the location property directly.
                    migration.enumerateObjects(ofType: WeatherRealmModel.className()) { oldObject, newObject in
                        // Set location property to a new empty LocationRealmModel object
                        newObject?["location"] = LocationRealmModel()
                    }
                }
            }
        )
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}
