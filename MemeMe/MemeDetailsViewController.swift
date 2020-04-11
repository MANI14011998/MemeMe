//
//  MemeDetailsViewController.swift
//  MemeMe
//
//  Created by MANINDER SINGH on 11/04/20.
//  Copyright © 2020 MANINDER SINGH. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailsViewController: UIViewController {
    
    @IBOutlet weak var memedImageView: UIImageView!
    
    var position: Int!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (position != nil) {
            let meme = MemeStorage.get(position)
            memedImageView.image = meme.memeImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (position == nil) {
            let alertController = UIAlertController(title: "No Meme Selected", message: "", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
        }
    }
}
