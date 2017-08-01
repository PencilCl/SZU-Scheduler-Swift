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

    var moduleList: [Module] = []
//    [
//        Module(name: "Blackboard", color: 0x9ccc65, show: true),
//        Module(name: "图书馆", color: 0xff7043, show: true),
//        Module(name: "Gobye", color: 0x29b6f6, show: true),
//        Module(name: "课程表", color: 0x5c6bc0, show: true)
//    ]
    
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
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moduleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = moduleCollectionView.dequeueReusableCell(withReuseIdentifier: "module", for: indexPath) as! ModuleCollectionViewCell
        cell.delegate = self
        cell.module = moduleList[indexPath.row]
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier,
            identifier == "moduleControl" {
            let moduleControlVC = segue.destination as! ModuleControlViewController
            moduleControlVC.module = moduleList
        }
    }
    
}
