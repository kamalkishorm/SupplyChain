# Addresses
1. 0xca35b7d915458ef540ade6068dfe2f44e8fa733c   :   Owner
2. 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c   :   Authorizer
3. 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db   :   Supplier
4. 0x583031d1113ad414f02576bd6afabfb302140225   :   Inventory
5. 0xdd870fa1b7c4700f2bd7f44238821c26f7392148


# Contract Address
1. 0x692a70d2e424a56d2c6c27aa97d1a86395877b3a   :   Authorizer
2. 0x0dcd2f752394c41875e259e00bb44fd505297caf   :   RawMatrial
3. 0x5e72914535f202659083db3a02c984188fa26e9f   :   Inventory

# Contracts
## Authorizer
1. addAuthorizer ("0x14723a09acff6d2a60dcdf7aa4aff308fddc160c","Auth0","Registrar",1,"can add user")


## RawMatrial
1. registerSupplier ("sup1","jpr","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db")
2.  A. registerRawMatrial ("abc","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0xdeee1dd267c55677d3f4ff913808fbb4aef739a636118214c23cb4a7824214e7`
    B. registerRawMatrial ("ab","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0x4c5a0ae198d910fbf7f7762ad666946a3da8dc300450547aba4b196428336f52`
    C. registerRawMatrial ("a","gp01","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","plastic")
        `0xa0daa6ef3e8b0a5a1dfb5391cbf1de33c7675dc082e9315e2efc77ed647bc89f`
3. sendSellOrder ("gp01","0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6")

## Inventory
1. registorInventory ("0x583031d1113ad414f02576bd6afabfb302140225","jpr01","jpr")
        `0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6`
2. requestRawMatarials ("0x3ef665faecaae2e7a553ac473f6bbe9944810c40db7c4555fc68f7e798b55bd6","gp01",2,12)