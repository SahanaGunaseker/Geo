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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
protocol HistoryTableViewControllerDelegate {
    
    func selectEntry(entry: LocationLookup)
}
