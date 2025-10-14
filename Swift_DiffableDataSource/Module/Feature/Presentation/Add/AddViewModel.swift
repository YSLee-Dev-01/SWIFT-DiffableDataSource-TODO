//
//  AddViewModel.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/14/25.
//

import Foundation

@Observable
class AddViewModel {
    
    // MARK: - Properties
    
    let recommendTitles: [String] = [
        "물 2L 마시기",
        "30분 산책하기",
        "책 30분 읽기",
        "스트레칭 10분",
        "비타민 챙겨먹기",
        "일기 쓰기",
        "방 정리하기",
        "운동 1시간",
        "명상 10분",
        "30분 공부하기"
    ]
    
    // MARK: - Methods
    
    func addTodo(_ title: String) {
        if title.isEmpty {return}
        Task {
            await TodoManager.shared.addTodo(title)
        }
    }
}
