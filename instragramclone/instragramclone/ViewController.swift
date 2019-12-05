//
//  ViewController.swift
//  instragramclone
//
//  Created by gdaalumno on 10/23/19.
//  Copyright © 2019 gdaalumno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Photo: Codable {
        var albumId: Int
        var id: Int
        var thumbnailUrl: String
        var title: String
        var url: String
    }
    
    var dataObjects = [Photo]()
    var loadedImages = [UIImage]()
    
    @IBOutlet weak var tableV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let nib = UINib.init(nibName: "CustomCell", bundle: nil)
        self.tableV.register(nib, forCellReuseIdentifier: "Cell")
        getData()
    }

    func getData() {
        let imgUrl = "https://jsonplaceholder.typicode.com/photos"
        let urlObj = URL(string: imgUrl)!
        
        let task = URLSession.shared.dataTask(with: urlObj) {
            (data, res, err) in
            
            if let response = res {
                //print(response)
            }
            
            if let jsonData = data {
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        self.dataObjects = try decoder.decode([Photo].self, from:
                            jsonData)
                        for (index, _) in self.dataObjects.enumerated() {
                            self.loadedImages.append(UIImage())
                            self.getImg(index)
                        }
                        self.reloadTable()
                        
                    } catch let parsingError {
                        print("Error", parsingError)
                    }
                }
            }
            
            if let error = err {
                print(error)
            }
        }
        task.resume()
    }
    
    func getImg(_ photo: Int) {
        let urlObj = URL(string: dataObjects[photo].url)!
        let task = URLSession.shared.dataTask(with: urlObj) {
            (data, res, err) in
            
            if let response = res {
                //print(response)
            }
            
            if let imgData = data {
                DispatchQueue.main.async {
                    //self.loadedImages[photo] = UIImage(data: imgData)!
                    let img = UIImage(data: imgData)
                    self.loadedImages.insert(img!, at: photo)
                }
            }
            
            if let error = err {
                print(error)
            }
        }
        task.resume()
    }
    
    func reloadTable() {
        tableV.reloadData()
    }
}

extension ViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! CustomCell
        self.tableV.rowHeight = 300
        //(cell.contentView.viewWithTag(1) as? UIImageView)?.image = self.loadedImages[indexPath.row]
        //(cell.contentView.viewWithTag(2) as? UILabel)?.text = self.dataObjects[indexPath.row].title
        cell.placeImg.image = self.loadedImages[indexPath.row]
        cell.titleTxt.text = self.dataObjects[indexPath.row].title
        
        return cell
    }
}

