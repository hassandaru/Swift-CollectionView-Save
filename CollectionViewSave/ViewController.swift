//
//  ViewController.swift
//  CollectionViewSave
//
//  Created by Hassan Sohail Dar on 5/9/2022.
//

import UIKit

class ViewController: UICollectionViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //collection of users to show
    var userList = [User]()
    
    @objc fileprivate func extractedFunc() {
        // Do any additional setup after loading the view.
        //retrieve previous user list if it exists
        let defaults = UserDefaults.standard
        if let users = defaults.object(forKey: "users") as? Data {
            let decoder = JSONDecoder()
            
            do {
                userList = try decoder.decode([User].self, from: users)
            } catch {
                print("something went wrong in decoding users.")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewUser))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        extractedFunc()

        
    }
    
    @objc func addNewUser() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userList.count
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as? UserCell else {
            fatalError("Unable to dequeue User Cell.")
            
        }
        
        let user = userList[indexPath.item]
        //get the path of files saved
        let path = getDocumentsDirectory().appendingPathComponent(user.image)
        
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.name.text = user.name
        
        //make the cell pretty
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        // return the cell

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("came here ")
        let user = userList[indexPath.item]
        //rename the user
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()


        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            user.name = newName
            self?.save()
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self, indexPath] _ in
            self?.userList.remove(at: indexPath.row)
            self?.collectionView.reloadData()

        })
        ac.addAction(UIAlertAction(title: "Show Image", style: .default) { [weak self, indexPath] _ in
            //present in navigation controller
            if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                let user = self?.userList[indexPath.item]
                vc.thisUser = user
                self?.navigationController?.pushViewController(vc, animated: true)
                return
            }

        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(ac, animated: true)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        let user = User(name: "Unknown", image: imageName)
        userList.append(user)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(userList) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "users")
        } else {
            print("Failed to save people.")
        }
    }
    
}



