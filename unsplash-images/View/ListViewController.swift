//
//  ListViewController.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/17.
//

import UIKit

class ListViewController: UIViewController {
    static let idSegueDetail = "IdSegueDetail"
    
    struct Constant {
        static let dimAnimateDuration: TimeInterval = 0.3
        static let dimScreenAlpha: CGFloat = 0.7
        static let tableViewAnimateDuration: TimeInterval = 0.2
        static let defaultCellHeight: CGFloat = 100.0
    }
    
    @IBOutlet weak var listTableView: UITableView!
    @IBOutlet weak var searchTableView: UITableView!
    
    var cellData: [ListImageCell.CellData] = []
    var searchCellData: [ListImageCell.CellData] = []
    var currentListPage: Int = 0
    var currentSearchPage: Int = 0
    var currentQuery: String?
    var totalPagesCount: Int = 0
    var currentTable: UITableView!
    let searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Search photos"
        return search
    }()
    
    let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        listTableView.delegate = self
        listTableView.dataSource = self
        searchTableView.delegate = self
        searchTableView.dataSource = self
        currentTable = listTableView
        
        initUI()
        callListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initUI() {
        view.alpha = 1.0
        view.addSubview(dimmedView)
        dimmedView.translatesAutoresizingMaskIntoConstraints = false
        dimmedView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dimmedView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        dimmedView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        dimmedView.isHidden = true
        
        navigationItem.titleView = searchController.searchBar
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    func callListApi(listModel: ImageListModel = ImageListModel()) {
        currentListPage += 1
        listModel.getImageList(page: currentListPage, completion: { [weak self] in
            switch $0 {
            case .success(let images):
                self?.cellData.append(contentsOf: listModel.parseImageList(images: images))
                DispatchQueue.main.async {
                    self?.listTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func callSearchApi(
        listModel: ImageListModel = ImageListModel(),
        query: String?
    ) {
        currentSearchPage += 1
        currentQuery = query
        listModel.getSearchList(page: currentSearchPage, query: query ?? "") { [weak self] in
            self?.hideDimmed()
            switch $0 {
            case .success(let result):
                self?.searchCellData.append(contentsOf: listModel.parseSearchResultList(result: result))
                self?.totalPagesCount = listModel.parseSearchResultTotalPages(result: result)
                DispatchQueue.main.async {
                    if self?.searchTableView.isHidden == true {
                        self?.listTableView.isHidden = true
                        self?.searchTableView.isHidden = false
                    }
                    self?.searchTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == ListViewController.idSegueDetail {
            
            let detailView = segue.destination as! DetailViewController
            detailView.modalPresentationStyle = .overFullScreen
            detailView.modalTransitionStyle = .crossDissolve
            detailView.delegate = self
            if let data = sender as? DetailViewController.DetailData {
                detailView.setData(data)
            }
        }
    }
    
    func showDimmed() {
        DispatchQueue.main.async { [weak self] in
            guard let dim = self?.dimmedView else { return }
            dim.alpha = 0
            self?.view.bringSubviewToFront(dim)
            dim.isHidden = false
            UIView.animate(withDuration: Constant.dimAnimateDuration, animations: {
                self?.dimmedView.alpha = Constant.dimScreenAlpha
            })
        }
        
    }
    
    func hideDimmed() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: Constant.dimAnimateDuration, animations: {
                self?.dimmedView.alpha = 0
            }, completion: { [weak self] _ in
                self?.dimmedView.isHidden = true
            })
        }
    }
}

extension ListViewController: PresentedViewControllerDelegate {
    func presentedBeingDismissed(indexPath: IndexPath, cellData: [ListImageCell.CellData]) {
        if currentTable == listTableView {
            self.cellData = cellData
        } else {
            self.searchCellData = cellData
        }
        currentTable.reloadData()
        DispatchQueue.main.async { [weak self] in
            self?.currentTable.scrollToRow(at: indexPath, at: .middle, animated: false)
        }
    }
}

extension ListViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        showDimmed()
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        hideDimmed()
        currentTable = listTableView
        listTableView.isHidden = false
        searchTableView.isHidden = true
        searchCellData.removeAll()
        searchTableView.reloadData()
        searchTableView.setContentOffset(CGPoint.zero, animated: false)
        currentSearchPage = 0
        
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        currentTable = searchTableView
        searchCellData.removeAll()
        searchTableView.reloadData()
        searchTableView.setContentOffset(CGPoint.zero, animated: false)
        callSearchApi(query: searchBar.text)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCurrentData().count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListImageCell.identifier) as! ListImageCell
        let data = getCurrentData()
        let rowData = data[safe: indexPath.row]
        cell.setData(index: indexPath.row, data: rowData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let safeItem = getCurrentData()[safe: indexPath.row]
        guard let item = safeItem else { return Constant.defaultCellHeight }
        let height = CGFloat(item.height) / CGFloat(item.width) * tableView.frame.width
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let data = getCurrentData()
        let lastIndex = data.count - 1
        if tableView.contentOffset.y > 0 && indexPath.row == lastIndex {
            if tableView == listTableView {
                callListApi()
            } else if tableView == searchTableView, currentSearchPage < totalPagesCount {
                callSearchApi(query: searchController.searchBar.text)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTable = tableView
        let data = getCurrentData()
        let model = ImageListModel()
        let detailCellData = model.parseToDetail(images: data)
        let currentPageIndex = getCurrentPageIndex()
        let detailViewData = (type: getCurrentType(), index: indexPath.row, page: currentPageIndex, totalPagesCount: totalPagesCount, query: currentQuery, listData: detailCellData)

        UIView.animate(withDuration: Constant.tableViewAnimateDuration, animations: {
            tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }, completion: { [weak self] _ in
            self?.performSegue(withIdentifier: ListViewController.idSegueDetail, sender: detailViewData)
        })
    }
    
    func getCurrentData() -> [ListImageCell.CellData] {
        if currentTable == listTableView {
            return cellData
        } else {
            return searchCellData
        }
    }
    
    func getCurrentPageIndex() -> Int {
        if currentTable == listTableView {
            return currentListPage
        } else {
            return currentSearchPage
        }
    }
    
    func getCurrentType() -> DetailShowType {
        if currentTable == listTableView {
            return .list
        } else {
            return .search
        }
    }
}
