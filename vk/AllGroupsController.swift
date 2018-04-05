//
//  AllGroupsController.swift
//  vk
//
//  Created by Александр on 22.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import Alamofire

class AllGroupsController: UITableViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    var groupsRequest = GroupsDataRequest()
    var groups = [GroupVK]()
    
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        userDefaults.set(searchText, forKey: "whatYouSearch")
        
        groupsRequest.loadGroupsDataCount() { [weak self] groups in
            self?.groups = groups
            OperationQueue.main.addOperation {
                self?.tableView.reloadData()
            }
        }
    }
    // FIXME: без этого метода показывает ячейки правильно, т.к. первая ячейка тоже форматируется (при включенном методе isActive = true, только, когда появляется первая ячейка
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.hidesBarsOnSwipe = true
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //if isFiltering() {
        return groups.count
        //}
        //return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupsCell", for: indexPath) as! AllGroupsCell
        
        //if isFiltering() {
        let group = groups[indexPath.row]
        cell.nameOfGroup.text = group.name
        if let membersCount = group.members_count {
            cell.countMembers.text = String(membersCount)
        }
        cell.setGroupName(text: cell.nameOfGroup.text!)
        cell.setCountMembers(text: cell.countMembers.text!)
        
        guard let imgURL = URL(string: group.photo_100) else { return cell }
        Alamofire.request(imgURL).responseData(queue: .global()) { response in
            OperationQueue.main.addOperation {
                cell.groupPhoto.image = UIImage(data: response.data!)
            }
        }
        //}
        return cell
    }
}

extension AllGroupsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
