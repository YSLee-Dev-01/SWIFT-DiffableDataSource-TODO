//
//  HomeVC.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/13/25.
//

import UIKit
import Then
import SnapKit

class HomeVC: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView().then {
        $0.contentInset.bottom = 50
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "TODO가 등록되지 않았어요.\n+버튼을 눌러 추가해주세요."
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    private let viewModel = HomeViewModel()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.attribute()
        self.setupToolbar()
        self.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.reloadData()
    }
    
    /// 기존 layoutSubviews()의 문제점을 개선하기 위해 추가된 메서드
    /// - layoutSubviews()는 속성 업데이트와 레이아웃 처리를 동시에 하던 구조로
    ///   속성 하나만 변경되어도 전체 레이아웃을 다시 계산하는 경우가 발생함
    ///
    /// 레이아웃 처리가 아닌 속성 업데이트만 처리하는 메서드
    /// -> 속성만 업데이트 하는 기능이 분리되어 레이아웃을 재계산하는 불필요한 과정 제거
    /// - updateProperties()는 layoutSubviews() 직전에 실행됨
    /// - iOS26이상 부터 사용 가능
    ///
    /// - UIKit에서 @Observable를 사용할 때 이용하게 됨
    override func updateProperties() {
        super.updateProperties()
        
        self.emptyLabel.isHidden = !self.viewModel.sections.isEmpty
    }
}

private extension HomeVC {
    
    // MARK: - Methods
    
    func attribute() {
        self.navigationItem.title = "TODO"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func setupToolbar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBtnTapped))
        self.toolbarItems = [.flexibleSpace(), addButton]
    }
    
    func layout() {
        [self.tableView, self.emptyLabel]
            .forEach {
                self.view.addSubview($0)
            }
        
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc
    func addBtnTapped() {
        let navigationViewController = UINavigationController(rootViewController: AddVC())
        self.present(navigationViewController, animated: true)
    }
}
