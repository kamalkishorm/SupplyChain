pragma solidity ^0.4.18;
import './RawMaterial.sol';
import './Authorizer.sol';
import './Owned.sol';
import './OperationTeam.sol';
import './Warehouse.sol';

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
        require(_sendAllProduct || finalProductsArray[_productCategory].units >= _units); 
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