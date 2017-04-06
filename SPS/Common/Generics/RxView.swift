//
//  RxView.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 30/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit
import RxSwift

class RxView: UIView {
    private(set) var disposeBag: DisposeBag! = DisposeBag()
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        disposeBag = nil
    }
}
