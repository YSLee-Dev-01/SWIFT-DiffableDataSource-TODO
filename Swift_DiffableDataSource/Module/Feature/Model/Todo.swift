//
//  Todo.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/13/25.
//

import Foundation

struct Todo: Hashable {
    let id: UUID
    let createDate: Date
    var title: String
    var isCompleted: Bool
}
