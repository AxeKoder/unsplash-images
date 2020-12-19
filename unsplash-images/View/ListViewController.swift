//
//  ListViewController.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/17.
//

import UIKit

class ListViewController: UIViewController {
    static let idSegueDetail = "IdSegueDetail"

    @IBOutlet weak var tableView: UITableView!
    var cellData: [ListImageCell.CellData] = []
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        callListApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 1.0
    }
    
    func callListApi(listModel: ImageListModel = ImageListModel()) {
        listModel.getImageList(page: currentPage, completion: { [weak self] in
            switch $0 {
            case .success(let images):
                self?.cellData.append(contentsOf: listModel.parseImageList(images: images))
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }

    
    // MARK: - Navigation

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
}

extension ListViewController: PresentedViewControllerDelegate {
    func presentedBeingDismissed(indexPath: IndexPath) {
        tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListImageCell.identifier) as! ListImageCell
        cell.setData(index: indexPath.row, data: cellData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = cellData[indexPath.row]
        let height = CGFloat(item.height) / CGFloat(item.width) * tableView.frame.width
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = cellData.count - 1
        if indexPath.row == lastIndex {
            currentPage += 1
            callListApi()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
        }, completion: { [weak self, cellData] _ in
            let model = ImageListModel()
            let detailCellData = model.parseToDetail(images: cellData)
            let detailViewData = (index: indexPath.row, listData: detailCellData)
            self?.performSegue(withIdentifier: ListViewController.idSegueDetail, sender: detailViewData)
        })
        
        
    }
}
