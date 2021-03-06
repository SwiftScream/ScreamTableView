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
        public static let providesTitleForDeleteConfirmationButton = Options(rawValue: 4)
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
        if (selector == #selector(tableView(_:titleForDeleteConfirmationButtonForRowAt:))) {
            return options.contains(.providesTitleForDeleteConfirmationButton)
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

    public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        return cellController.canEdit()
    }

    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        cellController.commit(editingStyle)
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

    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        return cellController.willSelectCell() ? indexPath : nil
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        cellController.didSelectCell()
    }

    public func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        return cellController.willDeselectCell() ? indexPath : nil
    }

    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        cellController.didDeselectCell()
    }

    public func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        cellController.cellAccessoryButtonTapped()
    }

    public func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        cellController.willBeginEditing()
    }

    public func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        cellController.didEndEditing()
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        return cellController.editingStyle
    }

    public func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        return cellController.titleForDeleteConfirmationButton
    }

    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        return cellController.shouldIndentWhileEditing
    }
}
