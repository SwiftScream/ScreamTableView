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

import Foundation

open class CompositeDataSource : DataSource {
    let sectionDataSources : AnyRandomAccessCollection<SectionDataSource>

    public init(sectionDataSources: AnySequence<SectionDataSource>) {
        self.sectionDataSources = AnyRandomAccessCollection(Array(sectionDataSources))
    }

    public init(sectionDataSources: AnyRandomAccessCollection<SectionDataSource>) {
        self.sectionDataSources = sectionDataSources
    }

    public init(sectionDataSources: [SectionDataSource]) {
        self.sectionDataSources = AnyRandomAccessCollection(sectionDataSources)
    }

    public var numberOfSections: Int { get { return Int(sectionDataSources.count) } }

    public func numberOfRowsInSection(_ section: Int) -> Int {
        return sectionDataSources[AnyIndex(section)].numberOfRows
    }

    public func cellControllerForRowAtIndexPath(_ indexPath: IndexPath) -> CellControllerBase {
        return sectionDataSources[AnyIndex(indexPath.section)].cellControllerForRowAtIndex(indexPath.row)
    }
}
