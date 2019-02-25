//
//  Coordinator.swift
//  FriendZone
//
//  Created by Ünal Öztürk on 30.01.2019.
//  Copyright © 2019 Ünal Öztürk. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childCoordinator : [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}
