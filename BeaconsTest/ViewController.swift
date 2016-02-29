//
//  ViewController.swift
//  BeaconsTest
//
//  Created by Rodrigo Fernandes Bulgarelli on 2/29/16.
//  Copyright © 2016 Rodrigo Fernandes Bulgarelli. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, ESTBeaconManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let beaconManager = ESTBeaconManager()
    let beaconRegion = CLBeaconRegion(
        proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D")!,
        identifier: "ranged region")
    
    var beacons = [String :CLBeacon]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.beaconManager.delegate = self
        self.beaconManager.requestAlwaysAuthorization()
        self.navigationItem.title = "Beacons próximos"
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.beaconManager.startRangingBeaconsInRegion(self.beaconRegion)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.beaconManager.stopRangingBeaconsInRegion(self.beaconRegion)
    }
    
    // MARK: - Tableview datasource methods.

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beacons.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        let beacon = self.beacons.values[self.beacons.startIndex.advancedBy(indexPath.row)]
        cell.textLabel?.text = "Major: \(beacon.major)  Minor: \(beacon.minor)"
        cell.detailTextLabel?.text = "\(beacon.debugDescription)"
        return cell
    }
    
    // MARK: - BeaconsManager delegate methods
    
    func beaconManager(manager: AnyObject, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        for nearestBeacon in beacons {
           self.beacons["\(nearestBeacon.major):\(nearestBeacon.minor)"] = nearestBeacon
        }
         self.tableView.reloadData()
    }
}

