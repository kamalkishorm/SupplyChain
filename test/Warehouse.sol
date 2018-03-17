    pragma solidity ^0.4.18;
    import './Manager.sol';
    import './Inventory.sol';
    import './Authorizer.sol';

    contract Warehouse is Owned 
    {
        
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
        
        struct ProductRequirement 
        {
            bytes32 requesterID;
            bytes32 productName;
            uint256 units;
        }

        struct ProductsArray
        {
            uint256  units;
            bytes32[]  productIDs;
        }
        
        mapping(bytes32 => WarehouseInfo) WareHouse;
        mapping(bytes32 => ProductInfo) product;
        mapping(bytes32 => ProductRequirement) RequirementMap;
        
        mapping(bytes32 => mapping(bytes32 => ProductsArray)) ProductsINFO;
        
        
        
        // function Warehouse(address authorizerContractAddress, address inventory_address) public 
        // {
        //     Auth = Authorizer(authorizerContractAddress);
        //     Inv = Inventory(inventory_address);
        // }

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
        }
        
        function registerProduct(bytes32 _productName,bytes32 _productID,uint256 _productPrice,bytes32 _productWarehouseID) public returns (bool)
        {
            // require(Auth.isRegistrar(msg.sender));
        // if()
            ProductInfo memory newProductInfo;
            newProductInfo.productName = _productName;
            newProductInfo.productID = _productID;
            newProductInfo.price = _productPrice;
            newProductInfo.warehouseID = _productWarehouseID;
            product[_productID] = newProductInfo;

            if(ProductsINFO[_productID][_productWarehouseID].units > 0 )
            {
                ProductsINFO[_productID][_productWarehouseID].units += 1;
                tempBytesArray = ProductsINFO[_productID][_productWarehouseID].productIDs;
                tempBytesArray.push(_productID);
                ProductsINFO[_productID][_productWarehouseID].productIDs = tempBytesArray;
            }
            else
            {
                ProductsArray memory newProductsArray;
                newProductsArray.units += 1;
                tempBytesArray.push(_productID);
                newProductsArray.productIDs = tempBytesArray;
                ProductsINFO[_productID][_productWarehouseID] = newProductsArray;
            }
            delete tempBytesArray;
            return true;
        }
            
        function searchProduct(bytes32 _searchProduct) public constant returns (bytes32 productName, uint price, bytes32 warehouseID, bool isConsume , address retailer)
        {
            return (product[_searchProduct].productName, product[_searchProduct].price, product[_searchProduct].warehouseID, product[_searchProduct].isConsume, product[_searchProduct].retailer);
            
        }


        function requestProduct(bytes32 _requesterID, bytes32 _productName,uint256 _units) public 
        {
            broadcastProductRequirement(_requesterID,_productName,_units);
        }

        function broadcastProductRequirement(bytes32 _requesterID,bytes32 _productName,uint256 _units) public 
        {
            
            ProductRequirement memory newProductRequirement;
            newProductRequirement.requesterID = _requesterID;
            newProductRequirement.productName = _productName;
            newProductRequirement.units += _units;
            // productRequirment[_productName] = newProductRequirement;
            RequirementMap[_productName] = newProductRequirement;
        }


        function searchWarehouseByGroupID(bytes32 _productName) public constant returns(bytes32 _warehouseID)
        {
            return product[_productName].warehouseID;
        }

        function viewProductRequirment(bytes32 _productName, bytes32 _fromWarehouse) public constant returns (bytes32 requesterID, bytes32 requestedProductName, uint units, uint inStock) 
        // uint instock
        {
            // require(productRequirment[_productName].units!=0);
            require(RequirementMap[_productName].units!=0);     
            return (RequirementMap[_productName].requesterID,RequirementMap[_productName].productName,RequirementMap[_productName].units, ProductsINFO[_productName][_fromWarehouse].units);                   
            // return (productRequirment[_productName].requesterID,productRequirment[_productName].productName,productRequirment[_productName].units);
        }
        
        function SellProductTOretailer(address _newOwner,bytes32 _productName, bytes32[] _productIDtoTransfer, bytes32 __fromWarehouseID) public
        {
            // require(Auth.isValidator(msg.sender));
            require(RequirementMap[_productName].units <= ProductsINFO[_productName][__fromWarehouseID].units);
            for(uint i=0; i<_productIDtoTransfer.length; i++)
            {
                if(product[_productIDtoTransfer[i]].isConsume == false)
                {
                    product[_productIDtoTransfer[i]].isConsume == true;
                    product[_productIDtoTransfer[i]].retailer == _newOwner;
                }
            }
            // emit RawMatarialOwnershipTransfered(msg.sender,_newOwner,rawMatrialIDs);
        }

    }
