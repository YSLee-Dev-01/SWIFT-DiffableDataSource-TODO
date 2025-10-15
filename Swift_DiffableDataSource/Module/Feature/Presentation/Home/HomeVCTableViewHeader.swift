//
//  HomeVCTableViewHeader.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/15/25.
//

import UIKit
import Then
import SnapKit

class HomeVCTableViewHeader: UIView {
    
    // MARK: - Properties
    
    private let dateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .secondaryLabel
        $0.backgroundColor = .systemBackground
    }
    
    private let border = UIView().then {
        $0.backgroundColor = UIColor.systemGray4
    }
    
    // MARK: - LifeCycle
    
    init() {
        super.init(frame: .zero)
        
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeVCTableViewHeader {
    
    // MARK: - Methods
    
    private func layout() {
        [self.border, self.dateLabel]
            .forEach {
                self.addSubview($0)
            }
        
        self.border.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(1)
            $0.width.equalTo(200)
        }
        
        self.dateLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(title: String) {
        self.dateLabel.text = title
    }
}
