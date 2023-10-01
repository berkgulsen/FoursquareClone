//
//  PlacesVC.swift
//  FoursquareClone
//
//  Created by Berk Gülşen on 1.10.2023.
//

import UIKit

class PlacesVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }

    @objc func addButtonClicked(){
        //segue
    }
}
