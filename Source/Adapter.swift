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
    private let dataSource: DataSource

    public init(_ dataSource: DataSource) {
        self.dataSource = dataSource
        super.init()
    }

    public convenience init(_ sectionDataSources: [SectionDataSource]) {
        self.init(CompositeDataSource(sectionDataSources: sectionDataSources))
    }

    public convenience init(_ sectionDataSource: SectionDataSource) {
        self.init([sectionDataSource])
    }

    public convenience init(_ cellControllers: [CellControllerBase]) {
        self.init([SimpleSectionDataSource(cellControllers: cellControllers)])
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
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellController = dataSource.cellControllerForRowAtIndexPath(indexPath)
        assert(cellController._cell === cell)
        cellController.unloadCell()
    }
}
