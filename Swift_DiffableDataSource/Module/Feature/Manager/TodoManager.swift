//
//  TodoManager.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/14/25.
//

import Foundation

class TodoManager {
    
    // MARK: - Properties
    
    static let shared = TodoManager()
    private var todoSections: [TodoSection] = [] {
        didSet {
            let encoder  = PropertyListEncoder()
            let data = try? encoder.encode(self.todoSections)
            UserDefaults.standard.set(data, forKey: self.userDefaultsKey)
        }
    }
    
    private let userDefaultsKey: String = "TodoSections"
    
    // MARK: - LifeCycle
    
    private init() {}
    
    // MARK: - Methods
    
    func loadTodos() {
        guard let data = UserDefaults.standard.data(forKey: self.userDefaultsKey),
              let decoded = try? PropertyListDecoder().decode([TodoSection].self, from: data)
        else {return}
        
        self.todoSections = decoded
    }
    
    func getTodoSections() -> [TodoSection] {
        return self.todoSections
    }
    
    func addTodo(_ todo: Todo) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sectionDate = dateFormatter.string(from: .now)
        
        if self.todoSections.first?.title == sectionDate {
            self.todoSections[0].todos.append(todo)
        } else {
            self.todoSections.insert(.init(title: sectionDate, todos: [todo]), at: 0)
        }
    }
}
