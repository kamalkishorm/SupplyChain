pragma solidity ^0.4.18;

contract Owned {
    address public owner;
    
    modifier onlyOwner {
        if (msg.sender != owner) {
            assert(true);
        }
        _;
    }

    function Owned() public {
        owner = msg.sender;
    }
    function transferOwnership(
        address newOwner
    ) 
        public
        onlyOwner
        {
        owner = newOwner;
    }
    
}


contract Authorization is Owned {

    struct AuthorizerDetails {
        bytes32 name;
        bytes32 designation;
        authorizationType authorizerType;
        bytes32 additionalInfo;
    }

    mapping(address => AuthorizerDetails) Authorizers;

    enum authorizationType{registrar,validator}

    modifier isRegistrar {
        if (uint(Authorizers[msg.sender].authorizerType) != 0) {
            assert(true);
        }
        _;
    }

    modifier isValidator {
        if (uint(Authorizers[msg.sender].authorizerType) != 1) {
            assert(true);
        }
        _;
    }

    function addAuthorizer(
        address _authorizer, 
        bytes32 _name, 
        bytes32 _designation, 
        authorizationType _authorizserType, 
        bytes32 _additionalInfo
    )
        onlyOwner 
        public
        {
        AuthorizerDetails memory newAuthorizser;
        newAuthorizser.name = _name;
        newAuthorizser.designation = _designation;
        newAuthorizser.authorizerType = authorizationType(_authorizserType);
        newAuthorizser.additionalInfo = _additionalInfo;
        Authorizers[_authorizer] = newAuthorizser;
    }

    function viewAuthorizer(
        address _authorizer
    ) 
        public 
        constant 
        returns(
            bytes32 name, 
            bytes32 designamtion, 
            authorizationType authorizerType, 
            bytes32 additionalInfo
            ) {
        require(msg.sender == owner || msg.sender == _authorizer);
        return (Authorizers[_authorizer].name,Authorizers[_authorizer].designation,Authorizers[_authorizer].authorizerType,Authorizers[_authorizer].additionalInfo);
    }

}

contract RowMatrial is Authorization {
    
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
        address owner;
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
            if (ProductDetail[productIDs[i]].owner == msg.sender) {
                ProductDetail[productIDs[i]].owner = _newOwner;
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
            address owner,
            address supplier,
            bytes32[] childs,
            bytes32 additionalDiscription
        ) {
        return (
            ProductDetail[_productID].parent,
            ProductDetail[_productID].name,
            ProductDetail[_productID].groupID,
            ProductDetail[_productID].owner,
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