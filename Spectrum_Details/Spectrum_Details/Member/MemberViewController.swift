//
//  MemberViewController.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 25/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController {

    var company: Company?
    var members: [Member] = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewMember: UITableView!
    @IBOutlet weak var labelNoDataAvailable: UILabel!
    
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
        self.title = Utils.localizedString(forKey: Keys.members) + " " + ( company?.name ?? "")
    }
    
    fileprivate func fetchAllMembers(companyId: String) {
        members = DBService.sharedInstance.fetchAllMembers(companyId: companyId)
    }
}

//MARK:- Search bar delegate
extension MemberViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text, searchBarText != "" {
            
        }
        else {
            labelNoDataAvailable.isHidden = true
        }
        searchBar.resignFirstResponder()
    }
}

extension MemberViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = 100
        return UITableView.automaticDimension
    }
}
