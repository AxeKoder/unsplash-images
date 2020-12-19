//
//  DetailViewController.swift
//  unsplash-images
//
//  Created by Daeho Park on 2020/12/19.
//

import UIKit

protocol PresentedViewControllerDelegate {
    func presentedBeingDismissed(indexPath: IndexPath, cellData: [ListImageCell.CellData])
}

class DetailViewController: UIViewController {
    typealias DetailData = (index: Int, page: Int, listData: [DetailImageCell.CellData])

    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex: Int = 0
    var currentPage: Int = 0
    var currentIndexPath: IndexPath = IndexPath()
    var cellData: [DetailImageCell.CellData] = []
    var isScrollDone = false
    var delegate: PresentedViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        view.alpha = 0
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.collectionViewLayout = flowLayout
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let model = ImageListModel()
        delegate?.presentedBeingDismissed(indexPath: currentIndexPath, cellData: model.parseToList(images: cellData))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateFadeIn()
    }
    
    func animateFadeIn() {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.view.alpha = 1.0
        })
    }
    
    func setData(_ data: DetailData) {
        selectedIndex = data.index
        cellData = data.listData
        currentPage = data.page
    }
    
    func callListApi(listModel: ImageListModel = ImageListModel()) {
        listModel.getImageList(page: currentPage, completion: { [weak self] in
            switch $0 {
            case .success(let images):
                self?.cellData.append(contentsOf: listModel.parseImageDetail(images: images))
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        })
    }
    
    @IBAction func onBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailImageCell.identifier, for: indexPath) as! DetailImageCell
        cell.setData(index: indexPath.row, data: cellData[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if !isScrollDone {
            collectionView.scrollToItem(at: IndexPath(row: selectedIndex, section: 0), at: .centeredVertically, animated: false)
            isScrollDone = true
        }
        if indexPath.row == cellData.count - 1 {
            currentPage += 1
            callListApi()
        }
        currentIndexPath = indexPath
    }
}
