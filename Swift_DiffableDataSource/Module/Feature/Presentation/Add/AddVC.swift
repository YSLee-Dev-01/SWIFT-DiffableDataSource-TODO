//
//  AddVC.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/14/25.
//

import UIKit
import Then
import SnapKit

class AddVC: UIViewController {
    
    // MARK: - Properties
    
    private lazy var textField = UITextField().then {
        $0.placeholder = "TODO 내용을 입력해주세요."
        $0.font = .systemFont(ofSize: 17, weight: .medium)
        $0.delegate = self
    }
    
    private let textFieldBottomBorder = UIView().then {
        $0.backgroundColor = UIColor.systemGray4
    }
    
    private let createDate = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .secondaryLabel
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sectionDate = dateFormatter.string(from: .now)
        $0.text = "\(sectionDate) 작성"
    }
    
    private let recommendTitle = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .secondaryLabel
        $0.text = "추천 TODO"
    }
    
    private lazy var tableView = UITableView().then {
        $0.register(AddVCTableViewCell.self, forCellReuseIdentifier: AddVCTableViewCell.cellId)
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
    }
    
    private let viewModel = AddViewModel()
    
    private var onCompleted: (() -> Void)?
  
    // MARK: - LifeCycle
    
    init(onCompleted: (() -> Void)? = nil) {
        self.onCompleted = onCompleted
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.attribute()
        self.layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.textField.becomeFirstResponder()
    }
}

private extension AddVC {
    
    // MARK: - Methods
    
    func attribute() {
        self.navigationItem.title = "TODO 추가하기"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBtnTapped))
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func layout() {
        [self.createDate, self.textField, self.textFieldBottomBorder, self.recommendTitle, self.tableView]
            .forEach {
                self.view.addSubview($0)
            }
        
        self.createDate.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(12)
            $0.leading.equalToSuperview().offset(20)
        }
        
        self.textField.snp.makeConstraints {
            $0.top.equalTo(self.createDate.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        self.textFieldBottomBorder.snp.makeConstraints {
            $0.top.equalTo(self.textField.snp.bottom)
            $0.leading.trailing.equalTo(self.textField)
            $0.height.equalTo(1)
        }
        
        self.recommendTitle.snp.makeConstraints {
            $0.top.equalTo(self.textField.snp.bottom).offset(30)
            $0.leading.equalTo(self.createDate)
        }
        
        self.tableView.snp.makeConstraints {
            $0.top.equalTo(self.recommendTitle.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc
    func doneBtnTapped() {
        self.viewModel.addTodo(self.textField.text ?? "")
        self.dismiss(animated: true) {
            self.onCompleted?()
        }
    }
    
    @objc
    private func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            UIView.animate(withDuration: 0.3) {
                self.tableView.contentInset.bottom = keyboardFrame.height
            }
        }
    }
    
    @objc
    private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.tableView.contentInset.bottom = 0
        }
    }
}

// MARK: - extension UITableViewDelegate, UITableViewDataSource

extension AddVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.recommendTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddVCTableViewCell.cellId, for: indexPath) as? AddVCTableViewCell else {return UITableViewCell()}
        cell.configure(title: self.viewModel.recommendTitles[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.textField.text = self.viewModel.recommendTitles[indexPath.row]
    }
}

// MARK: - extension UITextFieldDelegate

extension AddVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if !(textField.text?.isEmpty ?? true) {
            self.doneBtnTapped()
        }
        
        return true
    }
}
