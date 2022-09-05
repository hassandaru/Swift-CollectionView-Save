//
//  DetailViewController.swift
//  CollectionViewSave
//
//  Created by Hassan Sohail Dar on 5/9/2022.
//

import UIKit

class DetailViewController: UIViewController {
    var thisUser: User?
    @IBOutlet var imageUser: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        // Do any additional setup after loading the view.
       
            if let isUser = thisUser {
                //get the path of files saved
                let path = getDocumentsDirectory().appendingPathComponent(isUser.image)
                imageUser.image = UIImage(contentsOfFile: path.path)
                title = isUser.name

            }
            return
            
            //now assign it the vallue and show it.
       
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
