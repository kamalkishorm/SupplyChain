pragma solidity ^0.4.18;
import './Manager.sol';
import './Authorizer.sol';
import './OperationTeam.sol';
import './Retailer.sol';

contract Warehouse is Owned 
{
    
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