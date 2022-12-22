//  Diary - DiaryViewController.swift
//  Created by Ayaan, zhilly on 2022/12/21

import UIKit

final class DiaryViewController: UIViewController {
    private let diaryView = DiaryView(frame: .zero)
    private var diary: Diary

    init(diary: Diary) {
        self.diary = diary
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.diary = Diary()
        super.init(coder: coder)
    }
    
    override func loadView() {
        super.loadView()
        self.view = diaryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        diaryView.setupScrollViewDelegate(scrollViewDelegate: self)
        diaryView.setupBodyTextViewDelegate(textViewDelegate: self)
    }
    
    private func configure() {
        title = diary.date
        diaryView.setupData(of: diary)
    }
}

extension DiaryViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        if velocity.y < -2 {
            diaryView.endEditing(true)
        }
    }
}

extension DiaryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .systemGray3 {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.hasText == false {
            textView.text = "내용"
            textView.textColor = .systemGray3
        }
    }
}
