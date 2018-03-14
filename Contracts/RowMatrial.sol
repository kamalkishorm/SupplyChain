pragma solidity ^0.4.18;
import './Authorizer.sol';
import './Inventory.sol';

contract RowMatrial is Owned {
    
    Authorizer Auth;
    Inventory Invt;

    struct Supplier {
        address supplier;
        bytes32 name;
        bytes32 city;
    }

    struct RowMatrialInfo {
        bytes32 rowMatrialID;
        bytes32 parent;
        bytes32 name;
        bytes32 groupID;
        address currentOwner;
        address supplier;
        bytes32[] childs;
        bytes32 additionalDiscription;
        uint256 price;
        bytes32 inventoryStoreID;        
    }

    struct RowMatrialInfoOwnersDetails {
        bytes32 name;
        bytes32 companyName;
    }

    mapping(address => Supplier) SupplierDetails;
    mapping(bytes32 => RowMatrialInfo) RowMatrialMapping;
    mapping(address => RowMatrialInfoOwnersDetails) owners;

    modifier isSupplier(address _supplier) {
        if (SupplierDetails[_supplier].supplier == _supplier) {
            assert(true);
        }
        _;
    }

    function RowMatrial(
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
        require(SupplierDetails[_supplier].name != "");
        Supplier memory newSupplier;
        newSupplier.name = _name;
        newSupplier.city = _city;
        newSupplier.supplier = _supplier;
        SupplierDetails[_supplier] = newSupplier;
        return true;
    }

    function registerRowMatrial(
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
        bytes32 _rowMatrialID = keccak256(_name,_groupID,_supplier,_additionalDiscription,_price,block.timestamp);

        RowMatrialInfo memory newRowMatrialInfo;
        newRowMatrialInfo.name = _name;
        newRowMatrialInfo.groupID = _groupID;
        newRowMatrialInfo.supplier = _supplier;
        newRowMatrialInfo.additionalDiscription = _additionalDiscription;
        newRowMatrialInfo.price = _price;
        newRowMatrialInfo.rowMatrialID = _rowMatrialID;
        RowMatrialMapping[_rowMatrialID] = newRowMatrialInfo;
    }
    function transferRowMatrialInfoOwnerShip(
        address _newOwner,
        bytes32[] rowMatrialIDs
    )
        isSupplier(msg.sender)
        public
        {
        for (uint i = 0; i < rowMatrialIDs.length;i++) {
            if (RowMatrialMapping[rowMatrialIDs[i]].currentOwner == msg.sender) {
                RowMatrialMapping[rowMatrialIDs[i]].currentOwner = _newOwner;
            }
        }
    }

    function viewRowMatrialInfoByID( 
        bytes32 _rowMatrialID
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
            // RowMatrialMapping[_rowMatrialID].parent,
            RowMatrialMapping[_rowMatrialID].name,
            RowMatrialMapping[_rowMatrialID].groupID,
            RowMatrialMapping[_rowMatrialID].currentOwner,
            RowMatrialMapping[_rowMatrialID].supplier,
            RowMatrialMapping[_rowMatrialID].childs,
            RowMatrialMapping[_rowMatrialID].additionalDiscription,
            RowMatrialMapping[_rowMatrialID].price
        );
    }

    // function viewRowMatrialInfoByGroupID(
    //     bytes32 _groupID
    // )
    //     public 
    //     constant
    //     returns(
    //         bytes32[] RowMatrialInfos
    //     ) {
    //     for (uint i = 0;i<)
    // }

    function broadcastRowMatrialRequirement(
        bytes32 _inventoryID,
        bytes32 _groupID
    )
        external
        {
        
    }

}