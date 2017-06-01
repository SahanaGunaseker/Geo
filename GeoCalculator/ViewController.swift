//
//  ViewController.swift
//  GeoCalculator
//
//  Created by Jonathan Engelsma on 1/23/17.
//  Copyright © 2017 Jonathan Engelsma. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, HistoryTableViewControllerDelegate {

    @IBOutlet weak var p1Lat: DecimalMinusTextField!
    @IBOutlet weak var p1Lng: DecimalMinusTextField!
    @IBOutlet weak var p2Lat: DecimalMinusTextField!
    @IBOutlet weak var p2Lng: DecimalMinusTextField!
    
    
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bearingLabel: UILabel!
    
    func selectEntry(entry: LocationLookup){
        print("hello")
    }
    var distanceUnits : String = "Kilometers"
    var bearingUnits : String = "Degrees"
    //var entries : [LocationLookup] = []
    var entries : [LocationLookup] = [
        
        LocationLookup(origLat: 90.0, origLng: 0.0, destLat: -90.0, destLng: 0.0,
                       
                       timestamp: Date.distantPast),
        
        LocationLookup(origLat: -90.0, origLng: 0.0, destLat: 90.0, destLng: 0.0,
                       
                       timestamp: Date.distantFuture)]
    
    @IBOutlet weak var tableView: UITableView!
    //var tableViewData: [(sectionHeader: String, entries: [LocationLookup])]? {
      //  didSet {
        //    DispatchQueue.main.async {
          //      self.tableView.reloadData()
            //}
        //}
    //}
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = THEME_COLOR2
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        // your code goes here
        
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section:
        
        Int) -> Int {
        //let ent = self.entries
        return self.entries.count// your code goes here
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        
        IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for:indexPath)
       // if let entry = self.entries?[indexPath.row]{
         let entry = entries[indexPath.row]
        
        
          cell.textLabel?.text = "\(entry.origLat), \(entry.origLng), \(entry.destLat), \(entry.destLng)"
          cell.detailTextLabel?.text = "\(entry.timestamp)"
        
        
        
        // your code goes here.
        
        return cell
        
    }
    

    func doCalculatations()
    {
        guard let p1lt = Double(self.p1Lat.text!), let p1ln = Double(self.p1Lng.text!), let p2lt = Double(self.p2Lat.text!), let p2ln = Double(p2Lng.text!) else {
            return
        }
       
               let p1 = CLLocation(latitude: p1lt, longitude: p1ln)
        let p2 = CLLocation(latitude: p2lt, longitude: p2ln)
        let distance = p1.distance(from: p2)
        let bearing = p1.bearingToPoint(point: p2)
        
        if distanceUnits == "Kilometers" {
            self.distanceLabel.text = "Distance: \((distance / 10.0).rounded() / 100.0) kilometers"
        } else {
            self.distanceLabel.text = "Distance: \((distance * 0.0621371).rounded() / 100.0) miles"
        }
        
        if bearingUnits == "Degrees" {
            self.bearingLabel.text = "Bearing: \((bearing * 100).rounded() / 100.0) degrees."
        } else {
            self.bearingLabel.text = "Bearing: \((bearing * 1777.7777777778).rounded() / 100.0) mils."
        }
        self.entries.append(LocationLookup(origLat: p1lt, origLng: p1ln, destLat: p2lt,
                                      
                                      destLng: p2ln, timestamp: Date()))
    }
    
    @IBAction func calculateButtonPressed(_ sender: UIButton) {
        
        self.doCalculatations()
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    

    @IBAction func clearButtonPressed(_ sender: UIButton) {
        self.p1Lat.text = ""
        self.p1Lng.text = ""
        self.p2Lat.text = ""
        self.p2Lng.text = ""
        self.distanceLabel.text = "Distance: "
        self.bearingLabel.text = "Bearing: "
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
          if let dest = segue.destination as? SettingsViewController {
                dest.dUnits = self.distanceUnits
                dest.bUnits = self.bearingUnits
                dest.delegate = self
            }
        }
        if segue.identifier == "historySegue"{
            if let hist = segue.destination as? HistoryTableViewController {
           hist.historyDelegate = self
            hist.entries = self.entries
        }
    }
}
}

extension ViewController : SettingsViewControllerDelegate
{
    func settingsChanged(distanceUnits: String, bearingUnits: String)
    {
        self.distanceUnits = distanceUnits
        self.bearingUnits = bearingUnits
        self.doCalculatations()
    }
}
