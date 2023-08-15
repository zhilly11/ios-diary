//  Diary - ExitAlert.swift
//  Created by Ayaan, zhilly on 2023/01/02

import UIKit

final class ExitAlert: UIAlertController {
    private let confirmAction: UIAlertAction = .init(title: "확인", style: .cancel) { _ in
        exit(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addAction(confirmAction)
    }
}
