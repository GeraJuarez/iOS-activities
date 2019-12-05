//
//  ProfileViewController.swift
//  ejemplo2
//
//  Created by gdaalumno on 10/16/19.
//  Copyright © 2019 gdaalumno. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        if let currentImg = fetchCoreData() {
            let image = currentImg.value(forKey: "img") as! Data
            self.profileImg.image = UIImage(data: image)
        }
    }
    
    @IBAction func changeImg(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    func insertToCoreData(image: NSData) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        var newActivity: NSManagedObject?
        let managedContext = appDelegate.persistentContainer.viewContext
        newActivity = fetchCoreData()
        
        if newActivity == nil {
            let entity = NSEntityDescription.entity(forEntityName: "Profile", in: managedContext)!
            newActivity = NSManagedObject(entity: entity, insertInto: managedContext)
        }
        newActivity!.setValue(image, forKey: "img")
        
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Failed to save \(error): \(error.userInfo)")
        }
    }
    
    func fetchCoreData() -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Profile")
        
        do {
            let list = try managedContext.fetch(request)
            if let img = list.first {
                return img
            }
            return nil
    
        } catch let error as NSError {
            print("Error \(error)")
            return nil
        }
    }
    
    func saveImgData(img: UIImage) {
        let data = img.pngData()
        self.insertToCoreData(image: data! as NSData)
    }
}

extension ProfileViewController: ImagePickerDelegate {
    //let image = UIImage(data: data)
    func didSelect(image: UIImage?) {
        self.profileImg.image = image
        self.saveImgData(img: image!)
    }
}
