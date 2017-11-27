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

public protocol SectionDataSource {
    var numberOfRows: Int { get }
    func cellControllerForRowAtIndex(_ index: Int) -> CellControllerBase
}

open class SimpleSectionDataSource : SectionDataSource {
    private let cellControllers : AnyRandomAccessCollection<CellControllerBase>

    public init(cellControllers sequence: AnySequence<CellControllerBase>) {
        self.cellControllers = AnyRandomAccessCollection(Array(sequence))
    }

    public init(cellControllers randomAccessCollection: AnyRandomAccessCollection<CellControllerBase>) {
        self.cellControllers = randomAccessCollection
    }

    public init(cellControllers array: [CellControllerBase]) {
        self.cellControllers = AnyRandomAccessCollection(array)
    }

    public var numberOfRows: Int {
        get { return Int(cellControllers.count) }
    }

    public func cellControllerForRowAtIndex(_ index: Int) -> CellControllerBase {
        return cellControllers[AnyIndex(index)]
    }
}
