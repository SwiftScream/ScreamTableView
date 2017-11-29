//   Copyright 2017 Alex Deem
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import UIKit

public class Adapter: NSObject {
    public struct Options : OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let providesCellHeight = Options(rawValue: 1)
        public static let providesEstimatedCellHeight = Options(rawValue: 2)
    }

    public static let defaultOptions : Options = [.providesCellHeight]

    private let dataSource: DataSource
    private let options: Options

    public init(_ dataSource: DataSource, options: Options = defaultOptions) {
        self.dataSource = dataSource
        self.options = options
        super.init()
    }

    public convenience init(_ sectionDataSources: [SectionDataSource], options: Options = defaultOptions) {
        self.init(CompositeDataSource(sectionDataSources: sectionDataSources), options: options)
    }

    public convenience init(_ sectionDataSource: SectionDataSource, options: Options = defaultOptions) {
        self.init([sectionDataSource], options: options)
    }

    public convenience init(_ cellControllers: [CellControllerBase], options: Options = defaultOptions) {
        self.init([SimpleSectionDataSource(cellControllers: cellControllers)], options: options)
    }

    public override func responds(to selector: Selector!) -> Bool {
        if (selector == #selector(tableView(_:heightForRowAt:))) {
            return options.contains(.providesCellHeight)
        }
        if (selector == #selector(tableView(_:estimatedHeightForRowAt:))) {
            return options.contains(.providesEstimatedCellHeight)
        }
        return super.responds(to: selector)
    }
}

extension Adapter: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRowsInSection(section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        cellController.loadCell(inTableView: tableView, for: indexPath)
        guard let cell = cellController._cell else {
            fatalError("TableViewCellController.cell is nil immediately after .loadCell()")
        }
        return cell
    }
}

extension Adapter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        assert(cellController._cell === cell)
        cellController.cellWillAppear()
    }

    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        assert(cellController._cell === cell)
        cellController.unloadCell()
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        return cellController.heightForCell(inTableView:tableView)
    }

    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        return cellController.estimatedHeightForCell(inTableView:tableView)
    }
}
