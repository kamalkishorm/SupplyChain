pragma solidity ^0.4.18;
import './Authorizer.sol';
import './Inventory.sol';

contract RowMaterial is Owned {
    
    Authorizer Auth;
    Inventory Invt;

    struct Supplier {
        address supplier;
        bytes32 name;
        bytes32 city;
    }

    struct RowMaterialInfo {
        bytes32 rowMaterialID;
        bytes32 parent;
        bytes32 name;
        bytes32 groupID;
        address currentOwner;
        address supplier;
        bytes32[] childs;
        bytes32 additionalDiscription;
        // uint256 price;
        // bytes32 inventoryStoreID;        
    }

    struct RowMaterialInfoOwnersDetails {
        bytes32 name;
        bytes32 companyName;
    }

    struct ProductGroupIDRequirement {
        bytes32 inventoryID;
        uint256 units;
        uints256 pricePerUnit;
    }

    struct RawMatarialsArray {
        uint256 units;
        bytes32[] RowMaterialsIDs;
    }

    mapping(address => Supplier) SupplierDetails;
    mapping(bytes32 => RowMaterialInfo) RowMaterialMapping;
    mapping(address => RowMaterialInfoOwnersDetails) owners;
    mapping(bytes32 => ProductGroupIDRequirement[]) groupIdRequirement;
    mapping(bytes32 => mapping(address =>RawMatarialsArray)) groupIDWithSupplierRowMatarialsArray;

    modifier isSupplier(address _supplier) {
        if (SupplierDetails[_supplier].supplier == _supplier) {
            assert(true);
        }
        _;
    }

    function RowMaterial(
        address authorizerContractAddress, 
        address inventoryContractAddress
    ) 
        public 
        {
        Auth = Authorizer(authorizerContractAddress);
        Invt = Inventory(inventoryContractAddress);
    }

    function registerSupplier(
        bytes32 _name,
        bytes32 _city,
        address _supplier
    ) 
        public 
        returns(bool)
        {
        require(Auth.isRegistrar(msg.sender));
        require(SupplierDetails[_supplier].name == "");
        Supplier memory newSupplier;
        newSupplier.name = _name;
        newSupplier.city = _city;
        newSupplier.supplier = _supplier;
        SupplierDetails[_supplier] = newSupplier;
        return true;
    }

    function viewSupplier(
        address _supplier
    )
        public
        constant
        returns(
            address supplier,
            bytes32 name,
            bytes32 city
        ) {
        return(SupplierDetails[_supplier].supplier,SupplierDetails[_supplier].name,SupplierDetails[_supplier].city);
    }

    function registerRowMaterial(
        bytes32 _name,
        bytes32 _groupID,
        address _supplier,
        bytes32 _additionalDiscription,
        uint256 _price
    )
        isSupplier(_supplier)
        public
        returns(bytes32) 
        {
        require(Auth.isRegistrar(msg.sender));
        bytes32 _rowMaterialID = keccak256(_name,_groupID,_supplier,_additionalDiscription,_price,block.timestamp);

        RowMaterialInfo memory newRowMaterialInfo;
        newRowMaterialInfo.name = _name;
        newRowMaterialInfo.groupID = _groupID;
        newRowMaterialInfo.supplier = _supplier;
        newRowMaterialInfo.additionalDiscription = _additionalDiscription;
        newRowMaterialInfo.price = _price;
        newRowMaterialInfo.rowMaterialID = _rowMaterialID;
        RowMaterialMapping[_rowMaterialID] = newRowMaterialInfo;

        if (groupIDWithSupplierRowMatarialsArray[_groupID][_supplier].RowMaterialsIDs.length > 0) {
            groupIDWithSupplierRowMatarialsArray[_groupID][_supplier].units += 1;
            groupIDWithSupplierRowMatarialsArray[_groupID][_supplier].RowMaterialsIDs.push(_rowMaterialID);
            // groupIDWithSupplierRowMatarialsArray[_groupID][_supplier] = newRawMatarialsArray;
        } else {
            RawMatarialsArray memory newRawMatarialsArray;
            newRawMatarialsArray.units += 1;
            newRawMatarialsArray.RowMaterialsIDs.push(_rowMaterialID);
            groupIDWithSupplierRowMatarialsArray[_groupID][_supplier] = newRawMatarialsArray;
        }
    }
    function transferRowMaterialInfoOwnerShip(
        address _newOwner,
        bytes32[] rowMaterialIDs
    )
        isSupplier(msg.sender)
        public
        {
        for (uint i = 0; i < rowMaterialIDs.length;i++) {
            if (RowMaterialMapping[rowMaterialIDs[i]].currentOwner == msg.sender) {
                RowMaterialMapping[rowMaterialIDs[i]].currentOwner = _newOwner;
            }
        }
    }

    function viewRowMaterialInfoByID( 
        bytes32 _rowMaterialID
    )
        public
        constant
        returns (
            // bytes32 parent,
            bytes32 name,
            bytes32 groupID,
            address currentOwner,
            address supplier,
            bytes32[] childs,
            bytes32 additionalDiscription,
            uint256 price
        ) {
        return (
            // RowMaterialMapping[_rowMaterialID].parent,
            RowMaterialMapping[_rowMaterialID].name,
            RowMaterialMapping[_rowMaterialID].groupID,
            RowMaterialMapping[_rowMaterialID].currentOwner,
            RowMaterialMapping[_rowMaterialID].supplier,
            RowMaterialMapping[_rowMaterialID].childs,
            RowMaterialMapping[_rowMaterialID].additionalDiscription,
            RowMaterialMapping[_rowMaterialID].price
        );
    }

    // function viewRowMaterialInfoByGroupID(
    //     bytes32 _groupID
    // )
    //     public 
    //     constant
    //     returns(
    //         bytes32[] RowMaterialInfos
    //     ) {
    //     for (uint i = 0;i<)
    // }

    function broadcastRowMaterialRequirement(
        bytes32 _inventoryID,
        bytes32 _groupID,
        uint256 _units,
        uint256 _pricePerUnit
    )
        external
        {
        ProductGroupIDRequirement memory newProductGroupIDRequirement;
        // if(groupIdRequirement[_groupID].units == 0) {
            newProductGroupIDRequirement.inventoryID = _inventoryID;
            newProductGroupIDRequirement.units += _units;
            newProductGroupIDRequirement.pricePerUnit += _pricePerUnit;
            groupIdRequirement[_groupID].push(newProductGroupIDRequirement);
        // }
    }

    function viewGroupIDRequirement(
        bytes32 _groupID
    )
        public
        constant
        isSupplier(msg.sender)
        returns(
            bytes32 inventoryID,
            uint256 units
        ) {
        require(groupIdRequirement[_groupID].units != 0);
        return (groupIdRequirement[_groupID].inventoryID,groupIdRequirement[_groupID].units);
    }

    function sendSellOrder(
        bytes32 _groupID,
        bytes32 _inventorID
    )
        public
        isSupplier(msg.sender)
        {
        require(groupIdRequirement[_groupID].units <= groupIDWithSupplierRowMatarialsArray[_groupID][msg.sender].units);
        
        for (uint i = 0; i < groupIdRequirement[_groupID].units ; i++) {
        bytes32 memory id = groupIDWithSupplierRowMatarialsArray[_groupID][msg.sender].RowMaterialsIDs[i];
        Invt.recieveRawMatarials(
            RowMaterialMapping[id].rowMaterialID,
            RowMaterialMapping[id].parent,
            RowMaterialMapping[id].name,
            RowMaterialMapping[id].groupID,
            RowMaterialMapping[id].currentOwner,
            RowMaterialMapping[id].supplier,
            RowMaterialMapping[id].childs,
            RowMaterialMapping[id].additionalDiscription
        );
        delete(RowMaterialMapping[id]);
        }
        groupIDWithSupplierRowMatarialsArray[_groupID][msg.sender].units -= groupIdRequirement[_groupID].units;

    }

}