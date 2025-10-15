//
//  TodoManager.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/14/25.
//

import UIKit

/// Swift 6.2 + Default Actor Isolation 설정이 Main Actor일 때
/// - @MainActor 어노테이션을 붙이지 않아도 모든 타입이 @MainActor로 격리됨
///
/// 단, UITableViewDiffableDataSource와 같이 사용 시 오류가 발생할 수 있음
/// 1. 사용자가 만든 객체는 자동으로 @MainActor로 격리됨
/// 2. UITableViewDiffableDataSource 사용으로 인한 Hashable, Senable 준수 시,
/// - Hashable은 MainActor에 격리되서 준수됨 (MainActor - isolated)
/// 3. 단 Sendable 준수 시에는 어느 Actor에도 격리되지 않아야 함
///
/// 빌드 설정에서 메인스레드에서의 보장을 없앨 수 있음

@globalActor
actor TodoManager {
    
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
    
    func addTodo(_ title: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sectionDate = dateFormatter.string(from: .now)
        
        let isFirst = self.todoSections.isEmpty
        
        let todo = Todo(
            id: isFirst ? 1 : ((self.todoSections.last?.todos.last?.id) ?? 1 + 1),
            createDate: .now,
            title: title,
            isCompleted: false
        )
        
        if self.todoSections.first?.title == sectionDate {
            self.todoSections[0].todos.insert(todo, at: 0)
        } else {
            self.todoSections.insert(.init(title: sectionDate, todos: [todo]), at: 0)
        }
    }
    
    func toggleCompletion(_ indexPath: IndexPath) {
        self.todoSections[indexPath.section].todos[indexPath.item].isCompleted.toggle()
        
        self.todoSections[indexPath.section].todos =  self.todoSections[indexPath.section].todos.sorted {
            !$0.isCompleted && $1.isCompleted
        }
    }
}
