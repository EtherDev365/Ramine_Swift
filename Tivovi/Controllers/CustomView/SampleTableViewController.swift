/**
 *  https://github.com/tadija/AEAccordion
 *  Copyright (c) Marko Tadić 2015-2018
 *  Licensed under the MIT license. See LICENSE file.
 */

import AEAccordion

final class SampleTableViewController: AccordionTableViewController {
    
    @IBOutlet weak var btnSearch: UIButton!
    // MARK: Properties

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableNew: UITableView!
    @IBOutlet weak var tableView1: UITableView!
    private let days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnSearch.layer.cornerRadius = 5
        //self.navigationController?.navigationBar.isHidden = true
        self.loadXibOne(SView: self.headerView, value: self.navigationController!)
        //self.loadXibOne(SView: headerView, value: self.navigationController!)
        self.btnSearch.layer.cornerRadius = 5
        self.tabBarController?.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: (self.tabBarController?.tabBar.frame.width)!/CGFloat((self.tabBarController?.tabBar.items!.count)!), height: (self.tabBarController?.tabBar.frame.height)!), lineHeight: 2.0)
        registerCell()
        expandFirstCell()
    }
    
    // MARK: Helpers
    
    func registerCell() {
        let cellNib = UINib(nibName: SampleTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: SampleTableViewCell.reuseIdentifier)
       
    }
    
    func expandFirstCell() {
        let firstCellIndexPath = IndexPath(row: 0, section: 0)
        expandedIndexPaths.append(firstCellIndexPath)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SampleTableViewCell.reuseIdentifier, for: indexPath)
        
        if let cell = cell as? SampleTableViewCell {
            cell.day.text = days[indexPath.row]
            cell.weatherIcon.image = UIImage(named: "0\(indexPath.row + 1)")
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 200.0 : 50.0
    }

}
