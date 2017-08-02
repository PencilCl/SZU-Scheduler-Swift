//
//  HomeViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 24/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout,
    ModuleCollectionViewCellDelegate {

    var moduleList: [Module] {
        get {
            return ModuleService.moduleList
        }
    }
    
    @IBOutlet weak var moduleCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false // remove blank area from UICollectionView
        
        moduleCollectionView.delegate = self
        moduleCollectionView.dataSource = self
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        // 设置导航栏返回按钮文本为“返回”
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.showHireLine()
        navigationController?.navigationBar.barTintColor = 0x5677FC.uiColor
        
        moduleCollectionView.reloadData()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var number = 0
        moduleList.forEach { module in
            if module.show {
                number += 1
            }
        }
        return number
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moduleCollectionView.dequeueReusableCell(withReuseIdentifier: "module", for: indexPath) as! ModuleCollectionViewCell
        cell.delegate = self
        
        var count = 0
        for i in 0..<moduleList.count {
            if moduleList[i].show {
                if count == indexPath.row {
                    cell.module = moduleList[i]
                    break
                }
                count += 1
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = moduleCollectionView.frame.size.width / 2 - 20
        return CGSize(width: width, height: width)
    }
    
    func click(on item: Module?) {
        if let module = item {
            switch module.name! {
            case "Blackboard":
                self.navigationController?.pushViewController((storyboard?.instantiateViewController(withIdentifier: "blackboard"))!, animated: true)
            case "图书馆":
                self.navigationController?.pushViewController((storyboard?.instantiateViewController(withIdentifier: "library"))!, animated: true)
            case "Gobye":
                self.navigationController?.pushViewController((storyboard?.instantiateViewController(withIdentifier: "gobye"))!, animated: true)
            case "课程表":
                self.navigationController?.pushViewController((storyboard?.instantiateViewController(withIdentifier: "curriculum"))!, animated: true)
            default:
                break
            }
        }
    }
    
}
