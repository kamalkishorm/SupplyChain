# Addresses
1. 0xca35b7d915458ef540ade6068dfe2f44e8fa733c   :   Owner
2. 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c   :   Authorizer
3. 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db   :   Supplier
4. 0x583031d1113ad414f02576bd6afabfb302140225   :   Inventory
5. 0xdd870fa1b7c4700f2bd7f44238821c26f7392148   :   OperationTeam

# TEST_CASE_02

## Contract Address
1. 0x692a70d2e424a56d2c6c27aa97d1a86395877b3a   :   Authorizer
2. 0x0dcd2f752394c41875e259e00bb44fd505297caf   :   RawMatrial
3. 0x5e72914535f202659083db3a02c984188fa26e9f   :   Inventory
4. 0x15e08fa9fe3e3aa3607ac57a29f92b5d8cb154a2   :   OperationTeam

## Contracts
### Authorizer
1. addAuthorizer ("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c","Auth0","Registrar",1,"can add user")

### RawMatrial
1. registerSupplier ("sup1","jpr","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
2.  A. registerRawMatrial ("abc","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0xe92f8d2c3f1229619d416c2c18dc5e1f73b76e20c3c3ca715d165667b401563a`
    B. registerRawMatrial ("ab","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0x9969a45462dcf4126a81c41d20677aab22aedc130f35009ea3789b21db605716`
    C. registerRawMatrial ("a","gp02","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","Elastic")
        `0x987136721cf1470a325fad72cc0518d9f322eb80d92058834cea0749dcb0ae4b`
3. sendSellOrder ("gp01","0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6")

### Inventory
1. registorInventory ("0x583031d1113ad414f02576bd6afabfb302140225","jpr01","jpr")
        `0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6`
2. requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","gp01",2,12)
    requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","gp02",1,15)

### OperationTeam
1. registerOperationTeam ("0xdd870fa1b7c4700f2bd7f44238821c26f7392148",[],"team01","ball",["gp01","gp02"],[2,1],"Plastic ball for kids")
2. getRawMatrialsFromInventory ("ball","0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6",1,["gp01","gp02"],[2,1],"Plastic ball for kids");



/***************************************************************************************************************************************/

# TEST_CASE_01

## Contract Address
1. 0x692a70d2e424a56d2c6c27aa97d1a86395877b3a   :   Authorizer
2. 0x0dcd2f752394c41875e259e00bb44fd505297caf   :   RawMatrial
3. 0x5e72914535f202659083db3a02c984188fa26e9f   :   Inventory

## Contracts
### Authorizer
1. addAuthorizer ("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c","Auth0","Registrar",1,"can add user")


### RawMatrial
1. registerSupplier ("sup1","jpr","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
2.  A. registerRawMatrial ("abc","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0x4bfb00f4233163b8067b045b6e52b652f82dccaba4cd75d2d3c93e849e6fb57f`
    B. registerRawMatrial ("ab","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0x9d68814be6cb7f2ec51b148d41310cb7f325eaf97fa3dda92dd339f804e9ee94`
    C. registerRawMatrial ("a","gp02","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","Elastic")
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
