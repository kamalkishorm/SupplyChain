# Addresses
1. 0xca35b7d915458ef540ade6068dfe2f44e8fa733c   :   Owner       && Manager & Warehouse
2. 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c   :   Authorizer      
3. 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db   :   Supplier        &&  Retailer
4. 0x583031d1113ad414f02576bd6afabfb302140225   :   Inventory
5. 0xdd870fa1b7c4700f2bd7f44238821c26f7392148   :   OperationTeam
6. Manager & Warehouse
7. Retailer



# TEST_CASE_04

## Contract Address
1. 0x8609a0806279c94bcc5432e36b57281b3d524b9b   :   Authorizer
2. 0x9876e235a87f520c827317a8987c9e1fde804485   :   Manager <A> 
3. 0x0971b5d216af52c411c9016bbc63665b4e6f2542   :   OperationTeam <A>   [I]
4. 0x1526613135cbe54ee257c11dd17254328a774f4a   :   RawMaterial <A>     [I]
5. 0xde6a66562c299052b1cfd24abc1dc639d429e1d6   :   Inventory   <A,O>   [R,W]
6. 0xa113b22d40dc1d5d086003c27a556e597f614e8b   :   Warehouse <A,O,M>
7. 0xd25ed029c093e56bc8911a07c46545000cbf37c6   :   Retailer <A,M>

## Contracts
### Authorizer
1. addAuthorizer ("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c","Auth0","Registrar",1,"can add user")

### RawMaterial
1. registerSupplier ("sup1","jpr","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
2.  A. registerRawMaterial ("LapScreen","LGS","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","15.6 inch screen")
        `0x62c21004f7dd2ed5678125961d6402beaa908ff4daf51827afac4d2650d74298`
        <!-- `0xd5773b3ff0098ce50c4d9f75d20bc8a5b9a2885e098b3a6be7accd5a38ceb53f` -->
    B. registerRawMaterial ("LapRAM","LGRAM","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","4 GB RAM")
        `0x13a519976b68c601831c1781f99b50e2347b5ed1e0d4f946b3c59cc513ed6780`
        `0x8812686a80bd1198d8a60d9e1f1fbc17b7e3f39d5a02728450f0289e5f64fa7c`
        <!-- `0xb52c91c77519be734a8d1505a78a6d530c13d7d8bd9776d469aafc2b0318f083` -->
        <!-- `0x01c1c85abc74c22300f126410773467930edf82061160069eb6c87c5b962f64f` -->
        
    C. registerRawMaterial ("HDD500","HDD","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","2 TB")
        `0x19da38ae6ff00942c7a6fb508aafcfd7d6e59cc51f163e31d76412eddaa595cf`
        <!-- `0x8c3b2d5d495357b0eb96767d78598ebca6377197baf2b7130c049830fbbbb649` -->
3. sendSellOrder ("LGRAM","0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6")

### Inventory
1. registorInventory ("0x583031d1113ad414f02576bd6afabfb302140225","jpr01","jpr")
        `0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6`
2. requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","LGRAM",2,8)
    requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","LGS",1,15)
    requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","HDD",1,25)
3. sendProductToWarehouse ("0x61ae19f6665fc994635bf7fd1342b35c953c32d321912b35e70446c59b76f308","Laptop15.6",1,true)

### OperationTeam
1. registerOperationTeam ("0xdd870fa1b7c4700f2bd7f44238821c26f7392148",[],"LapAssTeam01","Laptop15.6",["LGRAM","LGS","HDD"],[2,1,1],"15.6 inch laptop with 10GM RAM")
2. makeFinalProducts ("Laptop15.6","0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6",1);
        
3. sendProdutsToWarehouse ("0x61ae19f6665fc994635bf7fd1342b35c953c32d321912b35e70446c59b76f308","Laptop15.6",1,true);

### Manager
1. addManager ("0xca35b7d915458ef540ade6068dfe2f44e8fa733c","mngr01","lead","manage WH & Retailer Req")

### Warehouse
1. registerWarehouse("0xca35b7d915458ef540ade6068dfe2f44e8fa733c","Laptop Stock WH","jpr")
        `0x61ae19f6665fc994635bf7fd1342b35c953c32d321912b35e70446c59b76f308`
2. requestProductforRetailer ("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","0x0c2e77121daf0270d26bf0a7e9ab0faa8bf739ef","Laptop15.6",1,"0x61ae19f6665fc994635bf7fd1342b35c953c32d321912b35e70446c59b76f308")

### Retailer
1. addRetailer ("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","Ret01","jpr")
2. requestProduct ("Laptop15.6",1)


/***************************************************************************************************************************************/

# TEST_CASE_03

## Contract Address
1. 0x692a70d2e424a56d2c6c27aa97d1a86395877b3a   :   Authorizer
2. 0xbbf289d846208c16edc8474705c748aff07732db   :   RawMaterial
3. 0x0dcd2f752394c41875e259e00bb44fd505297caf   :   OperationTeam
4. 0x08970fed061e7747cd9a38d680a601510cb659fb   :   Inventory
5. 0xef55bfac4228981e850936aaf042951f7b146e41   :   Manager
6. 0xdc04977a2078c8ffdf086d618d1f961b6c546222   :   Warehouse
7. 

## Contracts
### Authorizer
1. addAuthorizer ("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c","Auth0","Registrar",1,"can add user")

### RawMaterial
1. registerSupplier ("sup1","jpr","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
2.  A. registerRawMaterial ("abc","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0x848a74eeaad06eb9b1ecfe544fda1ef098c1f4132ba21ae1575479c4943aed7c`
    B. registerRawMaterial ("ab","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0x634470256b9f3f3240a6431a2fe03b6f261391ea9cf959dded5bd60270672557`
    C. registerRawMaterial ("a","gp02","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","Elastic")
        `0x131d991312ef29f9b2b3c039c3febfa5f9a854bd88c60a51d66514bff99124e6`
3. sendSellOrder ("gp01","0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6")

### Inventory
1. registorInventory ("0x583031d1113ad414f02576bd6afabfb302140225","jpr01","jpr")
        `0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6`
2. requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","gp01",2,12)
    requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","gp02",1,15)

### OperationTeam
1. registerOperationTeam ("0xdd870fa1b7c4700f2bd7f44238821c26f7392148",[],"team01","TV",["gp01","gp02"],[2,1],"Plastic ball for kids")
2. getRawMaterialsFromInventory ("TV","0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6",1,["gp01","gp02"],[2,1],"Watch and Enjoy");
        `0x83bd14a43c22c8d948f77002da168a3afa47ab0525bc7362ff3251b8e161b8ba`
3. sendProdutsToWarehouse ("0x3901ea56cdd123fdb784c66305e1c0f1716a03820d416b2a6682a2e23d36cf98","TV",1,true);

### Manager
1. addManager ("0xca35b7d915458ef540ade6068dfe2f44e8fa733c","mngr01","lead","manage WH & Retailer Req")

### Warehouse
1. registerWarehouse("0xca35b7d915458ef540ade6068dfe2f44e8fa733c","Tv Stock WH","jpr")
        `0x3901ea56cdd123fdb784c66305e1c0f1716a03820d416b2a6682a2e23d36cf98`

### Retailer
1. addRetailer ("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","Ret01","jpr")
2. requestProduct ("TV",1)


/***************************************************************************************************************************************/
# TEST_CASE_02

## Contract Address
1. 0x692a70d2e424a56d2c6c27aa97d1a86395877b3a   :   Authorizer
2. 0x0dcd2f752394c41875e259e00bb44fd505297caf   :   RawMaterial
3. 0x5e72914535f202659083db3a02c984188fa26e9f   :   Inventory
4. 0x15e08fa9fe3e3aa3607ac57a29f92b5d8cb154a2   :   OperationTeam

## Contracts
### Authorizer
1. addAuthorizer ("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c","Auth0","Registrar",1,"can add user")

### RawMaterial
1. registerSupplier ("sup1","jpr","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
2.  A. registerRawMaterial ("abc","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0xe92f8d2c3f1229619d416c2c18dc5e1f73b76e20c3c3ca715d165667b401563a`
    B. registerRawMaterial ("ab","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0x9969a45462dcf4126a81c41d20677aab22aedc130f35009ea3789b21db605716`
    C. registerRawMaterial ("a","gp02","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","Elastic")
        `0x987136721cf1470a325fad72cc0518d9f322eb80d92058834cea0749dcb0ae4b`
3. sendSellOrder ("gp01","0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6")

### Inventory
1. registorInventory ("0x583031d1113ad414f02576bd6afabfb302140225","jpr01","jpr")
        `0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6`
2. requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","gp01",2,12)
    requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","gp02",1,15)

### OperationTeam
1. registerOperationTeam ("0xdd870fa1b7c4700f2bd7f44238821c26f7392148",[],"team01","ball",["gp01","gp02"],[2,1],"Plastic ball for kids")
2. getRawMaterialsFromInventory ("ball","0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6",1,["gp01","gp02"],[2,1],"Plastic ball for kids");



/***************************************************************************************************************************************/

# TEST_CASE_01

## Contract Address
1. 0x692a70d2e424a56d2c6c27aa97d1a86395877b3a   :   Authorizer
2. 0x0dcd2f752394c41875e259e00bb44fd505297caf   :   RawMaterial
3. 0x5e72914535f202659083db3a02c984188fa26e9f   :   Inventory

## Contracts
### Authorizer
1. addAuthorizer ("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c","Auth0","Registrar",1,"can add user")


### RawMaterial
1. registerSupplier ("sup1","jpr","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
2.  A. registerRawMaterial ("abc","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0x4bfb00f4233163b8067b045b6e52b652f82dccaba4cd75d2d3c93e849e6fb57f`
    B. registerRawMaterial ("ab","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0x9d68814be6cb7f2ec51b148d41310cb7f325eaf97fa3dda92dd339f804e9ee94`
    C. registerRawMaterial ("a","gp02","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","Elastic")
        `0x03694ef8cfce9498adfddf3d25ac67cc7d717237ca8476edc9d12b9aa2d1150a`
3. sendSellOrder ("gp01","0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6")

### Inventory
1. registorInventory ("0x583031d1113ad414f02576bd6afabfb302140225","jpr01","jpr")
        `0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6`
2. requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","gp01",2,12)


## Warehouse
1. "0xdd870fa1b7c4700f2bd7f44238821c26f7392148","War1","JP"     Register warehouse
2. "pro1","101",100,"0xdd870fa1b7c4700f2bd7f44238821c26f7392148"    Register Product
3. "0xca37d915458ef540ade6068dfe2f44e8fa733c","101",5      Request Raw Material 
4. "0xca37d915458ef540ade6068dfe2f44e8fa733c","pro1",["101"],"0x9ccdd9cc0741a14845141281d5a803364cda78b55352220f081e639941926b45" SellProducttoRetailer 
