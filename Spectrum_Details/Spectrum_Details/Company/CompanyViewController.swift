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
    
    var listCompanies: [CompanyModel]?
    var viewModel: CompanyViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgressIndicator(view: self.view)
        viewModel = CompanyViewModel()
        viewModel?.delegate = self
        viewModel?.fetchCompaniesList()
        setupTableView()
    }
    
    fileprivate func setupTableView() {
        tableViewCompanyList.separatorStyle = .none
        tableViewCompanyList.delegate = self
        tableViewCompanyList.dataSource = self
        tableViewCompanyList.tableFooterView = UIView()
    }
    
    fileprivate func showHideListView(isHide: Bool) {
        tableViewCompanyList.isHidden = isHide
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = Utils.localizedString(forKey: Keys.companies)
    }
}

//MARK:- Delegate and Datasource Company data
extension CompanyViewController: getCompaniesListDelegate {
    func success(value: Bool, data: [CompanyModel]) {
        if value {
            self.listCompanies = data
            tableViewCompanyList.reloadData()
        }
        hideProgressIndicator(view: self.view)
    }
    
    func failure(error: String) {
        hideProgressIndicator(view: self.view)
        Utils.showAlert(AlertTitle: error, AlertMessage: "", controller: self)
    }
}

//MARK:- Table view delegate and datasource
extension CompanyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.listCompanies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "CompanyTableViewCell") as? CompanyTableViewCell
        if (nil == cell) {
            let nib:Array = Bundle.main.loadNibNamed("CompanyTableViewCell", owner: self, options: nil)!
            cell = nib[0] as? CompanyTableViewCell
        }
        
        cell?.selectionStyle = .none
        cell?.populateData(data: listCompanies?[indexPath.row])
        cell?.companyLinkButtom.tag = indexPath.row
        cell?.btnFav.tag = indexPath.row
        cell?.btnFollow.tag = indexPath.row
        
        let TGes = UITapGestureRecognizer(target: self, action: #selector(tappedOnLink))
        cell?.companyLinkButtom.addGestureRecognizer(TGes);

        let TGesFav = UITapGestureRecognizer(target: self, action: #selector(tappedOnFav))
        cell?.btnFav.addGestureRecognizer(TGesFav);
        
        let TGesFollow = UITapGestureRecognizer(target: self, action: #selector(tappedOnFollow))
        cell?.btnFollow.addGestureRecognizer(TGesFollow);
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        debugPrint(indexPath.row)
    }
    
    @objc fileprivate func tappedOnLink(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag, let linkURL = listCompanies?[tag] {
            if let url = URL(string: linkURL.website), UIApplication.shared.canOpenURL(url)  {
                let openLinkVC = SFSafariViewController(url: url)
                self.navigationController?.show(openLinkVC, sender: nil)
            }
        }
    }
    
    @objc fileprivate func tappedOnFav(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag, listCompanies != nil {
            if let cell = tableViewCompanyList.cellForRow(at: IndexPath(row: tag, section: 0)) as? CompanyTableViewCell {
                
                listCompanies![tag].isFav = !(listCompanies![tag].isFav)
                
                DBService.sharedInstance.markFavAndUnFavCompany(companyId: listCompanies![tag].id ,isFav: listCompanies![tag].isFav )
                
                if (listCompanies![tag].isFav == true) {
                    cell.btnFav.setImage(UIImage(named: "Fav"), for: .normal)
                }
                
                else {
                    cell.btnFav.setImage(UIImage(named: "UnFav"), for: .normal)
                }
            }
        }
    }
    
    @objc fileprivate func tappedOnFollow(sender: UITapGestureRecognizer) {
        if let tag = sender.view?.tag, listCompanies != nil {
            if let cell = tableViewCompanyList.cellForRow(at: IndexPath(row: tag, section: 0)) as? CompanyTableViewCell {
                
                listCompanies![tag].isFollowed = !(listCompanies![tag].isFollowed)
                
                DBService.sharedInstance.markFollowAndUnFollowCompany(companyId: listCompanies![tag].id ,isFollow: listCompanies![tag].isFollowed)
                
                if (listCompanies![tag].isFollowed == true) {
                    cell.btnFollow.setImage(UIImage(named: "Follow"), for: .normal)
                }
                
                else {
                    cell.btnFollow.setImage(UIImage(named: "UnFollow"), for: .normal)
                }
            }
        }
    }
}
