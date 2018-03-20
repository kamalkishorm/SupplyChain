pragma solidity ^0.4.18;
import './Owned.sol';
import './Retailer.sol';

contract Manager is Owned {
    
    bytes32[] tempBytesArray;
    bytes32[] tempUintArray;
    
    address[] RequestPendingRetailerAddressArray;

    struct ManagerDetails {
        address managerAddress;
        bytes32 name;
        bytes32 designation;
        bytes32 additionalInfo;
    }

    struct RetailerRequirement {
        address retailerAddress;
        bytes32 productName;
        uint256 units;
    }
    struct ProductRequirement {
        bytes32 productName;
        uint256 units;
    }
    // struct BroadcastRequirement {
    //     bytes32 productName;
    //     uint256 units; 
    // }
    
    mapping(address => ManagerDetails) Managers;
    mapping(bytes32 => mapping(address => RetailerRequirement)) CategoryWiseRetailerRequirementRequestes;
    mapping(bytes32 => uint256 ) ProductCategoryRequirementCount;
    // mapping(bytes32 => BroadcastRequirement) broadcastRequirement;
    
    modifier isManager(address _manager) {
        if (Managers[_manager].managerAddress == _manager) {
            assert(true);
        }
        _;
    }
     
    function addManager(
        address _manager, 
        bytes32 _name, 
        bytes32 _designation, 
        bytes32 _additionalInfo
    )
        onlyOwner 
        public 
        {
        ManagerDetails memory newManager;
        newManager.managerAddress = _manager;
        newManager.name = _name;
        newManager.designation = _designation;
        newManager.additionalInfo = _additionalInfo;
        Managers[_manager] = newManager;
    }
    
    function viewManager(
        address _manager
    ) 
        public 
        constant 
        returns(
            bytes32 name, 
            bytes32 designamtion, 
            bytes32 additionalInfo
        ) {
        require(msg.sender == owner || msg.sender == _manager);
        return (Managers[_manager].name,Managers[_manager].designation,Managers[_manager].additionalInfo);
    }
    
    function broadcastProductRequirement(address _retailerAddress,bytes32 _productName, uint256 _units) public {
         
        
        RetailerRequirement memory newRetailerRequirement;
        newRetailerRequirement.retailerAddress = _retailerAddress;
        newRetailerRequirement.productName = _productName;
        if (CategoryWiseRetailerRequirementRequestes[_productName][_retailerAddress].units > 0) {
            newRetailerRequirement.units = CategoryWiseRetailerRequirementRequestes[_productName][_retailerAddress].units + _units;
        } else {
            newRetailerRequirement.units = _units;
        }
        CategoryWiseRetailerRequirementRequestes[_productName][_retailerAddress] = newRetailerRequirement;
        ProductCategoryRequirementCount[_productName] += newRetailerRequirement.units;
        RequestPendingRetailerAddressArray.push(_retailerAddress);
        
    }
    
    function productsRequirementFullFill(address _retailerAddress,bytes32 _productName, uint256 _units) public {
        if (CategoryWiseRetailerRequirementRequestes[_productName][_retailerAddress].units > 0) {
            CategoryWiseRetailerRequirementRequestes[_productName][_retailerAddress].units -= _units;
        }        
    }

    function viewRequirement(
        bytes32 _productName
    )
        public
        constant
        isManager(msg.sender)
        returns(
            address[] retailerID,
            uint256[] units
        ) {
        for (uint i = 0 ; i<RequestPendingRetailerAddressArray.length; i++) {
            units[i] = (CategoryWiseRetailerRequirementRequestes[_productName][RequestPendingRetailerAddressArray[i]].units);
            retailerID[i] = RequestPendingRetailerAddressArray[i];
        }
    }

    
}