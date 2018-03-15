pragma solidity ^0.4.18;
import './RawMatrial.sol';
import './Authorizer.sol';

contract Inventory is Owned {
    
    Authorizer Auth;
    RawMatrial RawMat;

    bytes32[] inventoryStoreList;
    bytes32[] tempBytesArray;
    uint256[] tempUintArray;

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
    }
    // struct RawMatrialInfo {
    //     bytes32 RawMatrialID;
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

    struct ProductsArray {
        uint256 units;
        bytes32[] rawMatrialsIDs;
    }

    mapping(bytes32 => InventoryStoreInfo) InventoryStore;
    mapping(bytes32 => bytes32) ProductOnInventory;
    mapping(bytes32 => Product[]) ProductsInInventory;
    mapping(bytes32 => Product) ProductInfo;
    mapping(bytes32 => mapping(bytes32 =>ProductsArray)) groupIDWithInventoryProductsArray;
    
    event InventoryRegistered(bytes32 inventoryID,bytes32 name,bytes32 city);
    event InventoryAlreadyRegistered(bytes32 inventoryID,bytes32 name, bytes32 city);

    modifier isInventor(bytes32 _inventorID) {
        if (InventoryStore[_inventorID].inventoryHead != msg.sender) {
            assert(true);
        }
        _;
    }

    function Inventory(
        address authorizerContractAddress
    ) 
        public 
        {
        Auth = Authorizer(authorizerContractAddress);
       
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

    function setRawMaterialContractAddress(address rawMatrialContractAddress) public onlyOwner returns(bool) {
         RawMat = RawMatrial(rawMatrialContractAddress);
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

    function requestRawMatrials(
        bytes32 _inventorID,
        bytes32 _groupID,
        uint256 _units,
        uint256 _pricePerUnit
    ) 
        public 
        isInventor(_inventorID)
        {
        RawMat.broadcastRawMatrialRequirement(_inventorID,_groupID,_units,_pricePerUnit);
    }

    function recieveRawMatarials(
        bytes32 _rawMatrialID,
        // bytes32 _parent,
        bytes32 _name,
        bytes32 _groupID,
        // address _currentOwner,
        address _supplier,
        // bytes32[] _childs,
        bytes32 _additionalDiscription,
        uint256 _price,
        bytes32 _inventorID
    )
        public
        {

        Product memory newProduct;
        newProduct.productID = _rawMatrialID;
        // newProduct.parent = _parent;
        newProduct.name = _name;
        newProduct.groupID = _groupID;
        newProduct.currentOwner = InventoryStore[_inventorID].inventoryHead;
        newProduct.supplier = _supplier;
        // newProduct.childs = _childs;
        newProduct.additionalDiscription = _additionalDiscription;
        newProduct.price = _price;
        newProduct.inventoryStoreID = _inventorID;

        ProductsInInventory[_inventorID].push(newProduct);
        ProductInfo[_rawMatrialID] = newProduct;
        InventoryStore[_inventorID].groupIdCounts[_groupID] += 1;

         if (groupIDWithInventoryProductsArray[_groupID][_inventorID].rawMatrialsIDs.length > 0) {
            groupIDWithInventoryProductsArray[_groupID][_inventorID].units += 1;
            tempBytesArray = groupIDWithInventoryProductsArray[_groupID][_inventorID].rawMatrialsIDs;
            tempBytesArray.push(_rawMatrialID);
            groupIDWithInventoryProductsArray[_groupID][_inventorID].rawMatrialsIDs = tempBytesArray;
            // delete(tempBytesArray);
            // groupIDWithInventoryProductsArray[_groupID][_inventorID] = newProductsArray;
        } else {
            ProductsArray memory newProductsArray;
            newProductsArray.units += 1;
            tempBytesArray.push(_rawMatrialID);
            newProductsArray.rawMatrialsIDs = tempBytesArray;
            groupIDWithInventoryProductsArray[_groupID][_inventorID] = newProductsArray;
        }
        delete(tempBytesArray);
        // emit RawMatrialRegistered(_rawMatrialID,_groupID,_inventorID);
    }

    function searchProductByGroupID(
        bytes32 _groupID
    )
        public
        constant
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
            bytes32 productID,
            bytes32 parent,
            bytes32 name,
            bytes32 groupID,
            address currentOwner,
            address supplier,
            bytes32[] childs,
            bytes32 additionalDiscription,
            uint256 price,
            bytes32 inventoryStoreID
        ) {
            return (
                ProductInfo[_productID].productID,
                ProductInfo[_productID].parent,
                ProductInfo[_productID].name,
                ProductInfo[_productID].groupID,
                ProductInfo[_productID].currentOwner,
                ProductInfo[_productID].supplier,
                ProductInfo[_productID].childs,
                ProductInfo[_productID].additionalDiscription,
                ProductInfo[_productID].price,
                ProductInfo[_productID].inventoryStoreID
            );
    }
}