//
//  ModuleCollectionViewCell.swift
//  SZU Scheduler
//
//  Created by 陈林 on 24/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

public protocol ModuleCollectionViewCellDelegate {
    func click(on item: Module?)
}

class ModuleCollectionViewCell: UICollectionViewCell {
    var delegate: ModuleCollectionViewCellDelegate?
    
    var module: Module? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var moduleNameButton: UIButton! {
        didSet {
            layer.cornerRadius = 8;
        }
    }
    
    @IBAction func click(_ sender: UIButton) {
        if let delegate = delegate {
            delegate.click(on: module)
        }
    }
    
    private func updateUI() {
        if let module = module {
            moduleNameButton.setTitle(module.name, for: .normal)
            self.backgroundColor = module.color
        }
    }
}
