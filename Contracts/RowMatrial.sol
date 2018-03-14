pragma solidity ^0.4.18;
import './Authorizer.sol';

contract RowMatrial is Authorizer {
    
    struct Supplier {
        address supplier;
        bytes32 name;
        bytes32 city;
    }

    struct Product {
        bytes32 productID;
        bytes32 parent;
        bytes32 name;
        bytes32 groupID;
        address currentOwner;
        address supplier;
        bytes32[] childs;
        bytes32 additionalDiscription;
    }

    struct ProductOwnersDetails {
        bytes32 name;
        bytes32 companyName;
    }

    mapping(address => Supplier) SupplierDetails;
    mapping(bytes32 => Product) ProductDetail;
    mapping(address => ProductOwnersDetails) owners;

    modifier isSupplier(address _supplier) {
        if (SupplierDetails[_supplier].supplier == _supplier) {
            assert(true);
        }
        _;
    }

    function registerSupplier(
        bytes32 _name,
        bytes32 _city,
        address _supplier
    ) 
        isRegistrar 
        public 
        returns(bool)
        {
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
        bytes32 _additionalDiscription
    )
        isRegistrar
        isSupplier(_supplier)
        public
        returns(bytes32) 
        {
        bytes32 _productID = keccak256(_name,_groupID,_supplier,_additionalDiscription,block.timestamp);

        Product memory newProduct;
        newProduct.name = _name;
        newProduct.groupID = _groupID;
        newProduct.supplier = _supplier;
        newProduct.additionalDiscription = _additionalDiscription;
        newProduct.productID = _productID;
        ProductDetail[_productID] = newProduct;
    }
    function transferProductOwnerShip(
        address _newOwner,
        bytes32[] productIDs
    )
        isSupplier(msg.sender)
        public
        {
        for (uint i = 0; i < productIDs.length;i++) {
            if (ProductDetail[productIDs[i]].currentOwner == msg.sender) {
                ProductDetail[productIDs[i]].currentOwner = _newOwner;
            }
        }
    }

    function viewProductByID( 
        bytes32 _productID
    )
        public
        constant
        returns (
            bytes32 parent,
            bytes32 name,
            bytes32 groupID,
            address currentOwner,
            address supplier,
            bytes32[] childs,
            bytes32 additionalDiscription
        ) {
        return (
            ProductDetail[_productID].parent,
            ProductDetail[_productID].name,
            ProductDetail[_productID].groupID,
            ProductDetail[_productID].currentOwner,
            ProductDetail[_productID].supplier,
            ProductDetail[_productID].childs,
            ProductDetail[_productID].additionalDiscription
        );
    }

    // function viewProductByGroupID(
    //     bytes32 _groupID
    // )
    //     public 
    //     constant
    //     returns(
    //         bytes32[] products
    //     ) {
    //     for (uint i = 0;i<)
    // }

}