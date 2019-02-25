//
//  MainCoordinator.swift
//  FriendZone
//
//  Created by Ünal Öztürk on 30.01.2019.
//  Copyright © 2019 Ünal Öztürk. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinator =  [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ViewController.instantiate()
        vc.coordinator = self 
        navigationController.pushViewController(vc, animated: true)
    }
    
    func configure(friend: Friend ) {
        let vc = FriendViewController.instantiate()
        vc.coordinator = self
        vc.friend = friend
        navigationController.pushViewController(vc, animated: true)
    }
    
    func update(friend: Friend) {
        guard let vc = navigationController.viewControllers.first as? ViewController  else { return }
        vc.update(friend: friend)
    }
}
