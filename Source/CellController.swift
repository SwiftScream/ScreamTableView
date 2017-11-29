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

open class CellControllerBase {
    public private(set) weak var tableView: UITableView?
    internal private(set) var _cell: UITableViewCell?

    // MARK: Public Interface
    public init() {
    }

    // MARK: Internal Implementation
    private static func createCell(inTableView tableView: UITableView) -> UITableViewCell {
        var nibCell : UITableViewCell? = nil
        if let nibName = self.nibName {
            nibCell = self.nibBundle.loadNibNamed(nibName, owner: nil, options: nil)?.first as? UITableViewCell
        }
        let cell = nibCell ?? self.cellClass.init(style: self.cellStyle, reuseIdentifier: self.reuseIdentifier)
        self.configureCell(cell, inTableView: tableView)
        return cell
    }

    internal func loadCell(inTableView tableView: UITableView, for indexPath: IndexPath) {
        let t = type(of: self)
        let cell = tableView.dequeueReusableCell(withIdentifier: t.reuseIdentifier) ?? t.createCell(inTableView: tableView)
        self._cell = cell
        self.tableView = tableView
        self.cellDidLoad()
    }

    internal func unloadCell() {
        cellWillUnload()
        self._cell = nil
    }

    internal class var cellClass : UITableViewCell.Type { get { return UITableViewCell.self } }
    private class var reuseIdentifier : String { get { return String(describing: self) } }

    internal class func configureCell(_ cell: UITableViewCell, inTableView tableView: UITableView) {
    }

    // MARK: Overrides
    open class var nibName : String? { get { return nil } }
    open class var nibBundle: Bundle { get { return Bundle.main } }
    open class var cellStyle : UITableViewCellStyle { get { return .default } }

    open func cellDidLoad() {
        assert(self.tableView != nil)
        assert(self._cell != nil)
    }

    open func cellWillAppear() {
        assert(self.tableView != nil)
        assert(self._cell != nil)
    }

    open func cellWillUnload() {
        assert(self.tableView != nil)
        assert(self._cell != nil)
    }

    open func heightForCell(inTableView tableView: UITableView) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    open func estimatedHeightForCell(inTableView tableView: UITableView) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    open func willSelectCell() -> Bool {
        return true
    }

    open func didSelectCell() {
    }

    open func willDeselectCell() -> Bool {
        return true
    }

    open func didDeselectCell() {
    }
}

open class CellController<CellType : UITableViewCell> : CellControllerBase {
    public var cell: CellType? { get { return _cell as? CellType } }

    override internal class var cellClass : UITableViewCell.Type { get { return CellType.self } }

    // MARK: Trampolines
    override internal class func configureCell(_ cell: UITableViewCell, inTableView tableView: UITableView) {
        configureCell(cell as! CellType, inTableView: tableView)
    }

    // MARK: Overrides
    open class func configureCell(_ cell: CellType, inTableView tableView: UITableView) {
    }
}
