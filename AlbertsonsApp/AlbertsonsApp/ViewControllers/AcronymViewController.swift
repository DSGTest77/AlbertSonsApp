//
//  ViewController.swift
//  AlbertsonsApp
//
//  Created by Yashwanth Adirala on 5/23/22.
//

import UIKit

class AcronymViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var acronymTableView: UITableView!
    @IBOutlet weak var acronymSearchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var viewModel = AcronymViewModel(network: NetworkManager())
    
    override func viewDidLoad() {
        super.viewDidLoad()
       activityIndicator.isHidden = true
    }
    
    private func getAcronymData(acronym: String) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        self.viewModel.searchAcronym(acronym: acronym) { [weak self] error in
            if error != nil {
                self?.showError(title: "Data Not Found", message: "Please try again")
            } else {
                self?.reloadUI()
            }
        }
    }
    private func reloadUI() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
            self.acronymTableView.reloadData()
        }
    }
    
    private func showError(title: String, message: String) {
        DispatchQueue.main.async { let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Thanks", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension AcronymViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "acronymCell") as? AcronymCell else {
            return UITableViewCell()
        }
        cell.acronymLbl.text = self.viewModel.acronymText(for: indexPath.row)
        return cell
    }
}

extension AcronymViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let acronym = searchBar.text, !acronym.isEmpty else {
            showError(title: "Input Cannot be Empty", message: "Please try again")
            return
            
        }
        self.getAcronymData(acronym: acronym)
        acronymSearchBar.resignFirstResponder()
      }
}
