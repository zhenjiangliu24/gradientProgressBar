//
//  ViewController.swift
//  GradientProgressBar
//
//  Created by Zhenjiang Liu on 2018-08-21.
//  Copyright © 2018 zhenjiang. All rights reserved.
//

import UIKit

protocol ProgressChangable: class {
    func progressDidChange(progress: Float)
}

protocol Progress {
    var progress: Float { get set }
}

class TestModel: Progress {
    var progress: Float = 0
    weak var delegate: ProgressChangable?
    
    private var timer: Timer? = nil
    func incrementProgress() {
        if (timer == nil) {
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
                guard let weakSelf = self else { return }
                weakSelf.progress += 0.01
                if (weakSelf.progress >= 1) {
                    weakSelf.progress = 0
                }
                weakSelf.delegate?.progressDidChange(progress: weakSelf.progress)
            })
        }
    }
    
    func stopIncrement() {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
}

class ViewController: UIViewController, ProgressChangable {

    // MARK: - Outlets
    @IBOutlet weak var switchTitle: UILabel!
    @IBOutlet weak var progressSwitch: UISwitch!
    @IBOutlet weak var progressBar: GradientProgressBar!
    
    // MARK: - Actions
    @IBAction func switchChanged(_ sender: UISwitch) {
        if (sender.isOn) {
            model.incrementProgress()
        } else {
            model.stopIncrement()
        }
    }
    
    var model: TestModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model = TestModel()
        model.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.incrementProgress()
    }


    // MARK: - ProgressChangable
    func progressDidChange(progress: Float) {
        progressBar.progress = progress
    }
}

