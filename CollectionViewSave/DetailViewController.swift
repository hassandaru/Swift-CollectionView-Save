//
//  DetailViewController.swift
//  CollectionViewSave
//
//  Created by Hassan Sohail Dar on 5/9/2022.
//

import UIKit

class DetailViewController: UIViewController {
    var imageName : String?
    var thisUser: User?
    @IBOutlet var imageUser: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
       
            if let imageOfUser = thisUser {
                imageUser.image = UIImage(named: imageOfUser.image)
                title = thisUser?.name

            }
            return
            
            //now assign it the vallue and show it.
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    

}
