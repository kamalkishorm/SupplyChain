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

    modifier isInventor(bytes32 _inventorID) {
        if(InventoryStore[_inventorID].inventoryHead != msg.sender){
            assert(true);
        }
    }

    mapping(bytes32 => InventoryStoreInfo) InventoryStore;
    mapping(bytes32 => bytes32) ProductOnInventory;
    mapping(bytes32 => Product[]) ProductsInInventory;
    mapping(bytes32 => Product) ProductInfo;
    
    function Inventory(
        address authorizerContractAddress, 
        address rowMatrialContractAddress
    ) 
        public 
        {
        Auth = Authorizer(authorizerContractAddress);
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
        bytes32 _groupID
    ) 
        public 
        isInventor(_inventorID)
        {
        
    }
}