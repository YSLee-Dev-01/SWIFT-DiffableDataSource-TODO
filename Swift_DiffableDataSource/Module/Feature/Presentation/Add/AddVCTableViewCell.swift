//
//  AddVCTableViewCell.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/14/25.
//

import UIKit
import Then
import SnapKit

class AddVCTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellId = "AddVCTableViewCell"
    
    private let checkIcon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(systemName: "checkmark.circle")
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.attribute()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddVCTableViewCell {
    
    // MARK: - Methods
    
    private func attribute() {
        self.selectionStyle = .none
    }
    
    private func layout() {
        [self.checkIcon, self.titleLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        self.checkIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.size.equalTo(25)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(self.checkIcon.snp.trailing).offset(8)
            $0.trailing.equalTo(self.contentView)
        }
    }
    
    func configure(title: String) {
        self.titleLabel.text = title
    }
}
