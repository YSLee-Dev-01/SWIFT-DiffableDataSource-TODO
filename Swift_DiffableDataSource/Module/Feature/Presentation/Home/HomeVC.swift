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
        $0.backgroundColor = .white
        $0.contentInset.bottom = 50
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.attribute()
        self.setupToolbar()
        self.layout()
    }
}

private extension HomeVC {
    
    // MARK: - Methods
    
    func attribute() {
        self.view.backgroundColor = .white
        
        self.navigationItem.title = "TODO"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func setupToolbar() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        self.toolbarItems = [.flexibleSpace(), addButton]
    }
    
    func layout() {
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc
    func addButtonTapped() {
        
    }
}
