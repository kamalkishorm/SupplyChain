# Addresses
1. 0xca35b7d915458ef540ade6068dfe2f44e8fa733c   :   Owner       && Manager & Warehouse
2. 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c   :   Authorizer      
3. 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db   :   Supplier        &&  Retailer
4. 0x583031d1113ad414f02576bd6afabfb302140225   :   Inventory
5. 0xdd870fa1b7c4700f2bd7f44238821c26f7392148   :   OperationTeam
6. Manager & Warehouse
7. Retailer


# TEST_CASE_05 Testnet Ropsten
## Addresses
1. 0xe74eB4f516fFE4BA1bBa481FcED5572754Be0FFE   :   Owner       
2. 0x0fB7237ce5d28AEF72B6848589b0Fe1dE6510Fc4   :   Authorizer      
3. 0x910dfCB8E2814b1AACaFeF7BE8A6F13098b1a00C   :   Supplier      
4. 0xf0b8Fac093911E9C54db6f65fc0cbd396ABed91B   :   Inventory
5. 0x0Be1991B9a1E5498391aE90fD3D600C7fa21c268   :   OperationTeam
6. 0x144Fa7E18DA41fC4720fd338DB9d20C6dFD77D3A   :   Manager
7. 0x2424Ed3c620f9818b2bF261C466c9Ffe3b2a6e2b   :   Warehouse
7. 0x5F2b99fD2F52320E144B40fD1f4f42562113cb23   :   Retailer

## Contract Address
1. 0x1f1e31506d3487d9c0a6957af48e41962ad9103a   :   Authorizer  :   0x83bc79fae7e01c591b9aa53a860f6e2eeed52eeb241edb1a75345fdea15b1946
2. 0x1046c2757591552437f471c5c5dd11f60f25f534   :   Manager <A>     :   0xe522b1acb11d608d21c9e992cef6bc319f62ced4781da8d0bb9f54f18c80e47d
3. 0x8f3371785cdac1ce9e3c1ab6637258b160220d2f   :   OperationTeam <A>[I]: 0xb139abf3d51d6647ca3454d3d3c63b60162c3559ea1713af29f5e02043e83c5b
4. 0xc4b43f1ac69ee07ff4ca060c07f3830fce9aa4f7   :   RawMaterial <A>[I] :   0xefccb9354ddc129e38508d62e4a279298664d5c1fe7d44c0a765771554cdd422
5. 0x3d8428cdfc56c42cc5f47479ba4a91d03d8a1113   :   Inventory   <A,O>[R,W]   :   0x8a51d6c5bef78c66b53759a81be0ca634a9fdd63d17dff878500490245cf7e53
6. 0xb00d7630ea2362b7fe1dc9b11e8b608a10ccb37d   :   Warehouse <A,O,M>   :   0x427191cb11033f270a56ae324c8dcb18f2cfff7db6a4f2ed14bd2de639317970
7. 0x5ac878e6c065b61b47b7719fa4b7dc7d52897022   :   Retailer <A,M>  :   0x87293a79115c5a16275450db7ff6201598f08fd0e1be285d1f445cafbb228d7f


## setContracts Communication Link
1. OpT : I : 0x77d1d45786ac7b34f1682d411696a9883baa67df0d8d446491d1f5542e26a252
2. RMat :   I   :   0x885371629f23dd4a080962e3a120e4ed46e8ca64055aa102290e6ffc991760b2
3. I    :   R   :   0xd4df87f2303e28c8931f260b4b2781cbb166c9ef60514868204d58a880130416
4. I    :   W   :   0x84602d9ee983b0efb2d1b3f890757919f7682ea4f83adf88f457a4956ebdbb68
## Contracts
### Authorizer
1. addAuthorizer ("0x0fB7237ce5d28AEF72B6848589b0Fe1dE6510Fc4","Auth0","Registrar",1,"can add user")    :   0x37b5b1edf7992a5a4dd131c31e787a7b0552b71700642110fd4385195d4b4ee0

### RawMaterial
1. registerSupplier ("sup01","jpr","0x910dfCB8E2814b1AACaFeF7BE8A6F13098b1a00C")    :   0xd64e59e5b9812dfbc900f7d68de259717c4a355990243b31baf0e574a3e8f316
2.  A. registerRawMaterial ("LapScreen","LGS","0x910dfCB8E2814b1AACaFeF7BE8A6F13098b1a00C","15.6 inch screen",10)   :   0x87a63f1c8f8890130dd45b2779abf4180ffc24027e93a0cc2ca77a7b6d77562c
        `"0xd12a9d0f32bdcfe7be15455d3bc8d41db4c6fd6c9709a9f759bf08425d73f9ed, 0xdad3c36bc9ceae659a4503c3110756dcd8f329a6368953879f31f3920c7da8ee, 0x4519087d96cc379d967207507e74bcdf944b46f76563039c35fdbd485b8fc0a7, 0xb6686ffaeb75b8a6f92f9a33e3a0b9daa52916124d5bc05dd14d24f872e2b7f9, 0xddbe5fee03ff32b15a79612569814b39bb18aa5a0e0cedd8de5f886e274ffe2c, 0xc387362e8f4c4aad8413b6ea4629a437dcb94f6e12592caf87f7dd874c1e3b45, 0xe7afc49fab42e66df76f7aa5aa5661e135ae1f7274d90e1ab374baae9689e56c, 0xd1b39ddd6580fe7b52f6611809b2fcdb39050669fcc2593a86bdb4725074669b, 0x94599d84e70678105fcfb03d32eb6e8c6d41e702f3f91df6483fd9641d0dc2d4, 0xa953fe857e0d5f75599f3a92bf10bb362b66870d9d70a1e4aaec819861a503e7"`
    B. registerRawMaterial ("LapRAM","LGRAM","0x910dfCB8E2814b1AACaFeF7BE8A6F13098b1a00C","4 GB RAM",20)    :   0x3e2b8fe18d0bd10e9836a3135c5f1cecbba7124e19a62a3da7fa59b26f889e1e
        `"0x999f176510e3c4d89cebf1e6c9923038ce70a73dae15cfed0c66726009d9fbb9, 0x47973fb5753adc0e028c278175fa7a58b5552ee9ae8bda664e12ef504afcbe6b, 0x0faf2d64ddda5ab8828945e6d4ecbd6d4263fe002b0806c62dfc5143e630b78e, 0x00fc862b34c29b0dd578f69addd67e31522974edd4ae51ffbee57970610d704e, 0xb0f3243f99a3fa0baf4410c54869cfdcab7618154b6458b546cce34459dd3519, 0xaaee4af49a52eeb072beb2d87e12eb6a3e37fff61a399aa0241560f31e769b14, 0x2d304d20573542a359927fb82cbbb140ccf6ba6934a0e087ad5a3ee520f2225c, 0x3c17ec94815d29e1de758cbdbc3f55c81b7726c5bf44925e589d0d3c0dd3b20d, 0xfa08403672566788c9bfc57bf8e367db321cf1fea10efcef12ed289b9d6d7f6b, 0xd8b33d8340ed48048714920519acf868ea2193a45f72c5291e37067a38c56c3f, 0xfcc66d5679528eb1102d75ddc395bc4cba57b66fab3cbe4347967e358d964214, 0x0de8e4a08a6082736a5660f4784c0593a442cdffbfa9fd765a5086721ababac8, 0x05ed3ea1578c90ac53b2b7af63316481d83841710247593cae4c3636ec454053, 0xa34e386f8c49d891e2b3b50edac9d093199e974965cd5f818903e93d84fdcea5, 0xd9843c73454f7a2c693e8193255946fd6ea6100c52cb0abb9296246d1fd20e0e, 0x807556cfb3724fe8feaae3664b07c59294a4f78e5d3e1d4909969dfb898890fc, 0x0d16c81b094ab2ea28d5b313450c8748a7c9276da9ac3c2086117f36a68129c8, 0xf69ae4c8a4db7a11c3b5b86ba941e93b68ea034176587ccd6af9bf58d430d377, 0x540649fee434c75cb6d72fdc72fff4667b80f7cf57c914a04e0e83ba68253c79, 0x7a806869fdd330c10b6a396c9942900674f1d38235aec0ea1ecb30f126321511"`
        
    C. registerRawMaterial ("HDD500","HDD","0x910dfCB8E2814b1AACaFeF7BE8A6F13098b1a00C","2 TB",10)  :   0x661a98182804d114824090f8f97b0a3be311caead3e59726d72302faabcb4ec1
        `"0x82a302a8b90a00f3b0fbaf590e2b4f3fcb00cd1ec1b2a57f7fb403f2bb932670, 0x8f843d9c9a69c5aaeae8309fd3bf161a60e49cabbad2ac778d44f965cef2e788, 0x56b9e48ede8907e177994a0668e96799f6070957a9769fe95cd206d3ec6b9f5b, 0xec749929812d62ac949139005d83b58cd7780724fba97c4ce17540be6f06c58f, 0x75fa31b2f763e1a8cec2cecced1b0cb1822bb22ed0388d514b8e74a7a8539e69, 0x45ac2b13fde41b422a9020e4ac89b769d980af2b01918b1685a62c98591ae336, 0xcc00314c0294d18db81208d704306fe47077d2093d0f3a420a3632a384aeb2a9, 0x98779f0fbbb1942935dd6aeac7682d8948bc8d30dbea24492fa51d820171883a, 0x5b6591f90d3a4ebd57b5d955559fec98021825f2c5d5f8c551c9da3756e2bb59, 0x42344e5f2b057e8c36d178a81567c3f2bee06a503e561d08e4cdd7e819088409"`
        <!-- `0x8c3b2d5d495357b0eb96767d78598ebca6377197baf2b7130c049830fbbbb649` -->
3. sendSellOrder ("LGRAM","0xe0b6ba825ea48d3db324588769d557fe13d8ea07a85ab32b89cb6ee250519db6")

### Inventory
1. registorInventory ("0xf0b8Fac093911E9C54db6f65fc0cbd396ABed91B","InvJpr01","jpr")    :   0xe298c000d28f2eabc4d5f8d674ac21894d81c0b995974360b541db37f3a20207
        `0xe0b6ba825ea48d3db324588769d557fe13d8ea07a85ab32b89cb6ee250519db6`
2. requestRawMatarials ("0xe0b6ba825ea48d3db324588769d557fe13d8ea07a85ab32b89cb6ee250519db6","LGRAM",16,8)  :   0x2cadd9e17111a908a7ffb9304d338d1ba5bf2544e7c368444b64a5893c7ec40b
    requestRawMatarials ("0xe0b6ba825ea48d3db324588769d557fe13d8ea07a85ab32b89cb6ee250519db6","LGS",8,15)   :   0xc9d2a16904274bf140ad8aff8bc4e3285641b0816035623467ff947c98c3ea7a
    requestRawMatarials ("0xe0b6ba825ea48d3db324588769d557fe13d8ea07a85ab32b89cb6ee250519db6","HDD",8,25)   :   0xbcb769bd352d54ae76a4af290e58c92a3dc4d73ae233fa9c645cd0d1ed6412a9
3. sendProductToWarehouse ("0x61ae19f6665fc994635bf7fd1342b35c953c32d321912b35e70446c59b76f308","Laptop15.6",1,true)    :   

### OperationTeam
1. registerOperationTeam ("0x0Be1991B9a1E5498391aE90fD3D600C7fa21c268",[],"LaptopTeam01","Laptop15.6",["LGRAM","LGS","HDD"],[2,1,1],"15.6 inch laptop with 8GB RAM")    :   0x7c5bf667dd48b71f0bfef593cf72b87ac1547a794f0c26e2be31e957430d3099
2. makeFinalProducts ("Laptop15.6","0xe0b6ba825ea48d3db324588769d557fe13d8ea07a85ab32b89cb6ee250519db6",6);
        
3. sendProdutsToWarehouse ("0x72f1acc6e94948b0bf008a805f66f6abae03368250f6802f2c71f1b5df26d81c","Laptop15.6",1,true);

### Manager
1. addManager ("0x144Fa7E18DA41fC4720fd338DB9d20C6dFD77D3A","mngr01","lead","manage WH & Retailer Req") :   0xeb589440c59130c96b463fddc86bdf79b5e20ae05b0bc03c85d9b27fe2c6c30a

### Warehouse
1. registerWarehouse("0x2424Ed3c620f9818b2bF261C466c9Ffe3b2a6e2b","Laptop Stock WH","jpr")  :   0x729a72cbdf82d4837d3c16d0d5b5c089c2ef48d25769ebe13b4dbc4bdba36d69
        `0x72f1acc6e94948b0bf008a805f66f6abae03368250f6802f2c71f1b5df26d81c`
2. requestProductforRetailer ("0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db","0x0c2e77121daf0270d26bf0a7e9ab0faa8bf739ef","Laptop15.6",1,"0x72f1acc6e94948b0bf008a805f66f6abae03368250f6802f2c71f1b5df26d81c")

### Retailer
1. addRetailer ("0x5F2b99fD2F52320E144B40fD1f4f42562113cb23","Retailer01","jpr")    :   0x12a1a71ff890b2698a6d4239eeff0a438d535701dcfe526529b6d9e74c041cb7
2. requestProduct ("Laptop15.6",1)


/***************************************************************************************************************************************/

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
1. addRetailer ("0x5F2b99fD2F52320E144B40fD1f4f42562113cb23","Retailer01","jpr")
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
