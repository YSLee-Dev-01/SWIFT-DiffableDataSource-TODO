//
//  HomeViewModel.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/13/25.
//

import Foundation

@Observable
class HomeViewModel {
    
    // MARK: - Properties
    
    var sections: [TodoSection] = []
    
    // MARK: - Methods
    
    func reloadData() {
        self.sections = TodoManager.shared.getTodoSections()
    }
}
