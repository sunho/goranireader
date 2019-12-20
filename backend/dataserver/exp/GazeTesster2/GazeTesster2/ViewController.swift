//
//  ViewController.swift
//  GazeTesster2
//
//  Created by Sunho Kim on 10/12/2019.
//  Copyright © 2019 Sunho Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let sessionHandler = SessionHandler()
    
    
    @IBOutlet weak var preview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }



    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        sessionHandler.openSession()
        

        let layer = sessionHandler.layer
        layer.frame = preview.bounds

        preview.layer.addSublayer(layer)
        
        view.layoutIfNeeded()

    }

}

