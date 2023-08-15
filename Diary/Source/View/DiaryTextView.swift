//  Diary - DiaryTextView.swift
//  Created by Ayaan, zhilly on 2022/12/23

import UIKit.UITextView

final class DiaryTextView: UITextView {
    
    init(font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor) {
        super.init(frame: .zero, textContainer: nil)
        self.font = font
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.alwaysBounceVertical = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupAttributeString() {
        let text: String = self.text
        var content: [String] = text.split(separator: "\n").map { String($0) }
        var title: String = .init()
        var body: String = .init()
        
        if !text.isEmpty {
            title = content.removeFirst()
            body = content.joined()
        }
        
        let titleFontSize: UIFont = UIFont.systemFont(ofSize: 30)
        let bodyFontSize: UIFont = UIFont.systemFont(ofSize: 20)
        let attributedString: NSMutableAttributedString = .init(
            string: text,
            attributes: [.foregroundColor: UIColor.getTextColor()]
        )
        
        attributedString.addAttribute(.font,
                                      value: titleFontSize,
                                      range: (text as NSString).range(of: title))
        attributedString.addAttribute(.font,
                                      value: bodyFontSize,
                                      range: (text as NSString).range(of: body))
        
        self.attributedText = attributedString
    }
}
