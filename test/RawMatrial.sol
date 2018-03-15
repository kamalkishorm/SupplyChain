pragma solidity ^0.4.18;
import './Authorizer.sol';
import './Inventory.sol';

contract RawMatrial is Owned {
    
    Authorizer Auth;
    Inventory Invt;

    struct Supplier {
        address supplier;
        bytes32 name;
        bytes32 city;
    }

    struct RawMatrialInfo {
        bytes32 rawMatrialID;
        // bytes32 parent;
        bytes32 name;
        bytes32 groupID;
        address currentOwner;
        address supplier;
        // bytes32[] childs;
        bytes32 additionalDiscription;
        // uint256 price;
        // bytes32 inventoryStoreID;        
    }

    struct RawMatrialInfoOwnersDetails {
        bytes32 name;
        bytes32 companyName;
    }

    struct ProductGroupIDRequirement {
        bytes32 inventoryID;
        uint256 units;
        uint256 pricePerUnit;
    }

    struct RawMatarialsArray {
        uint256 units;
        bytes32[] rawMatrialsIDs;
    }

    mapping(address => Supplier) SupplierDetails;
    mapping(bytes32 => RawMatrialInfo) RawMatrialMapping;
    mapping(address => RawMatrialInfoOwnersDetails) owners;
    mapping(bytes32 => ProductGroupIDRequirement) groupIdRequirement;
    mapping(bytes32 => mapping(address =>RawMatarialsArray)) groupIDWithSupplierRawMatarialsArray;

    modifier isSupplier(address _supplier) {
        if (SupplierDetails[_supplier].supplier == _supplier) {
            assert(true);
        }
        _;
    }

    function RawMatrial(
        address authorizerContractAddress
    ) 
        public 
        {
        Auth = Authorizer(authorizerContractAddress);
        
    }
    
    function setInventoryContractAddress(address inventoryContractAddress) public onlyOwner returns(bool) {
        Invt = Inventory(inventoryContractAddress);
    }
    
    function registerSupplier(
        bytes32 _name,
        bytes32 _city,
        address _supplier
    ) 
        public 
        returns(bool)
        {
        require(Auth.isRegistrar(msg.sender));
        require(SupplierDetails[_supplier].name == "");
        Supplier memory newSupplier;
        newSupplier.name = _name;
        newSupplier.city = _city;
        newSupplier.supplier = _supplier;
        SupplierDetails[_supplier] = newSupplier;
        return true;
    }

    function viewSupplier(
        address _supplier
    )
        public
        constant
        returns(
            address supplier,
            bytes32 name,
            bytes32 city
        ) {
        return(SupplierDetails[_supplier].supplier,SupplierDetails[_supplier].name,SupplierDetails[_supplier].city);
    }

    function registerRawMatrial(
        bytes32 _name,
        bytes32 _groupID,
        address _supplier,
        bytes32 _additionalDiscription,
        uint256 _price
    )
        isSupplier(_supplier)
        public
        returns(bytes32) 
        {
        require(Auth.isRegistrar(msg.sender));
        bytes32 _rawMatrialID = keccak256(_name,_groupID,_supplier,_additionalDiscription,_price,block.timestamp);

        RawMatrialInfo memory newRawMatrialInfo;
        newRawMatrialInfo.name = _name;
        newRawMatrialInfo.groupID = _groupID;
        newRawMatrialInfo.supplier = _supplier;
        newRawMatrialInfo.additionalDiscription = _additionalDiscription;
        // newRawMatrialInfo.price = _price;
        newRawMatrialInfo.rawMatrialID = _rawMatrialID;
        RawMatrialMapping[_rawMatrialID] = newRawMatrialInfo;

        if (groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].rawMatrialsIDs.length > 0) {
            groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].units += 1;
            groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].rawMatrialsIDs.push(_rawMatrialID);
            // groupIDWithSupplierRawMatarialsArray[_groupID][_supplier] = newRawMatarialsArray;
        } else {
            RawMatarialsArray memory newRawMatarialsArray;
            newRawMatarialsArray.units += 1;
            newRawMatarialsArray.rawMatrialsIDs[newRawMatarialsArray.rawMatrialsIDs.length] = _rawMatrialID;
            groupIDWithSupplierRawMatarialsArray[_groupID][_supplier] = newRawMatarialsArray;
        }
    }
    function transferRawMatrialInfoOwnerShip(
        address _newOwner,
        bytes32[] RawMatrialIDs
    )
        isSupplier(msg.sender)
        public
        {
        for (uint i = 0; i < RawMatrialIDs.length;i++) {
            if (RawMatrialMapping[RawMatrialIDs[i]].currentOwner == msg.sender) {
                RawMatrialMapping[RawMatrialIDs[i]].currentOwner = _newOwner;
            }
        }
    }

    function viewRawMatrialInfoByID( 
        bytes32 _rawMatrialID
    )
        public
        constant
        returns (
            // bytes32 parent,
            bytes32 name,
            bytes32 groupID,
            address currentOwner,
            address supplier,
            // bytes32[] childs,
            bytes32 additionalDiscription
        ) {
            return (
            RawMatrialMapping[_rawMatrialID].name,
            RawMatrialMapping[_rawMatrialID].groupID,
            RawMatrialMapping[_rawMatrialID].currentOwner,
            RawMatrialMapping[_rawMatrialID].supplier,
            // RawMatrialMapping[_rawMatrialID].childs,
            RawMatrialMapping[_rawMatrialID].additionalDiscription
            // RawMatrialMapping[_rawMatrialID].price
        );
    }

    // function viewRawMatrialInfoByGroupID(
    //     bytes32 _groupID
    // )
    //     public 
    //     constant
    //     returns(
    //         bytes32[] RawMatrialInfos
    //     ) {
    //     for (uint i = 0;i<)
    // }

    function broadcastRawMatrialRequirement(
        bytes32 _inventoryID,
        bytes32 _groupID,
        uint256 _units,
        uint256 _pricePerUnit
    )
        external
        {
        ProductGroupIDRequirement memory newProductGroupIDRequirement;
        // if(groupIdRequirement[_groupID].units == 0) {
            newProductGroupIDRequirement.inventoryID = _inventoryID;
            newProductGroupIDRequirement.units += _units;
            newProductGroupIDRequirement.pricePerUnit += _pricePerUnit;
            groupIdRequirement[_groupID] = newProductGroupIDRequirement;
        // }
    }

    function viewGroupIDRequirement(
        bytes32 _groupID
    )
        public
        constant
        isSupplier(msg.sender)
        returns(
            bytes32 inventoryID,
            uint256 units
        ) {
        require(groupIdRequirement[_groupID].units != 0);
        return (groupIdRequirement[_groupID].inventoryID,groupIdRequirement[_groupID].units);
    }

    function sendSellOrder(
        bytes32 _groupID,
        bytes32 _inventorID
    )
        public
        isSupplier(msg.sender)
        {
        require(groupIdRequirement[_groupID].units <= groupIDWithSupplierRawMatarialsArray[_groupID][msg.sender].units);
        
        for (uint i = 0; i < groupIdRequirement[_groupID].units ; i++) {
        bytes32 id = groupIDWithSupplierRawMatarialsArray[_groupID][msg.sender].rawMatrialsIDs[i];
        Invt.recieveRawMatarials(
            RawMatrialMapping[id].rawMatrialID,
            // RawMatrialMapping[id].parent,
            RawMatrialMapping[id].name,
            RawMatrialMapping[id].groupID,
            RawMatrialMapping[id].currentOwner,
            RawMatrialMapping[id].supplier,
            // RawMatrialMapping[id].childs,
            RawMatrialMapping[id].additionalDiscription,
            groupIdRequirement[_groupID].pricePerUnit,
            groupIdRequirement[_groupID].inventoryID
        );
        delete(RawMatrialMapping[id]);
        }
        groupIDWithSupplierRawMatarialsArray[_groupID][msg.sender].units -= groupIdRequirement[_groupID].units;

    }

}