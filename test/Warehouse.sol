pragma solidity ^0.4.18;
import './Manager.sol';
import './Inventory.sol';
import './Authorizer.sol';

contract Warehouse is Owned 
{
    
    Authorizer Auth;
    Inventory Inv;
    Manager Mgr;
    
    bytes32[] tempBytesArray;
    
    struct WarehouseInfo 
    {
<<<<<<< HEAD
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
    
    // struct warehouseProductRequirement 
    // {
    //     bytes32 requesterID;
    //     bytes32 productName;
    //     uint256 units;
    // }

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
    mapping(bytes32 => ProductInfo) product;
    // mapping(bytes32 => warehouseProductRequirement) RequirementMap;
    mapping(bytes32 => InventoryProductRequirement) RequirementMapInv;

    mapping(bytes32 => mapping(bytes32 => ProductsArray)) ProductsINFO;

    event newProductRequirementOperationTeam(address _requesterID,bytes32 _productName,uint256 _units,bytes32 _pendingRequestID);
    event ProductRegistered(bytes32 _productName,uint256 _productPrice,bytes32 _productWarehouseID);
    event WarehouseRegister(address _warehouseHead,bytes32 warehouseID, bytes32 _warehouseName,bytes32 _warehouseCity);
    event SellOrderDetails(address _retailer,bytes32 _productName,uint _units, bytes32 _fromWarehouseID);
    
    
    
    function Warehouse(address _authorizerContractAddress, address _inventoryAddress, address _managerAddress) public 
    {
        Auth = Authorizer(_authorizerContractAddress);
        Inv = Inventory(_inventoryAddress);
        Mgr = Manager(_managerAddress);
    }

    function registerWarehouse(address _warehouseHead,bytes32 _warehouseName,bytes32 _warehouseCity)public returns(bytes32 _warehouseID)
    {
        // require(Auth.isRegistrar(msg.sender));
        _warehouseID = keccak256(_warehouseHead,_warehouseName,_warehouseCity);  
        WarehouseInfo memory newWarehouseInfo;
        newWarehouseInfo.warehouseHead = _warehouseHead;
        newWarehouseInfo.warehouseName = _warehouseName;
        newWarehouseInfo.warehouseCity = _warehouseCity;
        WareHouse[_warehouseID] = newWarehouseInfo;
        // emit InventoryRegistered(_inventoryID,_inventoryName,_inventoryCity);
        return _warehouseID;
        emit WarehouseRegister(_warehouseHead,_warehouseID,_warehouseName, _warehouseCity);
    }
    
    function registerProduct(bytes32 _productName,bytes32[] _productID,uint256 _productPrice,bytes32 _productWarehouseID) public returns (bool)
    {
        // require(Auth.isRegistrar(msg.sender));
    // if()
        ProductInfo memory newProductInfo;
        newProductInfo.productName = _productName;
        newProductInfo.productID = _productID;
        newProductInfo.price = _productPrice;
        newProductInfo.warehouseID = _productWarehouseID;
        product[_productName] = newProductInfo;

        if(ProductsINFO[_productName][_productWarehouseID].units > 0 )
=======
        
        Authorizer Auth;
        Inventory Inv;
        
         bytes32[] tempBytesArray;
         
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
        
        struct warehouseProductRequirement 
>>>>>>> f440ae00b37448efbc9b99c40efac1d201786345
        {
            ProductsINFO[_productName][_productWarehouseID].units += 1;
            tempBytesArray = ProductsINFO[_productName][_productWarehouseID].productIDs;
            tempBytesArray.push(_productName);
            ProductsINFO[_productName][_productWarehouseID].productIDs = tempBytesArray;
        }
<<<<<<< HEAD
        else
=======

        struct InventoryProductRequirement 
        {
            bytes32 requesterID;
            bytes32 productName;
            uint256 units;
        }
        
        struct ProductsArray
>>>>>>> f440ae00b37448efbc9b99c40efac1d201786345
        {
            ProductsArray memory newProductsArray;
            newProductsArray.units += 1;
            tempBytesArray.push(_productName);
            newProductsArray.productIDs = tempBytesArray;
            ProductsINFO[_productName][_productWarehouseID] = newProductsArray;
        }
        delete tempBytesArray;
        
<<<<<<< HEAD
        emit ProductRegistered(_productName,_productPrice,_productWarehouseID);
        // _productID
        return true;
    }
=======
        mapping(bytes32 => WarehouseInfo) WareHouse;
        mapping(bytes32 => ProductInfo) product;
        mapping(bytes32 => warehouseProductRequirement) RequirementMap;
        mapping(bytes32 => InventoryProductRequirement) RequirementMapInv;

        mapping(bytes32 => mapping(bytes32 => ProductsArray)) ProductsINFO;

        event newProductRequirementOperationTeam(bytes32 _requesterID,bytes32 _productName,uint256 _units);
        event ProductRegistered(bytes32 _productName,bytes32 _productID,uint256 _productPrice,bytes32 _productWarehouseID);
        event WarehouseRegister(address _warehouseHead,bytes32 warehouseID, bytes32 _warehouseName,bytes32 _warehouseCity);
        
        
>>>>>>> f440ae00b37448efbc9b99c40efac1d201786345
        
    function searchProductDetailsbyName(bytes32 _searchProduct) public constant returns (bytes32 productName, uint price, bytes32 warehouseID, bool isConsume , address retailer)
    {
        require(Mgr.isManager(msg.sender));
        return (product[_searchProduct].productName, product[_searchProduct].price, product[_searchProduct].warehouseID, product[_searchProduct].isConsume, product[_searchProduct].retailer);  
    }

    function viewStock (bytes32 _productName, bytes32 _fromWarehouse) returns (uint)
    {
        return ProductsINFO[_productName][_fromWarehouse].units ;
    }

    function requestProductforRetailer(address _retailer, bytes32 _productName, uint256 _units, bytes32 _fromWarehouseID) public returns (bool)
    {
        // broadcastProductRequirement(_requesterID,_productName,_units);
        bytes32 pendingRequestID  = keccak256(_retailer,_productName,_units);
        if( ProductsINFO[_productName][_fromWarehouseID].units >= _units)
        {
<<<<<<< HEAD
            SellProductTOretailer(_retailer,_productName,_units, _fromWarehouseID);
            // newProductRequirement(_requesterID,_productName,_units);
            return true;
=======
            // require(Auth.isRegistrar(msg.sender));
            _warehouseID = keccak256(_warehouseHead,_warehouseName,_warehouseCity);  
            WarehouseInfo memory newWarehouseInfo;
            newWarehouseInfo.warehouseHead = _warehouseHead;
            newWarehouseInfo.warehouseName = _warehouseName;
            newWarehouseInfo.warehouseCity = _warehouseCity;
            WareHouse[_warehouseID] = newWarehouseInfo;
            // emit InventoryRegistered(_inventoryID,_inventoryName,_inventoryCity);
            return _warehouseID;
            emit WarehouseRegister(_warehouseHead,_warehouseID,_warehouseName, _warehouseCity);
>>>>>>> f440ae00b37448efbc9b99c40efac1d201786345
        }
        else
        {
            if(ProductsINFO[_productName][_fromWarehouseID].units > 0)
            {
                _units = ProductsINFO[_productName][_fromWarehouseID].units - _units;
            }
<<<<<<< HEAD
            broadcastProductRequirement(_retailer,_productName,ProductsINFO[_productName][_fromWarehouseID].units - _units,pendingRequestID);
=======
            else
            {
                ProductsArray memory newProductsArray;
                newProductsArray.units += 1;
                tempBytesArray.push(_productID);
                newProductsArray.productIDs = tempBytesArray;
                ProductsINFO[_productID][_productWarehouseID] = newProductsArray;
            }
            delete tempBytesArray;
            emit ProductRegistered(_productName,_productID,_productPrice,_productWarehouseID);
            return true;
        }
            
        function searchProduct(bytes32 _searchProduct) public constant returns (bytes32 productName, uint price, bytes32 warehouseID, bool isConsume , address retailer)
        {
            return (product[_searchProduct].productName, product[_searchProduct].price, product[_searchProduct].warehouseID, product[_searchProduct].isConsume, product[_searchProduct].retailer);   
>>>>>>> f440ae00b37448efbc9b99c40efac1d201786345
        }
    }


<<<<<<< HEAD

    // function newProductRequirement(bytes32 _requesterID , bytes32 _productName,uint256 _units) public 
    // {
        
    //     warehouseProductRequirement memory newProductRequirement;
    //     newProductRequirement.requesterID = _requesterID;
    //     newProductRequirement.productName = _productName;
    //     newProductRequirement.units += _units;
    //     // productRequirment[_productName] = newProductRequirement;
    //     RequirementMap[_productName] = newProductRequirement;
    // }

    function broadcastProductRequirement(address _requesterID,bytes32 _productName,uint256 _units,bytes32 _pendingRequestID) public
    {
        require(Mgr.isManager(msg.sender));
        InventoryProductRequirement memory newInventoryProductRequirement;
        newInventoryProductRequirement.requesterID = _requesterID;
        newInventoryProductRequirement.productName = _productName;
        newInventoryProductRequirement.units += _units;
        newInventoryProductRequirement.pendingRequestID = _pendingRequestID;
        // productRequirment[_productName] = newProductRequirement;
        RequirementMapInv[_productName] = newInventoryProductRequirement;
        emit newProductRequirementOperationTeam( _requesterID,_productName, _units,_pendingRequestID);
    }

    function searchWarehouseByProductName(bytes32 _productName) public constant returns(bytes32 _warehouseID)
    {
        require(Mgr.isManager(msg.sender));
        return product[_productName].warehouseID;
    }
=======
        function requestProduct(bytes32 _requesterID, bytes32 _productName, uint256 _units, bytes32 _fromWarehouseID) public returns (bool)
        {
            // broadcastProductRequirement(_requesterID,_productName,_units);
            if( ProductsINFO[_productName][_fromWarehouseID].units >= _units)
            {
                newProductRequirement(_requesterID,_productName,_units);
                return true;
            }
            else
            {
                broadcastProductRequirement(_requesterID,_productName,_units);
            }
        }

        function newProductRequirement(bytes32 _requesterID , bytes32 _productName,uint256 _units) public 
        {
            
            warehouseProductRequirement memory newProductRequirement;
            newProductRequirement.requesterID = _requesterID;
            newProductRequirement.productName = _productName;
            newProductRequirement.units += _units;
            // productRequirment[_productName] = newProductRequirement;
            RequirementMap[_productName] = newProductRequirement;
        }

        function broadcastProductRequirement(bytes32 _requesterID,bytes32 _productName,uint256 _units) public
        {
            InventoryProductRequirement memory newInvProductRequirement;
            newInvProductRequirement.requesterID = _requesterID;
            newInvProductRequirement.productName = _productName;
            newInvProductRequirement.units += _units;
            // productRequirment[_productName] = newProductRequirement;
            RequirementMapInv[_productName] = newInvProductRequirement;
            emit newProductRequirementOperationTeam( _requesterID,_productName, _units);
        }
>>>>>>> f440ae00b37448efbc9b99c40efac1d201786345


<<<<<<< HEAD
    function viewProductPendingRequirment(bytes32 _productName, bytes32 _fromWarehouse) external returns (address requesterID, bytes32 requestedProductName, uint units, uint inStock) 
    // uint instock
    {
        require(Mgr.isManager(msg.sender));
        // require(productRequirment[_productName].units!=0);
        require(RequirementMapInv[_productName].units!=0);     
        return (RequirementMapInv[_productName].requesterID,RequirementMapInv[_productName].productName,RequirementMapInv[_productName].units, ProductsINFO[_productName][_fromWarehouse].units);                   
        // return (productRequirment[_productName].requesterID,productRequirment[_productName].productName,productRequirment[_productName].units);
    }
    
    function SellProductTOretailer(address _retailer,bytes32 _productName,uint _units, bytes32 _fromWarehouseID) public returns (bytes32)
    {
        require(Mgr.isManager(msg.sender));
        if (Mgr.productsRequirementFullFill(_retailer,_productName,_units)) {

            for(uint i=0; i<=_units;i++)
            {
                if(!(product[ProductsINFO[_productName][_fromWarehouseID].productIDs[i]].isConsume))
                {
                    product[ProductsINFO[_productName][_fromWarehouseID].productIDs[i]].isConsume = true;
                    product[ProductsINFO[_productName][_fromWarehouseID].productIDs[i]].retailer = _retailer;
                    ProductsINFO[_productName][_fromWarehouseID].units -= 1;
                    delete(ProductsINFO[_productName][_fromWarehouseID].productIDs[i]);
                }
            }
            bytes32 SellOrderID = keccak256(_retailer,_productName,_units,_fromWarehouseID);
            emit SellOrderDetails( _retailer,_productName,_units,_fromWarehouseID);              
            return SellOrderID;
=======
        function viewProductRequirment(bytes32 _productName, bytes32 _fromWarehouse) external returns (bytes32 requesterID, bytes32 requestedProductName, uint units, uint inStock) 
        // uint instock
        {
            // require(productRequirment[_productName].units!=0);
            require(RequirementMap[_productName].units!=0);     
            return (RequirementMap[_productName].requesterID,RequirementMap[_productName].productName,RequirementMap[_productName].units, ProductsINFO[_productName][_fromWarehouse].units);                   
            // return (productRequirment[_productName].requesterID,productRequirment[_productName].productName,productRequirment[_productName].units);
        }
        
        function SellProductTOretailer(address _retailer,bytes32 _productName, bytes32 _productIDtoTransfer, bytes32 __fromWarehouseID) public
        {
            // require(Auth.isValidator(msg.sender));
            require(RequirementMap[_productName].units <= ProductsINFO[_productName][__fromWarehouseID].units);
            if(product[_productIDtoTransfer].isConsume == false)
            {
                product[_productIDtoTransfer].isConsume == true;
                product[_productIDtoTransfer].retailer == _retailer;
            }
>>>>>>> f440ae00b37448efbc9b99c40efac1d201786345
        }
    }
    

}