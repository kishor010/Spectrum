//
//  CompanyViewController.swift
//  Spectrum_Details
//
//  Created by Kishor Pahalwani on 25/01/20.
//  Copyright © 2020 Kishor Pahalwani. All rights reserved.
//

import UIKit
import SafariServices

class CompanyViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewCompanyList: UITableView!
    @IBOutlet weak var labelNoDataAvailable: UILabel!
    
    var listCompanies: [Company]?
    var viewModel: CompanyViewModel?
    var ascending: Bool?
    var alert: UIAlertController?
    var isSearchEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgressIndicator(view: self.view)
        fetchListOfCompanies()
        setupTableView()
        searchBar.delegate = self
        labelNoDataAvailable.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    fileprivate func setupTableView() {
        tableViewCompanyList.separatorStyle = .none
        tableViewCompanyList.delegate = self
        tableViewCompanyList.dataSource = self
        tableViewCompanyList.tableFooterView = UIView()
    }
    
    fileprivate func fetchListOfCompanies() {
        viewModel = CompanyViewModel()
        viewModel?.delegate = self
        viewModel?.fetchCompaniesList()
    }
    
    private func setupNavigationBar() {
        self.title = Utils.localizedString(forKey: Keys.companies)
        let rightButtonItem = UIBarButtonItem(image: UIImage(named: "Filter"), style: .plain, target: self, action: #selector(filterTapped))
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    @objc fileprivate func filterTapped(sender: UIBarButtonItem) {
        setOptionsForFilter()
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
        
        if self.ascending != nil && self.ascending == true {
            actionAscending.setValue(UIImage(named: "Selected"), forKey: "image")
        }
        
        //action.setValue(UIImage(named: "Filter"), forKey: "image")
        alert?.addAction(actionAscending)
        
        //Descending
        let actionDescending = UIAlertAction(title: Utils.localizedString(forKey: Keys.descending), style: .default, handler: { (action) in
            self.ascending = false
            self.sortList()
        })
        if self.ascending != nil && self.ascending == false {
            actionDescending.setValue(UIImage(named: "Selected"), forKey: "image")
        }
        alert?.addAction(actionDescending)
        
        if let alert = alert {
            present(alert, animated: false, completion: nil)
        }
    }
    
    //MARK:- Sort List by Company Name
    fileprivate func sortList() {
        if (ascending != nil) && (listCompanies != nil) && (listCompanies!.count > 0) {
            var sortListCompanies: [Company]? = []
            if (ascending == true) {
                sortListCompanies = listCompanies?.sorted(by: { (A, B) -> Bool in
                    if (A.name != nil && B.name != nil) && (A.name! < B.name!) {
                        return true
                    }
                    else {
                        return false
                    }
                })
            }
            
            else {
                sortListCompanies = listCompanies?.sorted(by: { (A, B) -> Bool in
                    if (A.name != nil && B.name != nil) && (A.name! > B.name!) {
                        return true
                    }
                    else {
                        return false
                    }
                })
            }
            listCompanies = sortListCompanies
            tableViewCompanyList.reloadData()
        }
        
        else {
            //Can't sort
        }
    }
}

//MARK:- Delegate and Datasource Company data
extension CompanyViewController: getCompaniesListDelegate {
    func success(value: Bool, data: [CompanyModel]) {
        if value {
            listCompanies = DBService.sharedInstance.fetchAllCompanies()
            tableViewCompanyList.reloadData()
        }
        hideProgressIndicator(view: self.view)
    }
    
    func failure(error: String) {
        hideProgressIndicator(view: self.view)
        listCompanies = DBService.sharedInstance.fetchAllCompanies()
        tableViewCompanyList.reloadData()
        Utils.showAlert(AlertTitle: error, AlertMessage: "", controller: self)
    }
}

//MARK:- Table view delegate and datasource
extension CompanyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listCompanies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableViewCell") as? CompanyTableViewCell
        if (nil == cell) {
            let nib:Array = Bundle.main.loadNibNamed("CompanyTableViewCell", owner: self, options: nil)!
            cell = nib[0] as? CompanyTableViewCell
        }
        
        cell?.selectionStyle = .none
        cell?.companyLinkButtom.tag = indexPath.row
        cell?.btnFav.tag = indexPath.row
        cell?.btnFollow.tag = indexPath.row
        
        let TGes = UITapGestureRecognizer(target: self, action: #selector(tappedOnLink))
        cell?.companyLinkButtom.addGestureRecognizer(TGes);
        let TGesFav = UITapGestureRecognizer(target: self, action: #selector(tappedOnFav))
        cell?.btnFav.addGestureRecognizer(TGesFav);
        let TGesFollow = UITapGestureRecognizer(target: self, action: #selector(tappedOnFollow))
        cell?.btnFollow.addGestureRecognizer(TGesFollow);
        cell?.populateData(data: listCompanies?[indexPath.row])
       
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.rowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        debugPrint(indexPath.row)
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemberViewController") as? MemberViewController {
            vc.company = self.listCompanies?[indexPath.row]
            self.navigationController?.show(vc, sender: nil)
        }
    }
    
    @objc fileprivate func tappedOnLink(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag, let linkURL = listCompanies?[tag] {
            if let url = URL(string: linkURL.website ?? ""), UIApplication.shared.canOpenURL(url)  {
                let openLinkVC = SFSafariViewController(url: url)
                self.navigationController?.show(openLinkVC, sender: nil)
            }
        }
    }
    
    @objc fileprivate func tappedOnFav(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag{
            if let cell = tableViewCompanyList.cellForRow(at: IndexPath(row: tag, section: 0)) as? CompanyTableViewCell {
                if  listCompanies != nil {
                    listCompanies![tag].isFav = !(listCompanies![tag].isFav)
                    DBService.sharedInstance.saveContext()
                    if (listCompanies![tag].isFav == true) {
                        cell.btnFav.setImage(UIImage(named: "Fav"), for: .normal)
                    }
                    else {
                        cell.btnFav.setImage(UIImage(named: "UnFav"), for: .normal)
                    }
                }
            }
        }
    }
    
    @objc fileprivate func tappedOnFollow(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag {
            if let cell = tableViewCompanyList.cellForRow(at: IndexPath(row: tag, section: 0)) as? CompanyTableViewCell {
                if  listCompanies != nil {
                    listCompanies![tag].isFollow = !(listCompanies![tag].isFollow)
                    DBService.sharedInstance.saveContext()
                    if (listCompanies![tag].isFollow == true) {
                        cell.btnFollow.setImage(UIImage(named: "Follow"), for: .normal)
                    }
                    else {
                        cell.btnFollow.setImage(UIImage(named: "UnFollow"), for: .normal)
                    }
                }
            }
        }
    }
    
    fileprivate func searchByName(name: String) {
        if (listCompanies != nil && listCompanies!.count > 0) {
            var searchListCompanies: [Company] = []
            searchListCompanies = listCompanies!.filter({ (listItem) -> Bool in
                if (listItem.name?.localizedCaseInsensitiveContains(name) == true)
                {
                    return true
                }
                
                else {
                    return false
                }
            })
            listCompanies = searchListCompanies
            
            if ((listCompanies!.count) > 0) {
                labelNoDataAvailable.isHidden = true
            }
            else {
                labelNoDataAvailable.isHidden = false
            }
            tableViewCompanyList.reloadData()
        }
    }
    
    private func callSearchBarWithText(text: String?) {
        listCompanies = DBService.sharedInstance.fetchAllCompanies()
        if let searchBarText = text, searchBarText != "" {
            isSearchEnabled = true
            searchByName(name: searchBarText)
        }
        
        else {
            labelNoDataAvailable.isHidden = true
            isSearchEnabled = false
            tableViewCompanyList.reloadData()
        }
        searchBar.resignFirstResponder()
    }
}

//MARK:- Search bar delegate
extension CompanyViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        callSearchBarWithText(text: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        callSearchBarWithText(text: searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            callSearchBarWithText(text: nil)
        }
    }
}
