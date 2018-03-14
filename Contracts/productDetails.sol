pragma solidity ^0.4.18;
import './Authorizer.sol';

contract ProductDetails is Authorization {
    
    struct Supplier {
        address supplier;
        bytes32 name;
        bytes32 city;
    }

    struct Product {
        bytes32 productID;
        bytes32 parent;
        bytes32 name;
        address owner;
        address supplier;
        bytes32[] childs;
        // uint256[] childRatio;
        // bytes32[] childUnit;
        bytes32 additionalDiscription;
        // uint256 intialUnits;
        // uint256 consumedUnits;
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
        address _supplier,
        bytes32 _additionalDiscription
    )
        isRegistrar
        isSupplier(_supplier)
        public
        returns(bytes32) 
        {
        bytes32 _productID = keccak256(_name,_supplier,_additionalDiscription,block.timestamp);

        Product memory newProduct;
        newProduct.name = _name;
        newProduct.supplier = _supplier;
        newProduct.additionalDiscription = _additionalDiscription;
        newProduct.productID = _productID;
        ProductDetail[_productID] = newProduct;
    }
    function transferProductOwnerShip();
    function viewProduct();
    function vrifiedProduct();
}