# Supply Chain


## Links
1. http://www.gazelle.in/BCSCM.pdf


## Authorizer.sol
### Functions
1. `addAuthorizer`(_authorizer,_name,_designation,_authorizerType,_additionalInfo) : new authorizer can be added.
2. `viewAuthorizer`(_authorizer) : existing authorizers can be viewed it returns bytes32 name,designation,authorizerType,additionalInfo. 


## Raw_material .sol
### Functions
1. `register_supplier`(supplier_address,name,city) : new supplier can be registered.
2. `registerRowMatrial`(name,_groupID,_supplier,_additionalDiscription,_productID) : new raw materials can be registered.
3. `viewProductByID`(_productID) : status of the products can be checked wheather they are available or not. it returns 		parent,name,groupID,currentOwner,supplier,childs,additionalDiscription
4. `transferProductOwnerShip`(_newOwner,productIDs) : the product can be transferred on a request.
5. `viewSupplier`(supplier): it will return the suppliers details from where the product arrived.
6. `broadcastRequirement`(inventoryID,groupID,units): it will broadcast the raw material requirements to all vendors.
7. `sendProposal`(groupID,unit,price) : A quotation will be sent to the inventory by suppliers.
8. `generateSalesOrder`(groupID,units,price,discription) : final bill with product will be sent to the inventory.

 
          
     

## Inventory.sol
### Functions
1. `registerInventory`(_inventoryHead,_inventoryName,_inventoryCity) : used to register inventory.
2. `requestRowMatrials`(_inventorID,_groupID) : used to request new raw materials.
3. `viewInventoryStore`() : inventory store having a particular product can be viewed.
4. `searchProductByID`(productID): used to search available products
5. `requestRawMaterial`(groupID,quantity) : new requirements for raw materials can be sent.
6. `receiveProposal`(groupID) : proposal accepted or denied by inventory.
7. `generatePurchaseOrder`(groupID,unit,price) : after recieving proposal Purchase order sent to the supplier

##Manager.sol