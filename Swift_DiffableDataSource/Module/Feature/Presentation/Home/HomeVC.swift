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
    
    ///
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
