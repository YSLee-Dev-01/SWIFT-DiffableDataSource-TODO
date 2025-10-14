//
//  SceneDelegate.swift
//  Swift_DiffableDataSource
//
//  Created by 이윤수 on 10/13/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let homeVC = HomeVC()
        let  navigationController = UINavigationController(rootViewController: homeVC)
        
        navigationController.navigationBar.prefersLargeTitles = true
        
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        TodoManager.shared.loadTodos()
    }
}

