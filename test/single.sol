pragma solidity ^0.4.18;

contract Owned {
    address public owner;
    
    modifier onlyOwner {
        if (msg.sender != owner) {
            assert(true);
        }
        _;
    }

    function Owned() public {
        owner = msg.sender;
    }
    function transferOwnership(
        address newOwner
    ) 
        public
        onlyOwner
        {
        owner = newOwner;
    }
    
}


contract Authorizer is Owned {

    struct AuthorizerDetails {
        bytes32 name;
        bytes32 designation;
        authorizationType authorizerType;
        bytes32 additionalInfo;
    }

    mapping(address => AuthorizerDetails) Authorizers;

    enum authorizationType{unauth,registrar,validator}

    // modifier isRegistrar {
    //     if (uint(Authorizers[msg.sender].authorizerType) != 0) {
    //         assert(true);
    //     }
    //     _;
    // }

    // modifier isValidator {
    //     if (uint(Authorizers[msg.sender].authorizerType) != 1) {
    //         assert(true);
    //     }
    //     _;
    // }

    function addAuthorizer(
        address _authorizer, 
        bytes32 _name, 
        bytes32 _designation, 
        authorizationType _authorizserType, 
        bytes32 _additionalInfo
    )
        onlyOwner 
        public
        {
        AuthorizerDetails memory newAuthorizser;
        newAuthorizser.name = _name;
        newAuthorizser.designation = _designation;
        newAuthorizser.authorizerType = authorizationType(_authorizserType);
        newAuthorizser.additionalInfo = _additionalInfo;
        Authorizers[_authorizer] = newAuthorizser;
    }

    function viewAuthorizer(
        address _authorizer
    ) 
        public 
        constant 
        returns(
            bytes32 name, 
            bytes32 designamtion, 
            authorizationType authorizerType, 
            bytes32 additionalInfo
            ) {
        require(msg.sender == owner || msg.sender == _authorizer);
        return (Authorizers[_authorizer].name,Authorizers[_authorizer].designation,Authorizers[_authorizer].authorizerType,Authorizers[_authorizer].additionalInfo);
    }

    function isRegistrar(address caller) constant external returns(bool) {
        if (uint(Authorizers[caller].authorizerType) == 1) {
            return true;
        } else {
            return false;
        }
    }

    function isValidator(address caller) constant external returns(bool) {
        if (uint(Authorizers[caller].authorizerType) == 2) {
            return true;
        } else {
            return false;
        }
    }

}


contract Manager is Owned {
    
    Authorizer Auth;
    
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
    
    function Manager (address _authAddress) public
    {
        Auth = Authorizer(_authAddress);
    }
    
    function isManager(address _managerAddress) public constant returns(bool) 
    {
        if (ManagerInfo[_managerAddress].managerAddress == _managerAddress) 
        {
            return true;
        }
        else 
        {
            return false;
        }
    }
    // struct BroadcastRequirement {
    //     bytes32 productName;
    //     uint256 units; 
    // }
    
    mapping(address => ManagerDetails) ManagerInfo;
    mapping(bytes32 => mapping(address => RetailerRequirement)) CategoryWiseRetailerRequirementRequestes;
    mapping(bytes32 => uint256 ) ProductCategoryRequirementCount;
    // mapping(bytes32 => BroadcastRequirement) broadcastRequirement;
    
     
    function addManager(
        address _manager, 
        bytes32 _name, 
        bytes32 _designation, 
        bytes32 _additionalInfo
    )
        public 
        {
        require(Auth.isRegistrar(msg.sender));
        ManagerDetails memory newManager;
        newManager.managerAddress = _manager;
        newManager.name = _name;
        newManager.designation = _designation;
        newManager.additionalInfo = _additionalInfo;
        ManagerInfo[_manager] = newManager;
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
        return (ManagerInfo[_manager].name,ManagerInfo[_manager].designation,ManagerInfo[_manager].additionalInfo);
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
    
    function productsRequirementFullFilled(address _managerAddress,address _retailerAddress,bytes32 _productName, uint256 _units) constant public returns(bool){
        require(isManager(_managerAddress));
        if (CategoryWiseRetailerRequirementRequestes[_productName][_retailerAddress].units > 0) {
            CategoryWiseRetailerRequirementRequestes[_productName][_retailerAddress].units -= _units;
            return true;
        }        
    }

    function viewRequirement( bytes32 _productName) public constant returns(address[] retailerID, uint256[] units)
    {
        require(isManager(msg.sender));
        for (uint i = 0 ; i<RequestPendingRetailerAddressArray.length; i++) {
            units[i] = (CategoryWiseRetailerRequirementRequestes[_productName][RequestPendingRetailerAddressArray[i]].units);
            retailerID[i] = RequestPendingRetailerAddressArray[i];
        }
    }

    
}


contract OperationTeam is Owned {
    
    Authorizer Auth;
    Inventory Invt;
    // address WH;

    bytes32[] operationTeams;

    // address[] tempAddArray;
    // bytes32[] tempBytesArray;
    // uint256[] tempUintArray;
    // uint256 priceCalculator;

    struct OperationTeamInfo {
        address teamLead;
        address[] teamMembers;
        bytes32 teamName;
        bytes32 operationName;
        bytes32[] rawMaterialGroupID;
        uint256[] rawMaterialUnits;
        bytes32 productDescription;
    }
    
    // struct FinalProduct {
    //     bytes32 productID;
    //     // bytes32 parent;
    //     // bytes32 name;
    //     bytes32 groupID;
    //     // address currentOwner;
    //     // address supplier;
    //     bytes32[] childs;
    //     bytes32 additionalDiscription;
    //     uint256 price;
    //     // bytes32 inventoryStoreID;
    //     bool isConsume;
    // }

    // struct FinalProductsArray {
    //     uint256 units;
    //     bytes32[] FinalProductIDs;
    // }


    mapping(bytes32 => OperationTeamInfo) operationDetails;
    // mapping(bytes32 => FinalProduct) manufacturedProducts;
    // mapping(bytes32 => FinalProductsArray) finalProductsArray;

    function OperationTeam(
        address _authorizerContractAddress//,
        //address _inventoryContractAddress,
        //address _warehouseContractAddress
    ) public {
        Auth = Authorizer(_authorizerContractAddress);
        // Invt = Inventory(_inventoryContractAddress);
        // WH = _warehouseContractAddress;
    }

    function setInventoryContractAddress(
        address _inventoryContractAddress
    )
        public
        onlyOwner
        returns(
            bool
        ) {
        Invt = Inventory(_inventoryContractAddress);
    }
    
    function registerOperationTeam(
        address _teamLead,
        address[] _teamMembers,
        bytes32 _teamName,
        bytes32 _operationName,
        bytes32[] _rawMaterialGroupID,
        uint256[] _rawMaterialUnits,
        bytes32 _productDescription
    )
        public
        returns( 
            bool 
            ) {
        require(Auth.isRegistrar(msg.sender));
        if (operationDetails[_operationName].operationName != "") {
            return false;
        } else {
            OperationTeamInfo memory newOperationTeamInfo;
            newOperationTeamInfo.teamLead = _teamLead;
            newOperationTeamInfo.teamMembers = _teamMembers;
            newOperationTeamInfo.teamName = _teamName;
            newOperationTeamInfo.operationName = _operationName;
            newOperationTeamInfo.rawMaterialGroupID = _rawMaterialGroupID;
            newOperationTeamInfo.rawMaterialUnits = _rawMaterialUnits;
            newOperationTeamInfo.productDescription = _productDescription;            
            operationDetails[_operationName] = newOperationTeamInfo;
            operationTeams.push(_operationName);
            return true;
        }
    }

    function isOperator(bytes32 _operationName,address operationLeadAddress) public constant returns(bool) {
        if (operationDetails[_operationName].teamLead == operationLeadAddress) {
            return true;
        } else {
            return false;
        }
    }

    function makeFinalProducts(
        bytes32 _operationName,
        bytes32 _inventoryID,
        uint256 _units
    )
        public
        returns(
            bool
        ) {
        return (Invt.getRawMaterialsFromInventory(msg.sender,_operationName,_inventoryID,_units,operationDetails[_operationName].rawMaterialGroupID,operationDetails[_operationName].rawMaterialUnits,operationDetails[_operationName].productDescription));
    }
    // function getRawMaterialsFromInventory(
    //     bytes32 _operationName,
    //     bytes32 _inventoryID,
    //     uint256 _units
    // )
    //     public
    //     returns(
    //         bytes32[] _finalProductID
    //     ) {
    //     require(operationDetails[_operationName].teamLead == msg.sender);
    //     priceCalculator = 0;
    //     for (uint i = 0; i < operationDetails[_operationName].rawMaterialGroupID.length;i++) {
    //         tempBytesArray = Invt.getRawMaterialFromInventory(_inventoryID,operationDetails[_operationName].rawMaterialGroupID[i],operationDetails[_operationName].rawMaterialUnits[i])[0];
    //         priceCalculator += Invt.getRawMaterialFromInventory(_inventoryID,operationDetails[_operationName].rawMaterialGroupID[i],operationDetails[_operationName].rawMaterialUnits[i])[1];            
    //     }
    //     bytes32 _productID = keccak256(tempBytesArray.length,tempBytesArray);
    //     FinalProduct memory newFinalProduct;
    //     newFinalProduct.productID = _productID;
    //     // newFinalProduct.parent = "Final Product";
    //     newFinalProduct.groupID = _operationName;
    //     newFinalProduct.childs = tempBytesArray;
    //     newFinalProduct.additionalDiscription = operationDetails[_operationName].productDescription;
    //     newFinalProduct.price = priceCalculator;
    //     manufacturedProducts[_productID] = newFinalProduct;
    //     finalProductsArray[_operationName].units += 1;
    //     finalProductsArray[_operationName].FinalProductIDs.push(_productID);
    // }

    // function getManufacturedProducts(
    //     bytes32 _operationName
    // )
    //     public
    //     constant
    //     returns(
    //         bytes32[] finalProductIDs,
    //         uint256 unitsAvailable
    //     ) {
    //     return(finalProductsArray[_operationName].FinalProductIDs,finalProductsArray[_operationName].units);
    // }


}

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


contract Inventory is Owned {
    
    Authorizer Auth;
    RawMaterial RawMat;
    OperationTeam opTeam;
    Warehouse WH;

    bytes32[] inventoryStoreList;
    bytes32[] tempBytesArray;
    uint256[] tempUintArray;
    uint priceCalculated;

    struct InventoryStoreInfo {
        address inventoryHead;
        bytes32 inventoryName;
        bytes32 inventoryCity;
        mapping(bytes32 => uint256) groupIdCounts;
    }

    struct Product {
        bytes32 productID;
        bytes32 parent;
        bytes32 name;
        bytes32 groupID;
        address currentOwner;
        address supplier;
        bytes32[] childs;
        bytes32 additionalDiscription;
        uint256 price;
        bytes32 inventoryStoreID;
        bool isConsume;
    }

    struct ProductsArray {
        uint256 units;
        bytes32[] rawMaterialsIDs;
    }

    struct FinalProduct {
        bytes32 productID;
        bytes32 productCategory;
        bytes32[] childs;
        bytes32 additionalDiscription;
        uint256 price;
        bool isConsume;
    }

    struct FinalProductsArray {
        uint256 units;
        bytes32[] FinalProductIDs;
    }

    // struct RawMaterialInfo {
    //     bytes32 RawMaterialID;
    //     bytes32 parent;
    //     bytes32 name;
    //     bytes32 groupID;
    //     address currentOwner;
    //     address supplier;
    //     bytes32[] childs;
    //     bytes32 additionalDiscription;
    //     // uint256 price;
    //     // bytes32 inventoryStoreID;        
    // }

    

    mapping(bytes32 => InventoryStoreInfo) InventoryStore;
    mapping(bytes32 => bytes32) ProductOnInventory;
    mapping(bytes32 => Product[]) ProductsInInventory;
    mapping(bytes32 => Product) ProductInfo;
    mapping(bytes32 => mapping(bytes32 =>ProductsArray)) groupIDWithInventoryProductsArray;

    mapping(bytes32 => FinalProduct) manufacturedProducts;
    mapping(bytes32 => FinalProductsArray) finalProductsArray;
    
    event InventoryRegistered(bytes32 inventoryID,bytes32 name,bytes32 city);
    event InventoryAlreadyRegistered(bytes32 inventoryID,bytes32 name, bytes32 city);
    event newFinalProductCreated(bytes32 FinalProdcutID,bytes32 Category);

    modifier isInventor(bytes32 _inventoryID) {
        if (InventoryStore[_inventoryID].inventoryHead != msg.sender) {
            assert(true);
        }
        _;
    }

    function Inventory(
        address _authorizerContractAddress,
        address _operationTeamContractAddress
    ) 
        public 
        {
        Auth = Authorizer(_authorizerContractAddress);
        opTeam = OperationTeam(_operationTeamContractAddress);
       
    }

    function viewInventoryStoreInfo(
        bytes32 _inventoryID
    ) 
        public
        constant
        returns(
            address inventoryHead,
            bytes32 inventoryName,
            bytes32 inventoryCity
        ){
        return(InventoryStore[_inventoryID].inventoryHead,InventoryStore[_inventoryID].inventoryName,InventoryStore[_inventoryID].inventoryCity);
    }

    function setRawMaterialContractAddress(address rawMaterialContractAddress) public onlyOwner returns(bool) {
         RawMat = RawMaterial(rawMaterialContractAddress);
    }
    
    function setWarehouseContractAddress(address _warehouseContractAddress) public onlyOwner returns(bool) {
        WH = Warehouse(_warehouseContractAddress);
    }
    
    function registerInventory(
        address _inventoryHead,
        bytes32 _inventoryName,
        bytes32 _inventoryCity
    )
        public
        returns(
            bytes32 _inventoryID
        ) {
        require(Auth.isRegistrar(msg.sender));
        _inventoryID = keccak256(_inventoryHead,_inventoryName,_inventoryCity);  
        // if (InventoryStore[_inventoryID].inventoryName != _inventoryName && InventoryStore[_inventoryID].inventoryName != "") {
        //     _inventoryID = keccak256(_inventoryHead,_inventoryName,_inventoryCity,block.timestamp);
        //     InventoryStoreInfo memory newInventoryStoreInfo;
        //     newInventoryStoreInfo.inventoryHead = _inventoryHead;
        //     newInventoryStoreInfo.inventoryName = _inventoryName;
        //     newInventoryStoreInfo.inventoryCity = _inventoryCity;
        //     InventoryStore[_inventoryID] = newInventoryStoreInfo;
        //     InventoryRegistered(_inventoryID,_inventoryName,_inventoryCity);
        // }

        if (InventoryStore[_inventoryID].inventoryName == "") {
        InventoryStoreInfo memory newInventoryStoreInfo;
        newInventoryStoreInfo.inventoryHead = _inventoryHead;
        newInventoryStoreInfo.inventoryName = _inventoryName;
        newInventoryStoreInfo.inventoryCity = _inventoryCity;
        InventoryStore[_inventoryID] = newInventoryStoreInfo;
        inventoryStoreList.push(_inventoryID);
        emit InventoryRegistered(_inventoryID,_inventoryName,_inventoryCity);
        } else {
            if (InventoryStore[_inventoryID].inventoryName == _inventoryName) {
                emit InventoryAlreadyRegistered(_inventoryID,InventoryStore[_inventoryID].inventoryName,InventoryStore[_inventoryID].inventoryCity);
            } else {
                    _inventoryID = keccak256(_inventoryHead,_inventoryName,_inventoryCity,block.timestamp);
                    InventoryStoreInfo memory newInventoryStoreInfoSameCity;
                    newInventoryStoreInfoSameCity.inventoryHead = _inventoryHead;
                    newInventoryStoreInfoSameCity.inventoryName = _inventoryName;
                    newInventoryStoreInfoSameCity.inventoryCity = _inventoryCity;
                    InventoryStore[_inventoryID] = newInventoryStoreInfoSameCity;
                    inventoryStoreList.push(_inventoryID);
                    emit InventoryRegistered(_inventoryID,_inventoryName,_inventoryCity);        
            }
        }
        return _inventoryID;
    }

    function requestRawMaterials(
        bytes32 _inventoryID,
        bytes32 _groupID,
        uint256 _units,
        uint256 _pricePerUnit
    ) 
        public 
        isInventor(_inventoryID)
        {
        RawMat.broadcastRawMaterialRequirement(_inventoryID,_groupID,_units,_pricePerUnit);
    }

    function recieveRawMatarials(
        bytes32 _rawMaterialID,
        // bytes32 _parent,
        bytes32 _name,
        bytes32 _groupID,
        // address _currentOwner,
        address _supplier,
        // bytes32[] _childs,
        bytes32 _additionalDiscription,
        uint256 _price,
        bytes32 _inventoryID
    )
        public
        {

        Product memory newProduct;
        newProduct.productID = _rawMaterialID;
        // newProduct.parent = _parent;
        newProduct.name = _name;
        newProduct.groupID = _groupID;
        newProduct.currentOwner = InventoryStore[_inventoryID].inventoryHead;
        newProduct.supplier = _supplier;
        // newProduct.childs = _childs;
        newProduct.additionalDiscription = _additionalDiscription;
        newProduct.price = _price;
        newProduct.inventoryStoreID = _inventoryID;

        ProductsInInventory[_inventoryID].push(newProduct);
        ProductInfo[_rawMaterialID] = newProduct;
        InventoryStore[_inventoryID].groupIdCounts[_groupID] += 1;

         if (groupIDWithInventoryProductsArray[_groupID][_inventoryID].rawMaterialsIDs.length > 0) {
            groupIDWithInventoryProductsArray[_groupID][_inventoryID].units += 1;
            tempBytesArray = groupIDWithInventoryProductsArray[_groupID][_inventoryID].rawMaterialsIDs;
            tempBytesArray.push(_rawMaterialID);
            groupIDWithInventoryProductsArray[_groupID][_inventoryID].rawMaterialsIDs = tempBytesArray;
            // delete(tempBytesArray);
            // groupIDWithInventoryProductsArray[_groupID][_inventoryID] = newProductsArray;
        } else {
            ProductsArray memory newProductsArray;
            newProductsArray.units += 1;
            tempBytesArray.push(_rawMaterialID);
            newProductsArray.rawMaterialsIDs = tempBytesArray;
            groupIDWithInventoryProductsArray[_groupID][_inventoryID] = newProductsArray;
        }
        delete(tempBytesArray);
        // emit RawMaterialRegistered(_rawMaterialID,_groupID,_inventoryID);
    }

    function searchProductByGroupID(
        bytes32 _groupID
    )
        public
        // constant
        returns(
            bytes32[] inventoryID,
            uint256[] units
        ) {
        for(uint i = 0;i < inventoryStoreList.length; i++) {
            if (groupIDWithInventoryProductsArray[_groupID][inventoryStoreList[i]].units > 0) {
                tempBytesArray.push(inventoryStoreList[i]);
                tempUintArray.push(groupIDWithInventoryProductsArray[_groupID][inventoryStoreList[i]].units);
            }
        }
        inventoryID = tempBytesArray;
        units = tempUintArray;
        delete(tempBytesArray);
        delete(tempUintArray);
        return(inventoryID,units);
    }

    function searchProductByID(
        bytes32 _productID
    )
        public
        constant
        returns(
            // bytes32 productID,
            // bytes32 parent,
            bytes32 name,
            bytes32 groupID,
            // address currentOwner,
            address supplier,
            bytes32[] childs,
            bytes32 additionalDiscription,
            uint256 price,
            bytes32 inventoryStoreID
        ) {
            return (
                // ProductInfo[_productID].productID,
                // ProductInfo[_productID].parent,
                ProductInfo[_productID].name,
                ProductInfo[_productID].groupID,
                // ProductInfo[_productID].currentOwner,
                ProductInfo[_productID].supplier,
                ProductInfo[_productID].childs,
                ProductInfo[_productID].additionalDiscription,
                ProductInfo[_productID].price,
                ProductInfo[_productID].inventoryStoreID
            );
    }

    function viewProductOwnerByID(
        bytes32 _productID
    )
        public
        constant
        returns(
            bytes32 productID,
            bytes32 name,
            bytes32 parent,
            address currentOwner
        ) {
        return (
            ProductInfo[_productID].productID,
            ProductInfo[_productID].name,
            ProductInfo[_productID].parent,
            ProductInfo[_productID].currentOwner
        );
    }

    // function getRawMaterialFromInventory(
    //     bytes32 _inventoryID,
    //     bytes32 _rawMaterialGroupID,
    //     uint256 _units
    // )
    //     external
    //     returns(
    //         bytes32[],
    //         uint256
    //     ) {
    //     require(groupIDWithInventoryProductsArray[_rawMaterialGroupID][_inventoryID].units >= _units);
    //     bytes32[] tempBArray;
    //     uint256 _priceCalculated;
    //     for (uint i = 0; i < _units ; i++) {
    //         tempBytesArray.push(groupIDWithInventoryProductsArray[_rawMaterialGroupID][_inventoryID].rawMaterialsIDs[i]);
    //         _priceCalculated = ProductInfo[groupIDWithInventoryProductsArray[_rawMaterialGroupID][_inventoryID].rawMaterialsIDs[i]].price;
    //         ProductInfo[groupIDWithInventoryProductsArray[_rawMaterialGroupID][_inventoryID].rawMaterialsIDs[i]].isConsume = true;
    //         delete(groupIDWithInventoryProductsArray[_rawMaterialGroupID][_inventoryID].rawMaterialsIDs[i]);
    //     }
    //     groupIDWithInventoryProductsArray[_rawMaterialGroupID][_inventoryID].units -= _units;
    //     tempBArray = tempBytesArray;
    //     delete(tempBytesArray);
    //     return(tempBArray,_priceCalculated);


    // }

    function getRawMaterialsFromInventory(
        address _opTeamLead,
        bytes32 _operationName,
        bytes32 _inventoryID,
        uint256 _units,
        bytes32[] _rawMaterialGroupID,
        uint256[] _rawMaterialUnits,
        bytes32 _productDescription
    )
        public
        returns(
            bool
        ) {
        require(opTeam.isOperator(_operationName,_opTeamLead)); 
        //require(operationDetails[_operationName].teamLead == msg.sender);
        // require(groupIDWithInventoryProductsArray[_rawMaterialGroupID][_inventoryID].units >= _units);
        // bytes32[] tempBArray;
        for (uint k = 0; k<_units;k++) {
            // uint256 _priceCalculated;
            // for (uint i = 0; i < _rawMaterialGroupID.length;i++) {
            //     // tempBytesArray = Invt.getRawMaterialFromInventory(_inventoryID,_rawMaterialGroupID[i],_rawMaterialUnits[i])[0];
            //     // priceCalculator += Invt.getRawMaterialFromInventory(_inventoryID,_rawMaterialGroupID[i],_rawMaterialUnits[i])[1];    
            //     bytes32 rMGid = _rawMaterialGroupID[i];
            //     // for (uint j = 0; j<_rawMaterialUnits[i];j++) {
            //     //     ProductsArray memory newProductsArray;
            //     //     newProductsArray = groupIDWithInventoryProductsArray[rMGid][_inventoryID];

            //     //     tempBytesArray.push(newProductsArray.rawMaterialsIDs[j]);
            //     //     _priceCalculated = ProductInfo[newProductsArray.rawMaterialsIDs[j]].price;
            //     //     ProductInfo[newProductsArray.rawMaterialsIDs[j]].isConsume = true;
            //     //     delete(newProductsArray.rawMaterialsIDs[j]);
            //     //     groupIDWithInventoryProductsArray[rMGid][_inventoryID] = newProductsArray;
            //     // }
            //     // groupIDWithInventoryProductsArray[rMGid][_inventoryID].units -= _rawMaterialUnits[i];
            // }
            bytes32 _productID = keccak256(_operationName,block.timestamp,k);
            FinalProduct memory newFinalProduct;
            newFinalProduct.productID = _productID;
            // newFinalProduct.parent = "Final Product";
            newFinalProduct.productCategory = _operationName;
            // newFinalProduct.childs = tempBytesArray;
            newFinalProduct.additionalDiscription = _productDescription;
            // newFinalProduct.price = _priceCalculated;
            manufacturedProducts[_productID] = newFinalProduct;            
            if (getRawForFinalProduct(_inventoryID,_rawMaterialGroupID,_rawMaterialUnits,_productID)) {
                finalProductsArray[_operationName].units += 1;
                finalProductsArray[_operationName].FinalProductIDs.push(_productID);
                newFinalProductCreated(_productID,_operationName);
            } else {
                return false;
            }
        }
        return true;
    }

    function getRawForFinalProduct(
        bytes32 _inventoryID,
        bytes32[] _rawMaterialGroupID,
        uint256[] _rawMaterialUnits,
        bytes32 _finalProductID
    )
        public
        returns(bool) {
            for (uint i = 0; i < _rawMaterialGroupID.length;i++) {
                // tempBytesArray = Invt.getRawMaterialFromInventory(_inventoryID,_rawMaterialGroupID[i],_rawMaterialUnits[i])[0];
                // priceCalculator += Invt.getRawMaterialFromInventory(_inventoryID,_rawMaterialGroupID[i],_rawMaterialUnits[i])[1];    
                bytes32 rMGid = _rawMaterialGroupID[i];
                for (uint j = 0; j<_rawMaterialUnits[i];j++) {
                        ProductsArray memory newProductsArray;
                        newProductsArray = groupIDWithInventoryProductsArray[rMGid][_inventoryID];

                        tempBytesArray.push(newProductsArray.rawMaterialsIDs[j]);
                        priceCalculated += ProductInfo[newProductsArray.rawMaterialsIDs[j]].price;
                        ProductInfo[newProductsArray.rawMaterialsIDs[j]].isConsume = true;
                        delete(newProductsArray.rawMaterialsIDs[j]);
                        groupIDWithInventoryProductsArray[rMGid][_inventoryID] = newProductsArray;
                    }
                    groupIDWithInventoryProductsArray[rMGid][_inventoryID].units -= _rawMaterialUnits[i];
            }
        manufacturedProducts[_finalProductID].price = priceCalculated;
        manufacturedProducts[_finalProductID].childs = tempBytesArray;
        return true;

    }
    

    function getManufacturedProducts(
        bytes32 _operationName
    )
        public
        constant
        returns(
            bytes32[] finalProductIDs,
            uint256 unitsAvailable
        ) {
        require(opTeam.isOperator(_operationName,msg.sender)); 
        return(finalProductsArray[_operationName].FinalProductIDs,finalProductsArray[_operationName].units);
    }
    function sendProdutsToWarehouse( bytes32 _warehouseID, bytes32 _productCategory, uint256 _units, bool _sendAllProduct ) public returns( bool ) 
    {
        opTeam.isOperator(_productCategory,msg.sender); 
        require(finalProductsArray[_productCategory].units >= _units || _sendAllProduct); 
        if(_sendAllProduct){
            _units = finalProductsArray[_productCategory].units; 
        } 
        delete(tempBytesArray); 
        delete(priceCalculated) ; 
        for( uint i = 0; i<_units;i++){ 
            tempBytesArray.push(finalProductsArray[_productCategory].FinalProductIDs[i]); priceCalculated += manufacturedProducts[finalProductsArray[_productCategory].FinalProductIDs[i]].price; 
            manufacturedProducts[finalProductsArray[_productCategory].FinalProductIDs[i]].isConsume = true; 
            finalProductsArray[_productCategory].units -= 1; 
            delete(finalProductsArray[_productCategory].FinalProductIDs[i]); 
            
        } 
        priceCalculated = (priceCalculated)/_units; 
        WH.registerProduct(msg.sender,_productCategory,tempBytesArray,priceCalculated,_warehouseID);
        return true;
    }
    // function sendProductsToWarehouse(
    //     bytes32 _warehouseID,
    //     bytes32 _productCategory,
    //     uint256 _units,
    //     bool _sendAllProduct
    // )
    //     public
    //     returns(
    //         bool
    //     ) {
    //     require(opTeam.isOperator(_productCategory,msg.sender));
    //     require(finalProductsArray[_productCategory].units >= _units || _sendAllProduct);
    //     if(_sendAllProduct){
    //         _units = finalProductsArray[_productCategory].units;
    //     }
    //     for( uint i = 0; i<_units;i++){
    //         WH.registerProduct(_productCategory,finalProductsArray[_productCategory].FinalProductIDs[i],manufacturedProducts[finalProductsArray[_productCategory].FinalProductIDs[i]].price,_warehouseID);
    //         delete(finalProductsArray[_productCategory].FinalProductIDs[i]);
    //         finalProductsArray[_productCategory].units -= 1;
    //     }
    //     return true;
    // }

    function serachFinalProductByID(
        bytes32 _finalProductID
    )
        public
        constant
        returns(
            bytes32 productID,
            bytes32 productCategory,
            bytes32[] childs,
            bytes32 additionalDiscription,
            uint256 price,
            bool isConsume
        ) {
        require(opTeam.isOperator( manufacturedProducts[_finalProductID].productCategory,msg.sender));
        return(
            manufacturedProducts[_finalProductID].productID,
            manufacturedProducts[_finalProductID].productCategory,
            manufacturedProducts[_finalProductID].childs,
            manufacturedProducts[_finalProductID].additionalDiscription,
            manufacturedProducts[_finalProductID].price,
            manufacturedProducts[_finalProductID].isConsume
        );

    }
    // function sendProductsToWarehouse(
    //     bytes32 _operationName,
    //     uint256 _units
    // )
    //     public
    //     returns(bool){
    //     require(opTeam.isOperator(_operationName,msg.sender)); 
    // }
    //bytes32 rMGid = 
}


contract Warehouse is Owned {
    
    Authorizer Auth;
    OperationTeam op;
    Manager Mgr;
    
    bytes32[] tempBytesArray;
    bytes32[] warehouseList;
    uint256[] tempUintArray;
    
    struct WarehouseInfo 
    {
        address warehouseHead;
        bytes32 warehouseName;
        bytes32 warehouseCity;
    }
    
    struct ProductInfo
    {
        bytes32 productName;
        bytes32 productID;
        uint256 price;
        bytes32 warehouseID;
        bool isConsume;
        address retailer;
    } 
    
    struct InventoryProductRequirement 
    {
        address requesterID;
        bytes32 productName;
        uint256 units;
        bytes32 pendingRequestID;
    }
    
    struct ProductsArray
    {
        uint256  units;
        bytes32[]  productIDs;
    }

    
    mapping(bytes32 => WarehouseInfo) WareHouse;
    mapping(bytes32 => ProductInfo) product;    //<productID:ProductInfo>
    // mapping(bytes32 => warehouseProductRequirement) RequirementMap;
    mapping(bytes32 => InventoryProductRequirement) RequirementMapInv;  //<productCategory:productReq>
    mapping(bytes32 => mapping(bytes32 => ProductsArray)) ProductsINFO; //<productCategory:<warehouseid:productArray>>

    event newProductRequirementOperationTeam(address _requesterID,bytes32 _productName,uint256 _units,bytes32 _pendingRequestID);
    event ProductRegistered(bytes32 _productName,uint256 _productPrice,bytes32 _productWarehouseID);
    event WarehouseRegister(address _warehouseHead,bytes32 warehouseID, bytes32 _warehouseName,bytes32 _warehouseCity);
    event SellOrderDetails(address _retailer,bytes32 _productName,uint _units, bytes32 _fromWarehouseID);
    event WarehouseAlreadyRegistered(bytes32 _warehouseID,bytes32 _WarehouseName,bytes32 _warehouseCity);
    
    
    
    function Warehouse(address _authorizerContractAddress, address _operationTeamAddress, address _managerAddress) public 
    {
        Auth = Authorizer(_authorizerContractAddress);
        op = OperationTeam(_operationTeamAddress);
        Mgr = Manager(_managerAddress);
    }

    function registerWarehouse(address _warehouseHead,bytes32 _warehouseName,bytes32 _warehouseCity)public returns(bytes32 _warehouseID)
    {
        require(Auth.isRegistrar(msg.sender));
        _warehouseID = keccak256(_warehouseHead,_warehouseName,_warehouseCity);  
        if(WareHouse[_warehouseID].warehouseName == "" )
        {
            WarehouseInfo memory newWarehouseInfo;
            newWarehouseInfo.warehouseHead = _warehouseHead;
            newWarehouseInfo.warehouseName = _warehouseName;
            newWarehouseInfo.warehouseCity = _warehouseCity;
            WareHouse[_warehouseID] = newWarehouseInfo;
            warehouseList.push(_warehouseID);
            emit WarehouseRegister(_warehouseHead,_warehouseID,_warehouseName, _warehouseCity);        
        } 
        else 
        {
            if (WareHouse[_warehouseID].warehouseName == _warehouseName) 
            {
                emit WarehouseAlreadyRegistered(_warehouseID,WareHouse[_warehouseID].warehouseName,WareHouse[_warehouseID].warehouseCity);
            }
            else 
            {
                    _warehouseID = keccak256(_warehouseHead,_warehouseName,_warehouseCity,block.timestamp);
                    WarehouseInfo memory newWareHouseSubBranch;
                    newWareHouseSubBranch.warehouseHead = _warehouseHead;
                    newWareHouseSubBranch.warehouseName = _warehouseName;
                    newWareHouseSubBranch.warehouseCity = _warehouseCity;
                    WareHouse[_warehouseID] = newWareHouseSubBranch;
                    warehouseList.push(_warehouseID);
                   emit WarehouseRegister(_warehouseHead,_warehouseID,_warehouseName, _warehouseCity);
            }
        }
        return _warehouseID;
    }
    
    function registerProduct(address _operationLead,bytes32 _productName,bytes32[] _productID,uint256 _productPrice,bytes32 _productWarehouseID) public returns (bool)
    {
        require(op.isOperator(_productName,_operationLead));
        for(uint i=0;i<_productID.length;i++)
        {
            ProductInfo memory newProductInfo;
            newProductInfo.productName = _productName;
            newProductInfo.productID = _productID[i];
            newProductInfo.price = _productPrice;
            newProductInfo.warehouseID = _productWarehouseID;
            product[_productID[i]] = newProductInfo;
        }

        if(ProductsINFO[_productName][_productWarehouseID].units > 0 )
        {
            ProductsINFO[_productName][_productWarehouseID].units += _productID.length;
            tempBytesArray = ProductsINFO[_productName][_productWarehouseID].productIDs;
            for(uint j=0;j<_productID.length;j++)
            {
                tempBytesArray.push(_productName);
            }
            ProductsINFO[_productName][_productWarehouseID].productIDs = tempBytesArray;            
        }
        else
        {
            ProductsArray memory newProductsArray;
            newProductsArray.units += _productID.length;
            newProductsArray.productIDs = _productID;
            ProductsINFO[_productName][_productWarehouseID] = newProductsArray;
        }
        delete tempBytesArray;
        
        emit ProductRegistered(_productName,_productPrice,_productWarehouseID);
        // _productID
        return true;
    }
    
    function searchWarehouseDetails(bytes32 _warehouseAddress) constant public returns (bytes32,address,bytes32,bytes32)
    {
        require(Mgr.isManager(msg.sender));
        return(_warehouseAddress, WareHouse[_warehouseAddress].warehouseHead, WareHouse[_warehouseAddress].warehouseName, WareHouse[_warehouseAddress].warehouseCity);
    }


    // function searchProductDetailsbyName(bytes32 _searchProduct) public constant returns (bytes32 productName, uint price, bytes32 warehouseID, bool isConsume , address retailer)
    // {
    //     require(Mgr.isManager(msg.sender)); 
    //     return (product[_searchProduct].productName, product[_searchProduct].price, product[_searchProduct].warehouseID, product[_searchProduct].isConsume, product[_searchProduct].retailer);  
    // }

    function viewStock (bytes32 _productName) public returns (bytes32[] ListofWarehouseID,uint[] ListofUnits)
    {
        for(uint i = 0;i < warehouseList.length; i++)
        {
            if (ProductsINFO[_productName][warehouseList[i]].units > 0)
            {
                tempBytesArray.push(warehouseList[i]);
                tempUintArray.push(ProductsINFO[_productName][warehouseList[i]].units);
            }
        }
        ListofWarehouseID = tempBytesArray;
        ListofUnits = tempUintArray;
        delete(tempBytesArray);
        delete(tempUintArray);
        return(ListofWarehouseID,ListofUnits);
        // return ProductsINFO[_productName][_fromWarehouse].units ;
    }

    function requestProductforRetailer(address _retailer,address _retailerContractAddress, bytes32 _productName, uint256 _units, bytes32 _fromWarehouseID) public returns (bool)
    {
        bytes32 pendingRequestID  = keccak256(_retailer,_productName,_units);
        if( ProductsINFO[_productName][_fromWarehouseID].units >= _units)
        {
            SellProductTOretailer(_retailer,_retailerContractAddress ,_productName,_units, _fromWarehouseID);
            return true;
        }
        else
        {
            if(ProductsINFO[_productName][_fromWarehouseID].units > 0)
            {
                _units = ProductsINFO[_productName][_fromWarehouseID].units - _units;
            }
            broadcastProductRequirement(_retailer,_productName,_units,pendingRequestID);
        }
    }

    function broadcastProductRequirement(address _requesterID,bytes32 _productName,uint256 _units,bytes32 _pendingRequestID) public
    {
        require(Mgr.isManager(msg.sender));
        InventoryProductRequirement memory newInventoryProductRequirement;
        newInventoryProductRequirement.requesterID = _requesterID;
        newInventoryProductRequirement.productName = _productName;
        newInventoryProductRequirement.units += _units;
        newInventoryProductRequirement.pendingRequestID = _pendingRequestID;
        RequirementMapInv[_productName] = newInventoryProductRequirement;
        emit newProductRequirementOperationTeam( _requesterID,_productName, _units,_pendingRequestID);
    }

    function searchWarehouseByProductID(bytes32 _productID) public constant returns(bytes32 _warehouseID)
    {
        require(Mgr.isManager(msg.sender));
        return product[_productID].warehouseID;
    }

    function searchProductDetailsbyID(bytes32 _productID)constant public returns (bytes32,uint,bytes32,bool,address)
    {
        if(product[_productID].productID == _productID)
        {
            return(product[_productID].productName, product[_productID].price, product[_productID].warehouseID, product[_productID].isConsume, product[_productID].retailer);
        }
        
    }

    function viewProductPendingRequirment(bytes32 _productName, bytes32 _fromWarehouse)constant public returns (address requesterID, bytes32 requestedProductName, uint units, uint inStock) 
    // uint instock
    {
        // require(Mgr.isManager(msg.sender));
        // require(productRequirment[_productName].units!=0);
        require(RequirementMapInv[_productName].units!=0);     
        return (RequirementMapInv[_productName].requesterID,RequirementMapInv[_productName].productName,RequirementMapInv[_productName].units, ProductsINFO[_productName][_fromWarehouse].units);                   
        // return (productRequirment[_productName].requesterID,productRequirment[_productName].productName,productRequirment[_productName].units);
    }
    
    function SellProductTOretailer(address _retailer,address _retailerContractAddress, bytes32 _productName,uint _units, bytes32 _fromWarehouseID) public returns (bytes32)
    {
        require(Mgr.isManager(msg.sender));
        if (Mgr.productsRequirementFullFilled(msg.sender,_retailer,_productName,_units)) {

            for(uint i=0; i<=_units;i++)
            {
                if(!(product[ProductsINFO[_productName][_fromWarehouseID].productIDs[i]].isConsume))
                {
                    product[ProductsINFO[_productName][_fromWarehouseID].productIDs[i]].isConsume = true;
                    product[ProductsINFO[_productName][_fromWarehouseID].productIDs[i]].retailer = _retailer;
                    // ProductsINFO[_productName][_fromWarehouseID].productIDS[i].isConsume == true;
                    // ProductsINFO[_productName][_fromWarehouseID].productIDS[i].retailer == _retailer;
                    ProductsINFO[_productName][_fromWarehouseID].units -= 1;
                    Retailer ret = Retailer(_retailerContractAddress);
                    ret.recieveProduct(ProductsINFO[_productName][_fromWarehouseID].productIDs[i],_retailer,_productName,product[ProductsINFO[_productName][_fromWarehouseID].productIDs[i]].price);
                    delete(ProductsINFO[_productName][_fromWarehouseID].productIDs[i]);
                }
            }
            bytes32 SellOrderID = keccak256(_retailer,_productName,_units,_fromWarehouseID);
            emit SellOrderDetails( _retailer,_productName,_units,_fromWarehouseID);              
            return SellOrderID;
        }
        
    }

}

contract Retailer is Owned {
    Manager Mgr;
    Authorizer Auth;

    struct RetailerDetails {
        address retailerAddress;
        bytes32 retailerName;
        bytes32 retailerCity;
       
    }
    
    struct Product {
        bytes32 productID;
        bytes32 category;
        uint256 price;
        address retailerAddress;
        bool isConsume;
    }
    
    mapping(address => RetailerDetails) RetailerList;
    mapping(bytes32 => Product) ProductDetails;
    //mapping(address => Product) RetailerStoreProductDetails;
    mapping(bytes32 => mapping(address => bytes32[])) ProductArrayOnRetailer;

    event RetailerAlreadyRegistered(bytes32 retailerName,bytes32 city);
    
    modifier isRetailer() {
        if(msg.sender == RetailerList[msg.sender].retailerAddress) {
            assert(true);
        }
        _;
    }

    function Retailer(
        address _authorizerContractAddress,
        address _managerContractAddress
    ) 
        public 
        {
        Auth = Authorizer(_authorizerContractAddress);
        Mgr = Manager(_managerContractAddress);
    }

    function addRetailer(
        address _retailer, 
        bytes32 _retailerName, 
        bytes32 _retailerCity
    ) 
        public
        {
        require(Auth.isRegistrar(msg.sender));
        
        RetailerDetails memory newRetailer;
        newRetailer.retailerName = _retailerName;
        newRetailer.retailerCity = _retailerCity;
        RetailerList[_retailer] = newRetailer;
    }

    function viewRetailer(
        address _retailer
    ) 
        public 
        constant 
        returns(
            bytes32 _retailerName, 
            bytes32 _retailerCity
        ) {
        require(msg.sender == owner || msg.sender == _retailer);
        return (RetailerList[_retailer].retailerName,RetailerList[_retailer].retailerCity);
    }
     
    function requestProduct(
        bytes32 _productCategory,
        uint256 _units
    ) 
        isRetailer
        public 
        {
        Mgr.broadcastProductRequirement(msg.sender,_productCategory,_units);
    }

    function recieveProduct(
        bytes32 _productID,
        address _retailerAddress,
        bytes32 _category,
        uint256 _price
    )
        public
        {
        Product memory newProduct;
        newProduct.productID = _productID;
        newProduct.category = _category;
        newProduct.price = _price;
        newProduct.retailerAddress = _retailerAddress;
        ProductDetails[_productID] = newProduct;
    }
    
    function searchProductByCategory(
        bytes32 _productCategory
    )
        public
        constant
        returns(
            bytes32[] ProductID,
            uint256 ProductCategory
        ) {
        return (
            ProductArrayOnRetailer[_productCategory][msg.sender],
            ProductArrayOnRetailer[_productCategory][msg.sender].length
        );
    }

    function serachProductByID(
        bytes32 _productID
    )
        public
        constant
        isRetailer
        returns(
            bytes32 ProductID,
            bytes32 ProductCategory,
            uint256 ProductPrice,
            address ProductOwner,
            bool SoldOut
        ) {
        return(
            ProductDetails[_productID].productID,
            ProductDetails[_productID].category,
            ProductDetails[_productID].price,
            ProductDetails[_productID].retailerAddress,
            ProductDetails[_productID].isConsume
            );
    }

}