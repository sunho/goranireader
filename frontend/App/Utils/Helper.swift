import Foundation
import UIKit
import Result
import ReactiveSwift
import Moya
import ReactiveMoya
import RealmSwift
import Kingfisher

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    
    var noon: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)!
    }
    
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var dayRange: Range<Date> {
        return self.startOfDay..<self.endOfDay
    }
    
    func addingDays(_ days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
}

extension UIImage {
    static func imageWithColor(tintColor: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        tintColor.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

private extension Encodable {
    func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}

extension JSONEncoder {
    private struct EncodableWrapper: Encodable {
        let wrapped: Encodable
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try self.wrapped.encode(to: &container)
        }
    }
    
    func encode<Key: Encodable>(_ dictionary: [Key: Encodable]) throws -> Data {
        let wrappedDict = dictionary.mapValues(EncodableWrapper.init(wrapped:))
        return try self.encode(wrappedDict)
    }
}

extension String: Error {}

extension Formatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        let container = try $0.singleValueContainer()
        let string = try container.decode(String.self)
        guard let date = Formatter.iso8601.date(from: string) else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Invalid date: " + string)
        }
        return date
    }
}

extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

extension JSONEncoder.DateEncodingStrategy {
    static let iso8601withFractionalSeconds = custom {
        var container = $1.singleValueContainer()
        try container.encode(Formatter.iso8601.string(from: $0))
    }
}

extension UITextView {
    func makeStaticText() {
        self.backgroundColor = UIColor.clear
        self.textAlignment = NSTextAlignment.justified
        self.isScrollEnabled = false
        self.textContainerInset = .zero
        self.textContainer.lineFragmentPadding = 0
        self.isEditable = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.sizeToFit()
    }
    
}

extension List : Decodable where Element : Decodable {
    public convenience init(from decoder: Decoder) throws {
        self.init()
        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            let element = try container.decode(Element.self)
            self.append(element)
        }
    }
}

extension List : Encodable where Element : Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        for element in self {
            try element.encode(to: container.superEncoder())
        }
    }
}

extension UIEdgeInsets {
    var all: CGFloat {
        set {
            top = newValue
            bottom = newValue
            left = newValue
            right = newValue
        }
        get {
            return 0
        }
    }
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

extension UIStoryboard {
    func createTabViewController() -> UIViewController {
        return instantiateViewController(withIdentifier: "TabViewController")
    }
}

extension String {
    func trimmingSuffix(_ str: String) -> String? {
        if self.hasSuffix(str) {
            return self.trimming(str.count)
        }
        return nil
    }
    
    func trimming(_ n: Int) -> String {
        return String(self.prefix(self.count - n))
    }
    
    func charAtBack(_ i: Int) -> Character {
        return self[self.index(self.endIndex, offsetBy: -i)]
    }
}

extension Array where Element : Equatable {
    var unique: [Element] {
        var uniqueValues: [Element] = []
        forEach { item in
            if !uniqueValues.contains(item) {
                uniqueValues += [item]
            }
        }
        return uniqueValues
    }
}

extension UISearchController {
    var hairlineView: UIView? {
        guard let barBackgroundView = self.searchBar.superview?.subviews.filter({ String(describing: type(of: $0)) == "_UIBarBackground" }).first
            else { return nil }
        
        return barBackgroundView.subviews.filter({ $0.bounds.height == 1 / self.traitCollection.displayScale }).first
    }
}

extension String {
    var source: Source? {
        if let url = URL(string: self) {
            return Source.network(ImageResource(downloadURL: url))
        }
        return nil
    }
}

extension UIImageView {
    func setBookCover(_ str: String) {
        self.kf.setImage(with: str.source, placeholder: UIImage(named: "book_placeholder"))
    }
    
    func setBookPlaceholder() {
        self.image = UIImage(named: "book_placeholder")
    }
}
