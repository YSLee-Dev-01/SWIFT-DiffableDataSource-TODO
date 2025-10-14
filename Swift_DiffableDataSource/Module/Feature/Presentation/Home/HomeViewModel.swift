//
//  HomeViewModel.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/13/25.
//

import Foundation

/// UIKit에서도 @Observable 매크로를 사용할 수 있음
/// - @Observable로 ViewModel을 선언하면 UIKit 내부에서 의존성을 추적해서 값이 바뀔 때마다 뷰를 무효화하고 재 갱신함
/// -> setNeedsLayout()를 수동으로 호출하지 않아도 됨
@Observable
class HomeViewModel {
    
    // MARK: - Properties
    
    var sections: [TodoSection] = []
    
    // MARK: - Methods
    
    func reloadData() async {
        self.sections = await TodoManager.shared.getTodoSections()
    }
}
