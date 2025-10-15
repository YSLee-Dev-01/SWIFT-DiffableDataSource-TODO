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
    
    private lazy var tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.contentInset.bottom = 50
        $0.separatorStyle = .none
        $0.register(HomeVCTableViewCell.self, forCellReuseIdentifier: HomeVCTableViewCell.cellId)
        $0.delegate = self
        $0.backgroundColor = .systemBackground
    }
    
    private let emptyLabel = UILabel().then {
        $0.text = "TODO가 등록되지 않았어요.\n+버튼을 눌러 추가해주세요."
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
    }
    
    /// UITableViewDiffableDataSource 이전에는 controller가 delegate를 통해 cell의 모양, 개수를 받아서 처리하는 방식
    /// - IndexPath에서 오류가 발생하거나 속도가 느린 경우가 있었음
    ///
    /// DiffableDataSource가 도입됨에 따라 IndexPath 개념이 아닌 Hash를 사용함
    /// - 빠른 속도를 보장하며, IndexPath를 잘못 입력하여 오류가 발생할 확률도 줄어듬
    /// -> section, cell에 표시되는 데이터는 hashable을 준수해야함
    ///
    /// DiffableDataSource는 항상 새로운 스냅샷을 apply() 하는 방식으로 이루어짐
    /// - 기존 스냅샷을 복사해서 참조할 수 있고, 새로운 스냅샷을 만들 수 도 있지만, 적용하는건 항상 새로운 스냅샷이여야 함
    /// -> 상태기반의 프로그래밍 방식으로 설계되었기 때문
    ///
    /// + DiffableDataSource와 Swift 6.2를 같이 사용하기 되면 오류가 발생할 수 있음 (sendable 준수문제)
    /// - TodoManager에 기록
    private lazy var dataSources = UITableViewDiffableDataSource<TodoSection, Todo>(tableView: self.tableView, cellProvider: { tableView, indexPath, data in
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeVCTableViewCell.cellId, for: indexPath) as? HomeVCTableViewCell  else {return UITableViewCell()}
        cell.configure(title: data.title, isComplated: data.isCompleted) {
            print("TAPPED")
        }
        return cell
    })
    
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
        
        Task {
            await self.viewModel.reloadData()
        }
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
        self.tableViewUpdate()
    }
}

private extension HomeVC {
    
    // MARK: - Methods
    
    func attribute() {
        self.navigationItem.title = "TODO"
        self.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        self.tableView.dataSource = self.dataSources
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
    
    func tableViewUpdate() {
        var snapShot = NSDiffableDataSourceSnapshot<TodoSection, Todo>()
        snapShot.appendSections(self.viewModel.sections)
        
        /// section을 추가한 이후에도 각 section에 속하는 item은 별도로 추가해야함
        /// - section와 item을 분리해서 관리하기 때문
        for section in self.viewModel.sections {
            snapShot.appendItems(section.todos, toSection: section)
        }
        
        self.dataSources.apply(snapShot, animatingDifferences: true)
    }
    
    @objc
    func addBtnTapped() {
        let addVC = AddVC() { [weak self] in
            Task {
                await self?.viewModel.reloadData()
            }
        }
        
        let navigationViewController = UINavigationController(rootViewController: addVC)
        self.present(navigationViewController, animated: true)
    }
}

// MARK: - extension UITableViewDelegate

extension HomeVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HomeVCTableViewHeader()
        let data = self.viewModel.sections[section]
        
        headerView.configure(title: data.title)
        
        return headerView
    }
}
