//
//  NotesRepository.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 14..
//
import Foundation
import CoreData

protocol NotesRepositoryProtocol {
    func fetchAll() async throws -> [NoteItemDTO]
    func addItem(item: NoteItemDTO) async throws
    func updateItem(item: NoteItemDTO) async throws
    func deleteItem(id: UUID) async throws
    func setFavorite(id: UUID, isFavorite: Bool) async throws
}

actor NotesRepository: NotesRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll() async throws -> [NoteItemDTO] {
        try await context.perform {
            let req = NoteItem.fetchRequest()
            req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            
            let result = try self.context.fetch(req)
            return result.compactMap { entity in
                guard let id = entity.id else {
                    return nil
                }
                let title = entity.title ?? ""
                let summary = entity.summary ?? ""
                let date = entity.date ?? Date()
                let category: NotesCategory = NotesCategory.category(from: entity.category)
                let details = entity.note ?? ""
                
                return NoteItemDTO(
                    id: id,
                    title: title,
                    summary: summary,
                    date: date,
                    category: category,
                    details: details
                )
            }
        }
    }

    func addItem(item: NoteItemDTO) async throws {
        try await context.perform {
            let entity = NoteItem(context: self.context)
            entity.id = item.id
            entity.title = item.title
            entity.summary = item.summary
            entity.category = NotesCategory.favoriteCategoryAsString(isFavoirte: item.category == .favorites)
            entity.date = item.date
            entity.note = item.details
            
            try self.context.save()
        }
    }

    func updateItem(item: NoteItemDTO) async throws {
        try await context.perform {
            let req = NoteItem.fetchRequest()
            req.predicate = NSPredicate(format: "id == %@", item.id as CVarArg)
            req.fetchLimit = 1
            
            if let entity = try self.context.fetch(req).first {
                entity.title = item.title
                entity.summary = item.summary
                entity.date = item.date
                entity.category = item.category.rawValue
                entity.note = item.details
                
                try self.context.save()
            }
        }
    }

    func deleteItem(id: UUID) async throws {
        try await context.perform {
            let req = NoteItem.fetchRequest()
            req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            req.fetchLimit = 1
            
            if let entity = try self.context.fetch(req).first {
                self.context.delete(entity)
                try self.context.save()
            }
        }
    }
    
    func setFavorite(id: UUID, isFavorite: Bool) async throws {
        try await context.perform {
            let req = NoteItem.fetchRequest()
            req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
            req.fetchLimit = 1
            
            if let entity = try self.context.fetch(req).first {
                entity.category = NotesCategory.favoriteCategoryAsString(isFavoirte: isFavorite)
                try self.context.save()
            }
        }
    }
}
