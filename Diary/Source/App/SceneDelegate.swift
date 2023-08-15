//  Diary - SceneDelegate.swift
//  Created by Ayaan, zhilly on 2022/12/20

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene: UIWindowScene = (scene as? UIWindowScene) else { return }
        
        let mainViewController: DiaryListViewController = .init()
        let navigationController: UINavigationController = .init(rootViewController: mainViewController)
        let navigationBarAppearance: UINavigationBarAppearance = .init()
        
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationController.navigationBar.standardAppearance = navigationBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        NotificationCenter.default.post(name: .didEnterBackground, object: nil)
    }
}
