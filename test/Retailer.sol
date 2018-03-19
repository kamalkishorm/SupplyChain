pragma solidity ^0.4.18;
import './Authorizer.sol';
import './Owned.sol';
import './Manager.sol';

 contract Retailer is Owned {
    Manager mgr;
   struct RetailerDetails 
    {
        bytes32 retailerName;
        bytes32 retailerCity;
       
    }
    
    struct Product
    {
        bytes32 productID;
        bytes32 Name;
        uint256 price;
    }
    

    mapping(address => RetailerDetails) Retailers;
    mapping(bytes32 => Product) ProductDetails;
    event RetailerAlreadyRegistered(bytes32 retailerName,bytes32 city);
    
 
    function addRetailer(
        address _retailer, 
        bytes32 _retailerName, 
        bytes32 _retailerCity
    )
        onlyOwner 
        public
        {
        RetailerDetails memory newRetailer;
        newRetailer.retailerName = _retailerName;
        
        newRetailer.retailerCity = _retailerCity;
        Retailers[_retailer] = newRetailer;
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
        return (Retailers[_retailer].retailerName,Retailers[_retailer].retailerCity);
     }
     
     function Retailer(
        address managerContractAddress
    ) 
        public 
        {
        mgr = Manager(managerContractAddress);
       
    }



    function requestProduct(
        //bytes32 _inventorID,
        bytes32 _productName,
        uint256 _units
        //uint256 _pricePerUnit
    ) 
        public 
       // isInventor(_inventorID)
        {
        mgr.broadcastProductRequirement(_productName,_units);
    }
    
    
    function searchProductByName(
        bytes32 _Name
    )
        public
        constant
        returns(
           bytes32 _productID,
            bytes32 _productName,
            uint256 price
        
        ) {
            return (
                ProductDetails[_productID].productID,
               ProductDetails[_productID].Name,
                ProductDetails[_productID].price
            );
    }
    
    
    // function recieveProduct(
    //      bytes32 _productName,
    //      bytes32 _units,
    //      uint256 _pricePerUnit
        
    //  )
    //  public
    //  {
    //      mgr.sendSelesOrder(_productName,_units,_pricePerUnit);
    //  }
    // //     public
    // //     {

    // //     Product memory newProduct;
    // //   //  newProduct.productID = _rawMatrialID;
    // //     // newProduct.parent = _parent;
    // //     newProduct.name = _productName;
    // //     newProduct.units = _units;
    // //     newProduct.pricePerUnit = __pricePerUnit
        

    // //     ProductsInInventory[_inventorID].push(newProduct);
    // //     ProductInfo[_rawMatrialID] = newProduct;
    // //     InventoryStore[_inventorID].groupIdCounts[_groupID] += 1;

    // //      if (groupIDWithInventoryProductsArray[_groupID][_inventorID].rawMatrialsIDs.length > 0) {
    // //         groupIDWithInventoryProductsArray[_groupID][_inventorID].units += 1;
    // //         tempBytesArray = groupIDWithInventoryProductsArray[_groupID][_inventorID].rawMatrialsIDs;
    // //         tempBytesArray.push(_rawMatrialID);
    // //         groupIDWithInventoryProductsArray[_groupID][_inventorID].rawMatrialsIDs = tempBytesArray;
    // //         // delete(tempBytesArray);
    // //         // groupIDWithInventoryProductsArray[_groupID][_inventorID] = newProductsArray;
    // //     } else {
    // //         ProductsArray memory newProductsArray;
    // //         newProductsArray.units += 1;
    // //         tempBytesArray.push(_rawMatrialID);
    // //         newProductsArray.rawMatrialsIDs = tempBytesArray;
    // //         groupIDWithInventoryProductsArray[_groupID][_inventorID] = newProductsArray;
    // //     }
    // //     delete(tempBytesArray);
    // //     // emit RawMatrialRegistered(_rawMatrialID,_groupID,_inventorID);
    // // }
    
    // //  function searchProductByName(
    // //     bytes32 name
    // // )
    // //     public
    // //     constant
    // //     returns(
    // //         bytes32 productID,
    // //         bytes32 name,
    // //         uint256 price,
    // //         uint256 units{
    // //         return (
    // //             ProductInfo[_productID].productID,
    // //             ProductInfo[_productID].parent,
    // //             ProductInfo[_productID].name,
    // //             ProductInfo[_productID].groupID,
    // //             ProductInfo[_productID].currentOwner,
    // //             ProductInfo[_productID].supplier,
    // //             ProductInfo[_productID].childs,
    // //             ProductInfo[_productID].additionalDiscription,
    // //             ProductInfo[_productID].price,
    // //             ProductInfo[_productID].inventoryStoreID
    // //         );
    // // }
    // //     ) 
    
    
}