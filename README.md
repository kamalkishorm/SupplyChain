# Supply Chain


## Links
1. http://www.gazelle.in/BCSCM.pdf


##Authorizer.sol
###Functions
1. `addAuthorizer`(_authorizer,_name,_designation,_authorizerType,_additionalInfo) : new authorizer can be added.
2. `viewAuthorizer`(_authorizer) : existing authorizers can be viewed it returns bytes32 name,designation,authorizerType,additionalInfo. 


##Raw_material .sol
###Functions
1. `register_supplier`(supplier_address,name,city)
2. `register_raw_material`(name,supplier_id,disc)
3. `status`(pid)
4. `modify_product`(pid,updated_owner_name,updated_company_name)
5. `transfer_product`(pid,supplier_address,receiver_address)

 
          
     

##Inventory.sol

##Manager.sol