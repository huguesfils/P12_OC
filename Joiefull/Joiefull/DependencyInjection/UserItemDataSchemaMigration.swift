import SwiftData

// MARK: Schema version
enum UserItemDataSchema: VersionedSchema {
    static var versionIdentifier: Schema.Version = Schema.Version(1,0,0)
    
    static var models: [any PersistentModel.Type] {
        [UserItemData.self]
    }
}

// MARK: Migration plan
enum UserItemDataMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [UserItemDataSchema.self]
    }
    
    static var stages: [MigrationStage] {
        []
    }
}
