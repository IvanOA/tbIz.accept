//
//  PasswordViewController.swift
//  Accept
//
//  Created by Волков Никита on 01.04.17.
//  Copyright © 2017 Иван. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{

    @IBOutlet weak var MyCollectionView: UICollectionView!

    var numbers=["1","2","3","4","5","6","7","8","9","","0",""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.MyCollectionView.delegate = self
        self.MyCollectionView.dataSource=self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 11 {
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell_back", for: indexPath) as! MyCollectionViewCell
            cell.frame.size.height = 53
            cell.frame.size.width = 106
            cell.MyImageView.image = UIImage(named: "backspace.png")
            return cell
        }else{
            let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! MyCollectionViewCell
            cell.frame.size.height = 53
            cell.frame.size.width = 106
            cell.MyLabelView.text = numbers[indexPath.row]
            return cell
        }
    }
}

