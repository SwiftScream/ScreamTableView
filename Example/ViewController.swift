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
import ScreamTableView

class ViewController: UIViewController {
    var tableView: UITableView?
    var tableViewAdapter: Adapter?

    override func loadView() {
        let view = UIView(frame: UIScreen.main.bounds)

        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(tableView)

        self.tableView = tableView
        self.view = view
    }

    override func viewDidLoad() {
        self.tableViewAdapter = Adapter([PrimaryColorSwatchSectionDataSource(), SecondaryColorSwatchSectionDataSource()])

        tableView?.dataSource = self.tableViewAdapter
        tableView?.delegate = self.tableViewAdapter
    }
}

class PrimaryColorSwatchSectionDataSource : SimpleSectionDataSource {
    init() {
        super.init(cellControllers: [ColorSwatchTableViewCellController(name:"Black", color:.black),
                                     ColorSwatchTableViewCellController(name:"Dark Gray", color:.darkGray),
                                     ColorSwatchTableViewCellController(name:"Light Gray", color:.lightGray),
                                     ColorSwatchTableViewCellController(name:"Gray", color:.gray),
                                     ColorSwatchTableViewCellController(name:"Red", color:.red),
                                     ColorSwatchTableViewCellController(name:"Green", color:.green),
                                     ColorSwatchTableViewCellController(name:"Blue", color:.blue),
                                     ColorSwatchTableViewCellController(name:"Cyan", color:.cyan),
                                     ColorSwatchTableViewCellController(name:"Yellow", color:.yellow),
                                     ColorSwatchTableViewCellController(name:"Magenta", color:.magenta),
                                     ColorSwatchTableViewCellController(name:"Orange", color:.orange),
                                     ColorSwatchTableViewCellController(name:"Purple", color:.purple),
                                     ColorSwatchTableViewCellController(name:"Brown", color:.brown),])
    }
}

class SecondaryColorSwatchSectionDataSource : SimpleSectionDataSource {
    init() {
        super.init(cellControllers: [ColorSwatchTableViewCellController(name:"Black 50%", color:UIColor.black.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Dark Gray 50%", color:UIColor.darkGray.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Light Gray 50%", color:UIColor.lightGray.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Gray 50%", color:UIColor.gray.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Red 50%", color:UIColor.red.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Green 50%", color:UIColor.green.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Blue 50%", color:UIColor.blue.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Cyan 50%", color:UIColor.cyan.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Yellow 50%", color:UIColor.yellow.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Magenta 50%", color:UIColor.magenta.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Orange 50%", color:UIColor.orange.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Purple 50%", color:UIColor.purple.withAlphaComponent(0.5)),
                                     ColorSwatchTableViewCellController(name:"Brown 50%", color:UIColor.brown.withAlphaComponent(0.5)),])
    }
}

class ColorSwatchTableViewCell : UITableViewCell {
    @IBOutlet var swatchView: UIView!
}

class ColorSwatchTableViewCellController : CellController<ColorSwatchTableViewCell> {
    let name: String
    let color: UIColor

    override class var nibName : String? { get { return String(describing: ColorSwatchTableViewCell.self) } }

    init(name: String, color: UIColor) {
        self.name = name
        self.color = color
        super.init()
    }

    override class func configureCell(_ cell: ColorSwatchTableViewCell, inTableView tableView: UITableView) {
        cell.textLabel?.textColor = .darkGray
    }

    override func cellDidLoad() {
        cell?.textLabel?.text = name
        cell?.swatchView.backgroundColor = color
    }
}
