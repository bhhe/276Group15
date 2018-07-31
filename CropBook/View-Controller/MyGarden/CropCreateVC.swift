import UIKit
import Firebase

class CropCreateVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tblDropDown: UITableView!
    @IBOutlet weak var tblDropDownHC: NSLayoutConstraint!
    @IBOutlet weak var btnNumberOfRooms: UIButton!
    @IBOutlet weak var cropNameField: UITextField!
    
    @IBOutlet weak var createCrop: UIButton!
    
    let ref=Database.database().reference()
    var isTableVisible = false
    var mainLib = lib.getMainLibrary()
    var profName = ""
    var cropSelected = false
    var libIndex = 0
    var gardenIndex = 0;
    var Online:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cropSelected = false
        cropNameField?.delegate = self
        createCrop?.isUserInteractionEnabled = false
        createCrop?.alpha = 0.5
        tblDropDown.delegate = self
        tblDropDown.dataSource = self
        tblDropDownHC.constant = 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainLib.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "numberofcrops")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "numberofcrops")
        }
        cell?.textLabel?.text = mainLib[indexPath.row].getName()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        libIndex = indexPath.row
        btnNumberOfRooms.setTitle(mainLib[libIndex].getName(), for: .normal)
        btnNumberOfRooms.setBackgroundImage(UIImage(named: mainLib[libIndex].getImage()), for: .normal)
        cropSelected = true
        cropNameField.text = mainLib[libIndex].getName()
        createCrop?.isUserInteractionEnabled = true
        createCrop?.isEnabled = true
        createCrop?.alpha = 1.0
        UIView.animate(withDuration: 0.5) {
            self.tblDropDownHC.constant = 0
            self.isTableVisible = false
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func selectNumberOfRooms(_ sender : AnyObject) {
        UIView.animate(withDuration: 0.5) {
            if self.isTableVisible == false {
                self.isTableVisible = true
             self.tblDropDownHC.constant = 44.0 * 3.0
            } else {
                self.tblDropDownHC.constant = 0
                self.isTableVisible = false
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (cropNameField.text! as NSString).replacingCharacters(in: range, with: string)
        return true
    } 
    
    @IBAction func AddCrop(_ sender: Any) {
        print("ADDING CROP");

        let profName = cropNameField.text!
        let newCropProf = CropProfile(cropInfo : mainLib[libIndex], profName : profName)
        
        if(Online)!{
            //add Crop into Firebase Database
            let gardenID=SHARED_GARDEN_LIST[gardenIndex]?.gardenID
            let cropname=newCropProf.GetCropName()
            let gardenRef=ref.child("Gardens/\(gardenID!)/CropList").childByAutoId()
            gardenRef.child("CropName").setValue(cropname)
            gardenRef.child("ProfName").setValue(profName)
            print("Crop added")
        }else{
            let cropCore = CropProfileCore(context: PersistenceService.context)
            cropCore.cropName = newCropProf.GetCropName()
            cropCore.profName = profName
            cropCore.plotLength = Int16(0)
            cropCore.plotWidth = Int16(0)
            PersistenceService.saveContext()
            newCropProf.coreData = cropCore
            print(newCropProf.coreData?.cropName as! String)
            MY_GARDEN.cropProfile.append(newCropProf)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
}

