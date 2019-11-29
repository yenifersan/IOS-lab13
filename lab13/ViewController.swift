//
//  ViewController.swift
//  lab13
//
//  Created by yenifer santiago  on 11/14/19.
//  Copyright © 2019 yenifer santiago . All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class ViewController: UIViewController,UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var loginButton: UIBarButtonItem!
    @IBOutlet weak var logOut: UIBarButtonItem!
    @IBOutlet weak var loginInfoLabel: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    var customImageFlowLayout: CustomImageFlowLayout!
    
    var images = [CatInsta]()
    var dbRef: DatabaseReference!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        dbRef = Database.database().reference().child("images")
        loadDB()  
        customImageFlowLayout = CustomImageFlowLayout()
        imageCollection.collectionViewLayout = customImageFlowLayout
        imageCollection.backgroundColor = .white
    }
    
    func loadDB(){
        
        dbRef.observe(DataEventType.value, with: {(snapshot) in
            var newImages = [CatInsta]()
            
            for catInstaSnapshot in snapshot.children{
                let catInstaObject = CatInsta(snapshot: catInstaSnapshot as! DataSnapshot)
                newImages.append(catInstaObject)
            }
                self.images = newImages
                self.imageCollection.reloadData()
        })
   
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            self.loginButton.isEnabled = false
            self.logOut.isEnabled = true
            self.loginInfoLabel.text = "hello" +  (Auth.auth().currentUser?.email)!
        }else{
            self.loginButton.isEnabled = true
            self.logOut.isEnabled = false
            self.loginInfoLabel.text = "hello please login"
        }
        
    }
    
    @IBAction func logOuthButtonCliked(_ sender: Any) {
        
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                
                self.loginButton.isEnabled = true
                self.logOut.isEnabled = false
                self.loginInfoLabel.text = "hello please login"
                
            } catch let signOutError as NSError {
                print("error signing outh :  %@", signOutError)
                
            }
        }
    }
    
    func collectionView(_ imageCollection: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        
    }
    
    func collectionView(_ imageCollection: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell
        let image = images[indexPath.row]
    
        cell.imageView.sd_setImage(with: URL(string: image.url), placeholderImage: UIImage(named: "image1"))
        return cell
    }
    
    //metodo func imagepickercontroller

   /* func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else{
            
            var data = Data()
            data = UIImageJPEGRepresentation(pickedImage,0.8)!
            
            let imageRef = Storage.storage().reference().child("images/" + randomString(20));
            
        }
    }
 */
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            var data = Data()
            data = pickedImage.jpegData(compressionQuality: 0.0)!
            
            let imageRef = Storage.storage().reference().child("images/" + randomString(20));
            _ = imageRef.putData(data, metadata: nil){ (metadata, error) in
                guard metadata != nil else {
                    return
                }
                _ = imageRef.downloadURL { downloadURL, error in
                    if let  error = error {
                        print(error)
                    } else {
                        print(downloadURL!.absoluteString)
                        
                        //update the database
                        //let key = self.dbRef.childByAutoId().key
                        //let image = ["url":downloadURL?.absoluteString]
                        //let childUpdates = ["/\(key)": image]
                        //self.dbRef.updateChildValues(childUpdates)
                    }
                    
                }
            }
        }
    }
    
    /*
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            var data = Data()
            data = UIImageJPEGRepresentation(pickedImage, 0.8)!//
            
            let imageRef = Storage.storage().reference().child("images/" + randomString(20));
            _ = imageRef.put(data, metadata: nil){ (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                let dowloadURL = metadata.dowloadURL()
                print (dowloadURL)
            }
        }
    }
 */
    
    
    @IBAction func loadImageButtonClicked(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true,completion: nil)
    }
    func randomString(_ length: Int) -> String {
        let letters  : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
    
    
}

