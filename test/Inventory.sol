pragma solidity ^0.4.18;
import './RowMatrial.sol';
import './Authorizer.sol';

contract Inventory is Owned {
    
    Authorizer Auth;
    RowMatrial RowMat;

    struct InventoryStoreInfo {
        address inventoryHead;
        bytes32 inventoryName;
        bytes32 inventoryCity;
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
    // struct RowMatrialInfo {
    //     bytes32 rowMatrialID;
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

    modifier isInventor(bytes32 _inventorID) {
        if(InventoryStore[_inventorID].inventoryHead != msg.sender) {
            assert(true);
        }
        _;
    }

    mapping(bytes32 => InventoryStoreInfo) InventoryStore;
    mapping(bytes32 => bytes32) ProductOnInventory;
    mapping(bytes32 => Product[]) ProductsInInventory;
    mapping(bytes32 => Product) ProductInfo;
    
    function Inventory(
        address authorizerContractAddress
       // address rowMatrialContractAddress
    ) 
        public 
        {
        Auth = Authorizer(authorizerContractAddress);
       
    }
    function setRawMaterialContractAddress(address rowMatrialContractAddress) public onlyOwner returns(bool){
         RowMat = RowMatrial(rowMatrialContractAddress);
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
        require(InventoryStore[_inventoryID].inventoryName == "");

        _inventoryID = keccak256(_inventoryHead,_inventoryName,_inventoryCity);
        InventoryStoreInfo memory newInventoryStoreInfo;
        newInventoryStoreInfo.inventoryHead = _inventoryHead;
        newInventoryStoreInfo.inventoryName = _inventoryName;
        newInventoryStoreInfo.inventoryCity = _inventoryCity;
        InventoryStore[_inventoryID] = newInventoryStoreInfo;

        return _inventoryID;
    }

    function requestRowMatrials(
        bytes32 _inventorID,
        bytes32 _groupID,
        uint256 _units
    ) 
        public 
        isInventor(_inventorID)
        {
        
    }

    function recieveRawMatarials(
        bytes32 _rowMatrialID,
        // bytes32 _parent,
        bytes32 _name,
        bytes32 _groupID,
        address _currentOwner,
        address _supplier,
        // bytes32[] _childs,
        bytes32 _additionalDiscription,
        uint256 _price,
        bytes32 _inventorID
    )
        public
        {

        Product memory newProduct;
        newProduct.productID = _rowMatrialID;
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
        ProductInfo[_rowMatrialID] = newProduct;
    }
}
