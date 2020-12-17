//
//  ListViewController.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/17.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var cellData: [ListImageCell.Data] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        callListApi()
    }
    
    func callListApi(listModel: ImageListModel = ImageListModel()) {
        listModel.getImageList(completion: { [weak self] in
            switch $0 {
            case .success(let images):
                self?.cellData = listModel.parseImageList(images: images)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListImageCell.identifier) as! ListImageCell
        cell.setData(data: cellData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = cellData[indexPath.row]
        let height = CGFloat(item.height) / CGFloat(item.width) * tableView.frame.width
        return height
    }
}
