pragma solidity ^0.4.21;
import './Authorizer.sol';
import './Inventory.sol';

contract RawMaterial is Owned {
    
    Authorizer Auth;
    Inventory Invt;
    
    bytes32[] tempBytesArray;
    
    struct Supplier {
        address supplier;
        bytes32 name;
        bytes32 city;
    }

    struct RawMaterialInfo {
        bytes32 rawMaterialID;
        // bytes32 parent;
        bytes32 name;
        bytes32 groupID;
        // address currentOwner;
        address supplier;
        // bytes32[] childs;
        bytes32 additionalDiscription;
        // uint256 price;
        // bytes32 inventoryStoreID;   
        bool isConsume;     
    }

    // struct RawMaterialInfoOwnersDetails {
    //     bytes32 name;
    //     bytes32 companyName;
    // }

    struct ProductGroupIDRequirement {
        bytes32 inventoryID;
        uint256 units;
        uint256 pricePerUnit;
    }

    struct RawMatarialsArray {
        uint256 units;
        bytes32[] rawMaterialsIDs;
    }

    mapping(address => Supplier) SupplierDetails;
    mapping(bytes32 => RawMaterialInfo) RawMaterialMapping;
    // mapping(address => RawMaterialInfoOwnersDetails) owners;
    mapping(bytes32 => mapping(bytes32 => ProductGroupIDRequirement)) groupIdRequirement;
    mapping(bytes32 => bytes32[]) groupIdInventoryArrayForReq;
    mapping(bytes32 => mapping(address =>RawMatarialsArray)) groupIDWithSupplierRawMatarialsArray;

    event SupplierRegistered(bytes32 name,bytes32 city,address suplierAddress);
    event SupplierAlreadyRegistered(bytes32 name,bytes32 city,address suplierAddress);
    event RawMaterialRegistered(bytes32[] rawMaterialID,uint256 units,bytes32 groupID, address supplier);
    event RawMatarialOwnershipTransfered(address oldSupplier,address newSupplier,bytes32[] rawMatrilIDs);
    event RawMaterialRequirement(bytes32 groupID,uint256 units,uint256 pricePerUnit,bytes32 inventoryID);
    event OrderTransfer(bytes32 groupID,uint256 units,bytes32 inventoryID);

    modifier isSupplier(address _supplier) {
        if (SupplierDetails[_supplier].supplier == _supplier) {
            assert(true);
        }
        _;
    }

    function RawMaterial(
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
        if (SupplierDetails[_supplier].name == "") {
        Supplier memory newSupplier;
        newSupplier.name = _name;
        newSupplier.city = _city;
        newSupplier.supplier = _supplier;
        SupplierDetails[_supplier] = newSupplier;
        emit SupplierRegistered(_name,_city,_supplier);
        return true;
        } else {
            emit SupplierAlreadyRegistered(SupplierDetails[_supplier].name,SupplierDetails[_supplier].city,SupplierDetails[_supplier].supplier);
            return false;
        }
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

    function registerRawMaterial(
        bytes32 _name,
        bytes32 _groupID,
        address _supplier,
        bytes32 _additionalDiscription,
        uint256 _units
    )
        isSupplier(_supplier)
        public
        returns(bytes32) 
        {
        require(Auth.isRegistrar(msg.sender));

        if (groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].rawMaterialsIDs.length > 0) {
            tempBytesArray = groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].rawMaterialsIDs;
        } else {
            RawMatarialsArray memory newRawMatarialsArray;
            groupIDWithSupplierRawMatarialsArray[_groupID][_supplier] = newRawMatarialsArray;
            delete(tempBytesArray);
        }

        for (uint i = 0 ; i< _units; i++){
            bytes32 _rawMaterialID = keccak256(_name,_groupID,_supplier,_additionalDiscription,block.timestamp,i);

            RawMaterialInfo memory newRawMaterialInfo;
            newRawMaterialInfo.name = _name;
            newRawMaterialInfo.groupID = _groupID;
            newRawMaterialInfo.supplier = _supplier;
            newRawMaterialInfo.additionalDiscription = _additionalDiscription;
            // newRawMaterialInfo.price = _price;
            newRawMaterialInfo.rawMaterialID = _rawMaterialID;
            RawMaterialMapping[_rawMaterialID] = newRawMaterialInfo; 
            tempBytesArray.push(_rawMaterialID);         
        }
        groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].units += _units;
        groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].rawMaterialsIDs = tempBytesArray;

        // if (groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].rawMaterialsIDs.length > 0) {
        //     groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].units += 1;
        //     tempBytesArray = groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].rawMaterialsIDs;
        //     tempBytesArray.push(_rawMaterialID);
        //     groupIDWithSupplierRawMatarialsArray[_groupID][_supplier].rawMaterialsIDs = tempBytesArray;
        //     // delete(tempBytesArray);
        //     // groupIDWithSupplierRawMatarialsArray[_groupID][_supplier] = newRawMatarialsArray;
        //     } else {
        //         RawMatarialsArray memory newRawMatarialsArray;
        //         newRawMatarialsArray.units += 1;
        //         tempBytesArray.push(_rawMaterialID);
        //         newRawMatarialsArray.rawMaterialsIDs = tempBytesArray;
        //         groupIDWithSupplierRawMatarialsArray[_groupID][_supplier] = newRawMatarialsArray;
        //     }
        //     delete(tempBytesArray);
        
        emit RawMaterialRegistered(tempBytesArray,_units,_groupID,_supplier);
        return(_rawMaterialID);
    }

    // function transferRawMaterialInfoOwnerShip(
    //     address _newOwner,
    //     bytes32[] rawMaterialIDs
    // )
    //     isSupplier(msg.sender)
    //     public
    //     {
    //     for (uint i = 0; i < rawMaterialIDs.length;i++) {
    //         if (RawMaterialMapping[rawMaterialIDs[i]].currentOwner == msg.sender) {
    //             RawMaterialMapping[rawMaterialIDs[i]].currentOwner = _newOwner;
    //         }
    //     }
    //     emit RawMatarialOwnershipTransfered(msg.sender,_newOwner,rawMaterialIDs);
    // }

    function viewRawMaterialInfoByID( 
        bytes32 _rawMaterialID
    )
        public
        constant
        returns (
            // bytes32 parent,
            bytes32 name,
            bytes32 groupID,
            // address currentOwner,
            address supplier,
            // bytes32[] childs,
            bytes32 additionalDiscription,
            bool isConsume
        ) {
            return (
            RawMaterialMapping[_rawMaterialID].name,
            RawMaterialMapping[_rawMaterialID].groupID,
            // RawMaterialMapping[_rawMaterialID].currentOwner,
            RawMaterialMapping[_rawMaterialID].supplier,
            // RawMaterialMapping[_rawMaterialID].childs,
            RawMaterialMapping[_rawMaterialID].additionalDiscription,
            RawMaterialMapping[_rawMaterialID].isConsume            
            // RawMaterialMapping[_rawMaterialID].price
        );
    }

    function checkGroupIDUnitsAvailable(
        bytes32 _groupID
    )
        public 
        constant
        isSupplier(msg.sender)
        returns (
            bytes32 GroupID,
            uint256 Units
        ) {
        return(_groupID,groupIDWithSupplierRawMatarialsArray[_groupID][msg.sender].units);
    }
    // function viewRawMaterialInfoByGroupID(
    //     bytes32 _groupID
    // )
    //     public 
    //     constant
    //     returns(
    //         bytes32[] RawMaterialInfos
    //     ) {
    //     for (uint i = 0;i<)
    // }

    function broadcastRawMaterialRequirement(
        bytes32 _inventoryID,
        bytes32 _groupID,
        uint256 _units,
        uint256 _pricePerUnit
    )
        public
        {
        if(groupIdRequirement[_groupID][_inventoryID].units>0){
            groupIdRequirement[_groupID][_inventoryID].units += _units;
        } else {
            ProductGroupIDRequirement memory newProductGroupIDRequirement;
            newProductGroupIDRequirement.inventoryID = _inventoryID;
            newProductGroupIDRequirement.units += _units;
            newProductGroupIDRequirement.pricePerUnit += _pricePerUnit;
            groupIdRequirement[_groupID][_inventoryID] = newProductGroupIDRequirement;
            bool f =true;
            for(uint i = 0 ;i<groupIdInventoryArrayForReq[_groupID].length;i++) {
                if(groupIdInventoryArrayForReq[_groupID][i] == _inventoryID) {
                    f = false;
                }
            }
            if(f){
                groupIdInventoryArrayForReq[_groupID].push(_inventoryID);
            }
        }
        emit RawMaterialRequirement(_groupID,_units,_pricePerUnit,_inventoryID);
    }

    function viewGroupIDRequirement(
        bytes32 _groupID
    )
        public
        constant
        isSupplier(msg.sender)
        returns(
            bytes32[] inventoryID,
            uint256[] units,
            uint256[] pricePerUnit,
            uint256 inStock
        ) {
        require(groupIdInventoryArrayForReq[_groupID].length > 0);
        bytes32[] memory tempBytes = new bytes32[](groupIdInventoryArrayForReq[_groupID].length);
        uint256[] memory tempUnit = new uint256[](groupIdInventoryArrayForReq[_groupID].length);
        uint256[] memory tempUnitP = new uint256[](groupIdInventoryArrayForReq[_groupID].length);
        
        for(uint i = 0; i<groupIdInventoryArrayForReq[_groupID].length;i++){
            tempBytes[i] = groupIdInventoryArrayForReq[_groupID][i];
            tempUnit[i] = groupIdRequirement[_groupID][groupIdInventoryArrayForReq[_groupID][i]].units;
            tempUnitP[i] = groupIdRequirement[_groupID][groupIdInventoryArrayForReq[_groupID][i]].pricePerUnit;
        }
        return (tempBytes,tempUnit,tempUnitP,groupIDWithSupplierRawMatarialsArray[_groupID][msg.sender].units);
    }

    function sendSellOrder(
        bytes32 _groupID,
        bytes32 _inventoryID
    )
        public
        isSupplier(msg.sender)
        {
        require(groupIdRequirement[_groupID][_inventoryID].units <= groupIDWithSupplierRawMatarialsArray[_groupID][msg.sender].units);
        
        for (uint i = 0; i < groupIdRequirement[_groupID][_inventoryID].units ; i++) {
        bytes32 id = groupIDWithSupplierRawMatarialsArray[_groupID][msg.sender].rawMaterialsIDs[i];
        if (groupIdRequirement[_groupID][_inventoryID].inventoryID==_inventoryID) {
            Invt.recieveRawMatarials(
                RawMaterialMapping[id].rawMaterialID,
                // RawMaterialMapping[id].parent,
                RawMaterialMapping[id].name,
                RawMaterialMapping[id].groupID,
                // RawMaterialMapping[id].currentOwner,
                RawMaterialMapping[id].supplier,
                // RawMaterialMapping[id].childs,
                RawMaterialMapping[id].additionalDiscription,
                groupIdRequirement[_groupID][_inventoryID].pricePerUnit,
                groupIdRequirement[_groupID][_inventoryID].inventoryID
            );
        // delete(RawMaterialMapping[id]);
        RawMaterialMapping[id].isConsume = true;
        }
        }
        groupIDWithSupplierRawMatarialsArray[_groupID][msg.sender].units -= groupIdRequirement[_groupID][_inventoryID].units;
        delete(groupIdRequirement[_groupID][_inventoryID]);
        for (uint j = 0 ;j< groupIdInventoryArrayForReq[_groupID].length ; j++){
            if(groupIdInventoryArrayForReq[_groupID][j] == _inventoryID){
                delete(groupIdInventoryArrayForReq[_groupID][j]);
                break;
            }
        }
        emit OrderTransfer(_groupID,groupIdRequirement[_groupID][_inventoryID].units,_inventoryID);
    }

}