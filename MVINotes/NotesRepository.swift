//
//  NotesRepository.swift
//  MVINotes
//
//  Created by Seng Phrakonkham on 2026. 02. 14..
//
import Foundation
import CoreData

protocol NotesRepositoryProtocol {
    func fetchAll() throws -> [NoteItemDTO]
    func addItem(item: NoteItemDTO) throws
    func deleteItem(id: UUID) throws
    func setFavorite(id: UUID, isFavorite: Bool) throws
}

final class NotesRepository: NotesRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchAll() throws -> [NoteItemDTO] {
        let req = NoteItem.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        let result = try context.fetch(req)
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

    func addItem(item: NoteItemDTO) throws {
        let entity = NoteItem(context: context)
        entity.id = item.id
        entity.title = item.title
        entity.summary = item.summary
        entity.date = item.date
        entity.note = item.details
        
        try context.save()
    }

    func deleteItem(id: UUID) throws {
        let req = NoteItem.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        req.fetchLimit = 1
        
        if let entity = try context.fetch(req).first {
            context.delete(entity)
            try context.save()
        }
    }
    
    func setFavorite(id: UUID, isFavorite: Bool) throws {
        let req = NoteItem.fetchRequest()
        req.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        req.fetchLimit = 1
        
        if let entity = try context.fetch(req).first {
            entity.category = NotesCategory.favoriteCategoryAsString(isFavoirte: isFavorite)
            try context.save()
        }
    }
}
