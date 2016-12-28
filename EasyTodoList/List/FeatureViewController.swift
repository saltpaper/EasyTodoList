//
//  FeatureViewController.swift
//  EasyTodoList
//
//  Created by DJ on 20/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

class FeatureViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var collectionView:UICollectionView!
    var selectedColor: String?
    var selectedColorBlock : ((_ colorString:String)->())?

    lazy var dimBackgroundView: UIView = {
        let view: UIView = UIView (frame: CGRect (x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height))
        view.backgroundColor = UIColor (white: 0, alpha: 0.4)
        
        // add gesture
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer (target: self, action: #selector(clickedBgViewHandler))
        view.addGestureRecognizer(tapGR)
        return view
    }()

    let colorArray = [TODO_Constant.kBgGreen,TODO_Constant.kBgBlue,TODO_Constant.kBgRed,TODO_Constant.kBgOrage,TODO_Constant.kBgYellow,TODO_Constant.kBgGray,TODO_Constant.kBgBrown,TODO_Constant.kBgWhite] // use to set task's tag color

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(dimBackgroundView)

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15)
        flowLayout.itemSize = CGSize.init(width: 60, height: 60)
        flowLayout.minimumInteritemSpacing = 15
        flowLayout.minimumLineSpacing = 15
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        self.collectionView?.register(UINib(nibName: "ColorCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ColorCollectionViewCell")
        
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.view.addSubview(self.collectionView)
    }

    //MARK:UICollectionView Delegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as? ColorCollectionViewCell
        cell?.contentView.backgroundColor = UIColor.init(rgba: colorArray[indexPath.item])
        if let _selectedColor = selectedColor, _selectedColor == colorArray[indexPath.item] {
            cell?.isSelected = true
        }else {
            cell?.isSelected = false
        }
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColorBlock?(colorArray[indexPath.item])
        self.dismiss(animated: true, completion: nil)
    }

    

    func clickedBgViewHandler() {
        self.dismiss(animated: true, completion: nil)
    }

}
