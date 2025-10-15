//
//  HomeVCTableViewCell.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/14/25.
//

import UIKit
import Then
import SnapKit

class HomeVCTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellId = "HomeVCTableViewCell"
    
    private lazy var checkBtn = UIButton().then {
        $0.imageView?.contentMode = .scaleAspectFit
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        $0.addTarget(self, action: #selector(checkBtnTapped), for: .touchUpInside)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 15, weight: .light)
    }
    
    private var checkBtnTappedAction: (() -> Void)?
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.attribute()
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.attributedText = nil
    }
}

extension HomeVCTableViewCell {
    
    // MARK: - Methods
    
    private func attribute() {
        self.selectionStyle = .none
        self.backgroundColor = .systemBackground
    }
    
    private func layout() {
        [self.titleLabel, self.checkBtn].forEach {
            self.contentView.addSubview($0)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(self.checkBtn.snp.leading).offset(8)
        }
        
        self.checkBtn.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.size.equalTo(25)
        }
    }
    
    func configure(title: String, isComplated: Bool, checkBtnAction: @escaping () -> Void) {
        let attributeString = NSMutableAttributedString(string: title)
        
        attributeString.addAttribute(
            isComplated ? .strikethroughStyle : .textHighlightStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSMakeRange(0, attributeString.length)
        )
        
        self.titleLabel.attributedText = attributeString
        self.checkBtn.isSelected = isComplated
        self.checkBtnTappedAction = checkBtnAction
    }
    
    @objc
    private func checkBtnTapped() {
        self.checkBtnTappedAction?()
    }
}

