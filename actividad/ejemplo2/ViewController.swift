//
//  ViewController.swift
//  ejemplo2
//
//  Created by gdaalumno on 9/4/19.
//  Copyright © 2019 gdaalumno. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController {
    
    // Init global variables
    var EventDict = [String: [NSManagedObject]]()
    var keysArray = [String]()
    var currentLocation = CLLocation()
    
    let locationManager = CLLocationManager()
    
    // override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let defaults = UserDefaults.standard
        let hasSeenTutorial = defaults.bool(forKey: "tutorial")
        if (!hasSeenTutorial) {
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "Page Main") as! MyViewController
            self.present(newViewController, animated: true, completion: nil)
            
        } else {
            let nib = UINib.init(nibName: "GeraCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "Cell")
            locationManager.delegate = self
            getCurrentLocation()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if keysArray.isEmpty {
            fetchCoreData()
        }
        reload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.identifier == "CellDetails" {
            let destination = segue.destination as? DetailsViewController
            let cellIndex = tableView.indexPathForSelectedRow!.row
            let cellSection = tableView.indexPathForSelectedRow!.section
            
            let clickedEvent = EventDict[keysArray[cellSection]]![cellIndex]
            destination?.newTitle = clickedEvent.value(forKey: "activity") as? String ?? ""
            destination?.date = clickedEvent.value(forKey: "date") as! Date
            destination?.latitude = clickedEvent.value(forKey: "latitude") as! Double
            destination?.longitude = clickedEvent.value(forKey: "longitude") as! Double
        }
    }

    // Outlet
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func btnAddActivityA(_ sender: Any) {
        addEvent(DailyEvent.eventA, EventImage.eventA.rawValue)
    }
    
    @IBAction func btnAddActivityB(_ sender: Any) {
        let alert = UIAlertController(title: "More Options", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Play Violin", style: .default) { _ in
            self.addEvent(DailyEvent.eventB, EventImage.eventB.rawValue)
        })
        alert.addAction(UIAlertAction(title: "Play videogames", style: .default) { _ in
            self.addEvent(DailyEvent.eventD, EventImage.eventD.rawValue)
        })
        present(alert, animated: true)
    }
    
    @IBAction func btnAddActivityC(_ sender: Any) {
        addEvent(DailyEvent.eventC, EventImage.eventC.rawValue)
    }
    
    // Helper functions
    func addEvent(_ event: DailyEvent, _ img: String) {
        insertToCoreData(activityName: event.rawValue, imgName: img)
        reload()
    }
    
    func fetchCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Event")
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            let list = try managedContext.fetch(request)
            for event in list {
                let dateToday = event.value(forKey: "date") as! Date
                let dateKey = getTodayDay(dateToday)
                
                if EventDict.keys.contains(dateKey) {
                    EventDict[dateKey]?.append(event)
                } else {
                    var tempArray = [NSManagedObject]()
                    tempArray.append(event)
                    EventDict[dateKey] = tempArray
                }
            }
            
        } catch let error as NSError {
            print("Error \(error)")
        }
    }
    
    func insertToCoreData(activityName: String, imgName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Event", in: managedContext)!
        let newActivity = NSManagedObject(entity: entity, insertInto: managedContext)
        let dateToday = Date()
        
        newActivity.setValue(activityName, forKey: "activity")
        newActivity.setValue(dateToday, forKey: "date")
        newActivity.setValue(imgName, forKey: "imgType")
        newActivity.setValue(currentLocation.coordinate.longitude, forKey: "longitude")
        newActivity.setValue(currentLocation.coordinate.latitude, forKey: "latitude")
        
        do {
            try managedContext.save()
            
            let dateKey = getTodayDay(dateToday)
            if EventDict.keys.contains(dateKey) {
                EventDict[dateKey]?.insert(newActivity, at: 0)
            } else {
                var tempArray = [NSManagedObject]()
                tempArray.append(newActivity)
                EventDict[dateKey] = tempArray
            }
        } catch let error as NSError {
            print("Failed to save \(error): \(error.userInfo)")
        }
    }
    
    func getTodayDay(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let result = format.string(from: date)
        return result
    }
    
    func getYesterday(_ date: Date) -> String {
        let res = Calendar.current.date(byAdding: .day, value: -1, to: date)!
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let result = format.string(from: res)
        return result
    }
    
    func getTodayHour(_ date: Date) -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        let result = format.string(from: date)
        return result
    }
    
    func reload() {
        keysArray = Array(EventDict.keys).sorted(by: >)
        tableView.reloadData()
    }
    
    func getCurrentLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        if (status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()) {
            return
        }
        
        if (status == .notDetermined) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.requestLocation()
    }
}

extension ViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventDict[keysArray[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.rowHeight = 100
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! GeraCell
        let event = EventDict[keysArray[indexPath.section]]![indexPath.row]
        let eventDate = event.value(forKey: "date") as! Date
        let eventImg = event.value(forKey: "imgType") as! String
        
        cell.title1?.text = event.value(forKey: "activity") as? String
        cell.subTitle1?.text = getTodayHour(eventDate)
        cell.imageUI.image = #imageLiteral(named: eventImg)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return keysArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if keysArray[section] == getTodayDay(Date()) {
            return "Today"
        }
        if keysArray[section] == getYesterday(Date()) {
            return "Yesterday"
        }
        return keysArray[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "CellDetails", sender: self)
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let current = locations.first {
            currentLocation = current
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways:
            print("always")
        case .authorizedWhenInUse:
            print("when in use")
        case .denied:
            print("denied")
        case .notDetermined:
            print("not determines")
        default:
            print("default")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

