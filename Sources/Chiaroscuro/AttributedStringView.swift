import Foundation
import SwiftUI
import UIKit

public struct AttributedStringView: UIViewRepresentable {
    public let attributedText: NSAttributedString

    public init(attributedText: NSAttributedString) {
        self.attributedText = attributedText
    }

    public typealias UIViewType = UITextView

    public func makeUIView(context _: Context) -> UITextView {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.attributedText = attributedText
        textView.backgroundColor = .clear
        textView.contentInset = .zero
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.adjustsFontForContentSizeCategory = true
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }

    public func updateUIView(_ textView: UITextView, context _: Context) {
        if !textView.attributedText.isEqual(to: attributedText) {
            textView.attributedText = attributedText
        }
    }
}
