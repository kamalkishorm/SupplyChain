# Supply Chain


## Links
1. http://www.gazelle.in/BCSCM.pdf


## Authorizer.sol
### Functions
1. `addAuthorizer`(_authorizer,_name,_designation,_authorizerType,_additionalInfo) : new authorizer can be added.
2. `viewAuthorizer`(_authorizer) : existing authorizers can be viewed it returns bytes32 name,designation,authorizerType,additionalInfo. 


## Raw_material .sol

### mapping
1. mapping(groupID=>broadcast) requestedMatrials
### Struct
1. broadcast: requirements{inventorID,units}
### Functions
1. `registerSupplier(_name,_city,_supplier)` : new supplier can be registered returns bool.
2. `registerRowMatrial(name,_groupID,_supplier,_additionalDiscription,_price) `: new raw materials can be registered. it returns a byte32 ID.
3. `viewRowMatrialInfoByID(_rowMatrialID)` : status of the products can be checked wheather they are available or not. it returns
     [_rowMatrialID].name,[_rowMatrialID].groupID,[_rowMatrialID].currentOwner,[_rowMatrialID].supplier,         [_rowMatrialID].additionalDiscription 
4. `transferRowMatrialInfoOwnerShip(_newOwner,rowMatrialIDs)` : the product can be transferred on a request.
5. `viewSupplier(address _supplier)`: it will return the suppliers details from where the product arrived.returns supplier,name,city.
6. `broadcastRowMatrialRequirement(_inventoryID,_groupID,_units,_pricePerUnit)`: it will broadcast the raw material requirements to all vendors.

7. `viewGroupIDRequirement<_groupID>`(reuests can be viewed for a particular product id) 
8. `sendSellOrder(_groupID,_inventorID)`: final bill with product will be sent to the inventory. 

 
          
     

## Inventory.sol
### Functions

1. recieveRawMatarials(_name,_groupID, _currentOwner,_supplier,_additionalDiscription,_price,_inventorID) : for receiving the rawmaterials
2. requestRowMatrials(_inventorID,_groupID,_units) :new requirements for raw materials can be sent.
3. registerInventory(_inventoryHead,_inventoryName,_inventoryCity) returns _inventoryID : new inventory can be registered
4. setRawMaterialContractAddress(rowMatrialContractAddress) returns bool
5. Inventory(authorizerContractAddress)
6. SearchProductByGroupID()
7. viewInventory()
8. viewInventoryProducts()
9. 

### Events:
1. event RawMatarialsReceived(_rawMatrialID,_parent,_name,_groupID,_currentOwner,_supplier, _additionalDiscription,_price,_inventorID)
2. event RawMaterialAlreadyRequested(_inventorID,_groupID,_units,_pricePerUnit)
3. event InventoryRegistered(_inventoryHead, _inventoryName, _inventoryCity)
 



## Owned.sol
### Functions
1. transferOwnership(newOwner) : ownership can be transferred to a new owner.


## manager.sol
### Functions
1. RegisterManager(address _manager, byte32 name, byte32 city) : new manager can be registered.
2. AcceptRequestFromRetailer(address _retailerID,productGroupID,Quantity) : New Request from retailer can be registered. return will be bool(request granted or not)
3. SearchInventoryByGroupID(Product Group ID) : Inventory/warehouse can be searched by products unique group ID. return will be bool(available or not)
4. ViewInventoryList(Product Group ID) : all the inventory having particular product will be displayed. return will be list of inventory having particular product.
5. SendQuotationToRetailer(Product Group ID,Unit,Price,Description) : A quotation can be send to the retailer for requested order.
6. AcceptPOFromRetailer(Product Group ID,Unit,Price) : PO can be accepted from retailer.
7. AcceptProductFromInventory(Product ID,Unit): products can be accepted from inventory.
8. SendProductToRetailer(Product ID,Unit) : product can be send to retailer.
