import SwiftUI
import UIKit

/// Represents a section in a custom table with a header and items.
public struct TableSection<HeaderItem, Item: Identifiable & Equatable>: Equatable {
    /// The section header
    public let header: HeaderItem
    /// Items in this section
    public let items: [Item]

    /// Creates a new table section
    /// - Parameters:
    ///   - header: The section header
    ///   - items: Items in this section
    public init(header: HeaderItem, items: [Item]) {
        self.header = header
        self.items = items
    }

    public static func == (lhs: TableSection<HeaderItem, Item>, rhs: TableSection<HeaderItem, Item>) -> Bool {
        lhs.items == rhs.items
    }
}

/// A SwiftUI wrapper for UITableView with section headers and custom cells.
public struct TableView<Item: Identifiable & Equatable, Content: View, HeaderContent: View>: UIViewRepresentable {
    @Binding private var sections: [TableSection<String, Item>]
    private let cellBuilder: (Item) -> Content
    private let headerBuilder: (String) -> HeaderContent

    /// Creates a new TableView
    /// - Parameters:
    ///   - sections: The sections to display
    ///   - cellBuilder: A closure that builds a cell for an item
    ///   - headerBuilder: A closure that builds a header for a section
    public init(
        sections: Binding<[TableSection<String, Item>]>,
        cellBuilder: @escaping (Item) -> Content,
        headerBuilder: @escaping (String) -> HeaderContent
    ) {
        _sections = sections
        self.cellBuilder = cellBuilder
        self.headerBuilder = headerBuilder
    }

    public func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = context.coordinator
        tableView.delegate = context.coordinator
        tableView.register(
            HostingCell.self,
            forCellReuseIdentifier: HostingCell.id
        )
        tableView.register(
            HostingHeaderView.self,
            forHeaderFooterViewReuseIdentifier: HostingHeaderView.id
        )
        tableView.allowsSelection = false
        tableView.rowHeight = 100.0
        return tableView
    }

    public func updateUIView(_ tableView: UITableView, context: Context) {
        DispatchQueue.main.async {
            if sections != context.coordinator.sections {
                context.coordinator.sections = sections
                tableView.reloadData()
            }
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(
            sections: sections,
            cellBuilder: cellBuilder,
            headerBuilder: headerBuilder
        )
    }

    /// Coordinator for TableView
    public class Coordinator: NSObject, UITableViewDataSource, UITableViewDelegate {
        var sections: [TableSection<String, Item>]
        let cellBuilder: (Item) -> Content
        let headerBuilder: (String) -> HeaderContent

        init(
            sections: [TableSection<String, Item>],
            cellBuilder: @escaping (Item) -> Content,
            headerBuilder: @escaping (String) -> HeaderContent
        ) {
            self.sections = sections
            self.cellBuilder = cellBuilder
            self.headerBuilder = headerBuilder
        }

        public func numberOfSections(in _: UITableView) -> Int {
            sections.count
        }

        public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
            sections[section].items.count
        }

        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: HostingCell.id,
                for: indexPath
            ) as! HostingCell

            let section = sections[indexPath.section]
            let item = section.items[indexPath.row]
            let view = cellBuilder(item)

            if cell.host == nil {
                let controller = UIHostingController(rootView: AnyView(view))
                controller.view.backgroundColor = .clear
                cell.setupHost(with: controller)
            } else {
                cell.host?.rootView = AnyView(view)
            }
            cell.setNeedsLayout()
            return cell
        }

        public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: HostingHeaderView.id
            ) as! HostingHeaderView

            let section = sections[section]
            let view = headerBuilder(section.header)

            if headerView.host == nil {
                let controller = UIHostingController(rootView: AnyView(view))
                headerView.setupHost(with: controller)
            } else {
                headerView.host?.rootView = AnyView(view)
            }
            headerView.setNeedsLayout()

            return headerView
        }

        public func sectionIndexTitles(for _: UITableView) -> [String]? {
            sections.map(\.header)
        }

        public func tableView(_: UITableView, sectionForSectionIndexTitle title: String, at _: Int) -> Int {
            sections.firstIndex { $0.header == title } ?? 0
        }
    }
}

/// Cell for hosting SwiftUI views
private class HostingCell: UITableViewCell {
    static let id = "HostingCell"
    var host: UIHostingController<AnyView>?

    func setupHost(with controller: UIHostingController<AnyView>) {
        host = controller

        let view = controller.view!
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}

/// Header view for hosting SwiftUI views
private class HostingHeaderView: UITableViewHeaderFooterView {
    static let id = "HostingHeaderView"
    var host: UIHostingController<AnyView>?

    func setupHost(with controller: UIHostingController<AnyView>) {
        host = controller

        let view = controller.view!
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        contentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
