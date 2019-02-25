//
//  ViewController.swift
//  InnerPlace
//
//  Created by Ünal Öztürk on 4.02.2019.
//  Copyright © 2019 Ünal Öztürk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var quote: UIImageView!
    
    let quotes = Bundle.main.decode([Quote].self, from: "quotes.json")
    let images = Bundle.main.decode([String].self, from: "pictures.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateQuote() {
        
        guard let backgroundImageName = images.randomElement() else {
            fatalError("Unable to read an image.")
        }
        
        background.image = UIImage(named: backgroundImageName)
        
        guard let selectedQuote = quotes.randomElement() else {
            fatalError("Unable to read an quote.")
        }
        
        let insetAmount = 250
        let drawBounds = quote.bounds.inset(by: UIEdgeInsets(top: insetAmount , left: insetAmount, bottom: insetAmount, right: insetAmount))
        
    }


}

