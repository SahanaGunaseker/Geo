//
//  HistoryTableViewController.swift
//  GeoCalculator
//
//  Created by Sahana on 5/30/17.
//  Copyright © 2017 Jonathan Engelsma. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    var entries : [LocationLookup] = []
    var historyDelegate:HistoryTableViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
 self.sortIntoSections(entries: self.entries)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // #warning Incomplete implementation, return the number of sections
        
        if let data = self.tableViewData {
            
            return data.count
            
        } else {
            
            return 0
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:
        
        Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        
        if let sectionInfo = self.tableViewData?[section] {
            
            return sectionInfo.entries.count
            
        } else {
            
            return 0
            
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
        
        IndexPath) {
        
        // use the historyDelegate to report back entry selected to the calculator scene
        
        if let del = self.historyDelegate {
            
            let ll = entries[indexPath.row]
            
            del.selectEntry(entry: ll)
            
        }
        // this pops to the calculator
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    var tableViewData: [(sectionHeader: String, entries: [LocationLookup])]? {
        
        didSet {
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        
        IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FancyCell", for:indexPath) as! HistoryTableViewCell
        
        //let ll = entries[indexPath.row]
        
        if let ll = self.tableViewData?[indexPath.section].entries[indexPath.row] {
            
            cell.origPoint.text = "(\(ll.origLat.roundTo(places:4)),\(ll.origLng.roundTo(places:4)))"
            
            cell.destPoint.text = "(\(ll.destLat.roundTo(places:4)),\(ll.destLng.roundTo(places: 4)))"
            
            cell.timestamp.text = ll.timestamp.description
            
        }
        
        return cell
        
    }
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection
        
        section: Int) ->
        
        String? {
            
            return self.tableViewData?[section].sectionHeader
            
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) ->
        
        CGFloat {
            
            return 200.0
            
    }
    
    override func tableView(_ tableView: UITableView, willDisplayFooterView view:
        
        UIView, forSection
        
        section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = THEME_COLOR2
        
        header.contentView.backgroundColor = THEME_COLOR3
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view:
        
        UIView,forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        
        header.textLabel?.textColor = THEME_COLOR2
        
        header.contentView.backgroundColor = THEME_COLOR3
        
    }
  
    
    func sortIntoSections(entries: [LocationLookup]) {
        
        
        
        var tmpEntries : Dictionary<String,[LocationLookup]> = [:]
        
        var tmpData: [(sectionHeader: String, entries: [LocationLookup])] = []
        
        
        
        // partition into sections
        
        for entry in entries {
            
            let shortDate = entry.timestamp.short
            
            if var bucket = tmpEntries[shortDate] {
                
                bucket.append(entry)
                
                tmpEntries[shortDate] = bucket
                
            } else {
                
                tmpEntries[shortDate] = [entry]
                
            }
            
        }
        
        
        
        // breakout into our preferred array format
        
        let keys = tmpEntries.keys
        
        for key in keys {
            
            if let val = tmpEntries[key] {
                
                tmpData.append((sectionHeader: key, entries: val))
                
            }
            
        }
        
        // sort by increasing date.
        
        tmpData.sort { (v1, v2) -> Bool in
            
            if v1.sectionHeader < v2.sectionHeader {
                return true
                
            } else {
                
                return false
                
            }
            
        }
        
        
        
        self.tableViewData = tmpData
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension Date {
    struct Formatter {
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            return formatter
        }()
    }
    
    var short: String {
        return Formatter.short.string(from: self)
    }
}

extension String {
    
    
    var dateFromShort: Date? {
        return Date.Formatter.short.date(from: self)
    }
}
extension Double {
    
    /// Rounds the double to decimal places value
    
    func roundTo(places:Int) -> Double {
        
        let divisor = pow(10.0, Double(places))
        
        return (self * divisor).rounded() / divisor
        
    }
    
}
protocol HistoryTableViewControllerDelegate {
    func selectEntry(entry: LocationLookup)
    
}

