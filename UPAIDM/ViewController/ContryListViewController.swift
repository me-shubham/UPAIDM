//
//  ContryListViewController.swift
//  u-paid-m
//
//  Created by Srajan Singhal on 31/08/21.
//

import UIKit

class ContryListViewController: UIViewController , UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var countryInfo: (((name: String, flag: String, code: String)) -> Void)?

    let data = getCountryList()

    var filteredData: [(name: String, flag: String, code: String)]!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchBar.delegate = self
        filteredData = data
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
        let tableDate = filteredData[indexPath.row]
        cell.textLabel?.text = tableDate.flag + " " + tableDate.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countryInfo?(filteredData[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredData = searchText.isEmpty ? data : data.filter({(name: String, flag: String, code: String) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return name.range(of: searchText, options: .caseInsensitive) != nil
        })
        
        tableView.reloadData()
    }
}
