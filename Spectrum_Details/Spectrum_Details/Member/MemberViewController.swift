//
//  MemberViewController.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 25/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewMember: UITableView!
    @IBOutlet weak var labelNoDataAvailable: UILabel!
    
    var company: Company?
    var members: [Member] = []
    var ascending: Bool?
    var alert: UIAlertController?
    var isSearchEnabled = false
    var isAgeSelected: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        labelNoDataAvailable.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        fetchAllMembers(companyId: (company?.id ?? ""))
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableViewMember.separatorStyle = .none
        tableViewMember.delegate = self
        tableViewMember.dataSource = self
        tableViewMember.tableFooterView = UIView()
    }
    
    private func setupNavigationBar() {
        self.title = (company?.name ?? Utils.localizedString(forKey: Keys.members))
        //Utils.localizedString(forKey: Keys.members) + " " + ( company?.name ?? "")
        let rightButtonItem = UIBarButtonItem(image: UIImage(named: "Filter"), style: .plain, target: self, action: #selector(filterTapped))
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc fileprivate func filterTapped(sender: UIBarButtonItem) {
        setOptionsForFilterAgeName()
    }
    
    private func setOptionsForFilterAgeName() {
        alert = UIAlertController(title: Utils.localizedString(forKey: Keys.searchBy), message: "", preferredStyle: .alert)
        
        //Cancel Action
        let actionCanel = UIAlertAction(title: Utils.localizedString(forKey: Keys.cancel), style: .cancel, handler: nil)
        alert?.addAction(actionCanel)
        
        //Age
        let actionAge = UIAlertAction(title: Utils.localizedString(forKey: Keys.age), style: .default, handler: { (action) in
            self.isAgeSelected = true
            self.setOptionsForFilter()
        })
        
        if self.isAgeSelected != nil && self.isAgeSelected == true {
            actionAge.setValue(UIImage(named: "Selected"), forKey: "image")
        }
        
        alert?.addAction(actionAge)
        
        //Descending
        let actionName = UIAlertAction(title: Utils.localizedString(forKey: Keys.name), style: .default, handler: { (action) in
            self.isAgeSelected = false
            self.setOptionsForFilter()
        })
        
        if self.isAgeSelected != nil && self.isAgeSelected == false {
            actionName.setValue(UIImage(named: "Selected"), forKey: "image")
        }
        alert?.addAction(actionName)
        
        if let alert = alert {
            present(alert, animated: false, completion: nil)
        }
    }
    

    private func setOptionsForFilter() {
        alert = UIAlertController(title: Utils.localizedString(forKey: Keys.select_order), message: "", preferredStyle: .alert)
        
        //Cancel Action
        let actionCanel = UIAlertAction(title: Utils.localizedString(forKey: Keys.cancel), style: .cancel, handler: nil)
        alert?.addAction(actionCanel)
        
        //Ascending
        let actionAscending = UIAlertAction(title: Utils.localizedString(forKey: Keys.ascending), style: .default, handler: { (action) in
            self.ascending = true
            self.sortList()
        })
        
        /*if self.ascending != nil && self.ascending == true {
            actionAscending.setValue(UIImage(named: "Selected"), forKey: "image")
        }*/
        alert?.addAction(actionAscending)
        
        //Descending
        let actionDescending = UIAlertAction(title: Utils.localizedString(forKey: Keys.descending), style: .default, handler: { (action) in
            self.ascending = false
            self.sortList()
        })
        /*if self.ascending != nil && self.ascending == false {
            actionDescending.setValue(UIImage(named: "Selected"), forKey: "image")
        }*/
        alert?.addAction(actionDescending)
        
        if let alert = alert {
            present(alert, animated: false, completion: nil)
        }
    }
    
    //MARK:- Sort List by Member Name and age Name
    fileprivate func sortList() {
        
        if (ascending != nil && self.isAgeSelected != nil) && (members.count > 0) {
            var sortListMembers: [Member] = []
            
            if (isAgeSelected == true && ascending == true) {
                sortListMembers = members.sorted(by: { (A, B) -> Bool in
                    if (A.age < B.age) {
                        return true
                    }
                    else {
                        return false
                    }
                })
            }
            
            else if (isAgeSelected == false && ascending == true) {
                sortListMembers = members.sorted(by: { (A, B) -> Bool in
                    if (A.firstName != nil && B.firstName != nil) && (A.firstName! < B.firstName!) {
                        return true
                    }
                    else {
                        return false
                    }
                })
            }
                
            else if (isAgeSelected == true && ascending == false) {
                sortListMembers = members.sorted(by: { (A, B) -> Bool in
                    if (A.age > B.age) {
                        return true
                    }
                    else {
                        return false
                    }
                })
            }
            
            else if (isAgeSelected == false && ascending == false) {
                sortListMembers = members.sorted(by: { (A, B) -> Bool in
                    if (A.firstName != nil && B.firstName != nil) && (A.firstName! > B.firstName!) {
                        return true
                    }
                    else {
                        return false
                    }
                })
            }
            
            self.members = sortListMembers
            tableViewMember.reloadData()
        }
        
        else {
            //Can't sort
        }
    }
    
    fileprivate func fetchAllMembers(companyId: String) {
        members = DBService.sharedInstance.fetchAllMembers(companyId: companyId)
    }
    
    @objc fileprivate func tappedOnFav(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag{
            if let cell = tableViewMember.cellForRow(at: IndexPath(row: tag, section: 0)) as? MemberTableViewCell {
                if  members.count > 0 {
                    members[tag].isFav = !(members[tag].isFav)
                    DBService.sharedInstance.saveContext()
                    if (members[tag].isFav == true) {
                        cell.btnFav.setImage(UIImage(named: "Fav"), for: .normal)
                    }
                    else {
                        cell.btnFav.setImage(UIImage(named: "UnFav"), for: .normal)
                    }
                }
            }
        }
    }
    
    @objc fileprivate func tappedOnPhone(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            if let url = URL(string: "tel://\(members[tag].phone ?? "")") {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    fileprivate func searchByName(name: String) {
        if (members.count > 0) {
            var memberSearch: [Member] = []
            memberSearch = members.filter({ (listItem) -> Bool in
                if (listItem.firstName?.localizedCaseInsensitiveContains(name) == true || listItem.lastName?.localizedCaseInsensitiveContains(name) == true)
                {
                    return true
                }
                
                else {
                    return false
                }
            })
            members = memberSearch
            
            if ((members.count) > 0) {
                labelNoDataAvailable.isHidden = true
            }
            else {
                labelNoDataAvailable.isHidden = false
            }
            tableViewMember.reloadData()
        }
    }
    
    private func searchMemberByName(text: String?) {
        members = DBService.sharedInstance.fetchAllMembers(companyId: company?.id)
        
        if let searchBarText = searchBar.text, searchBarText != "" {
            isSearchEnabled = true
            searchByName(name: searchBarText)
        }
        
        else {
            labelNoDataAvailable.isHidden = true
            isSearchEnabled = false
            tableViewMember.reloadData()
        }
        searchBar.resignFirstResponder()
    }
}

//MARK:- Search bar delegate
extension MemberViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchMemberByName(text: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchMemberByName(text: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            searchMemberByName(text: nil)
        }
    }
}

extension MemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MemberTableViewCell") as? MemberTableViewCell
         if (nil == cell) {
             let nib:Array = Bundle.main.loadNibNamed("MemberTableViewCell", owner: self, options: nil)!
             cell = nib[0] as? MemberTableViewCell
         }
         
         cell?.selectionStyle = .none
         cell?.btnFav.tag = indexPath.row
         let TGesFav = UITapGestureRecognizer(target: self, action: #selector(tappedOnFav))
         cell?.btnFav.addGestureRecognizer(TGesFav);
        
         cell?.btnPhone.tag = indexPath.row
         let TGPhone = UITapGestureRecognizer(target: self, action: #selector(tappedOnPhone))
         cell?.btnPhone.addGestureRecognizer(TGPhone);
        
         cell?.populateData(member: members[indexPath.row])
         return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = 100
        return UITableView.automaticDimension
    }
}
