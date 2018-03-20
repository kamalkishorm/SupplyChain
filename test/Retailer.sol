pragma solidity ^0.4.18;
import './Authorizer.sol';
import './Owned.sol';
import './Manager.sol';

contract Retailer is Owned {
    Manager Mgr;
    Authorizer Auth;

    struct RetailerDetails {
        address retailerAddress;
        bytes32 retailerName;
        bytes32 retailerCity;
       
    }
    
    struct Product {
        bytes32 productID;
        bytes32 category;
        uint256 price;
        address retailerAddress;
        bool isConsume;
    }
    
    mapping(address => RetailerDetails) RetailerList;
    mapping(bytes32 => Product) ProductDetails;
    //mapping(address => Product) RetailerStoreProductDetails;
    mapping(bytes32 => mapping(address => bytes32[])) ProductArrayOnRetailer;

    event RetailerAlreadyRegistered(bytes32 retailerName,bytes32 city);
    
    modifier isRetailer() {
        if(msg.sender == RetailerList[msg.sender].retailerAddress) {
            assert(true);
        }
        _;
    }

    function Retailer(
        address _authorizerContractAddress,
        address _managerContractAddress
    ) 
        public 
        {
        Auth = Authorizer(_authorizerContractAddress);
        Mgr = Manager(_managerContractAddress);
    }

    function addRetailer(
        address _retailer, 
        bytes32 _retailerName, 
        bytes32 _retailerCity
    ) 
        public
        {
        require(Auth.isRegistrar(msg.sender));
        
        RetailerDetails memory newRetailer;
        newRetailer.retailerName = _retailerName;
        newRetailer.retailerCity = _retailerCity;
        RetailerList[_retailer] = newRetailer;
    }

    function viewRetailer(
        address _retailer
    ) 
        public 
        constant 
        returns(
            bytes32 _retailerName, 
            bytes32 _retailerCity
        ) {
        require(msg.sender == owner || msg.sender == _retailer);
        return (RetailerList[_retailer].retailerName,RetailerList[_retailer].retailerCity);
    }
     
    function requestProduct(
        bytes32 _productCategory,
        uint256 _units
    ) 
        isRetailer
        public 
        {
        Mgr.broadcastProductRequirement(msg.sender,_productCategory,_units);
    }

    function recieveProduct(
        bytes32 _productID,
        address _retailerAddress,
        bytes32 _category,
        uint256 _price
    )
        public
        {
        Product memory newProduct;
        newProduct.productID = _productID;
        newProduct.category = _category;
        newProduct.price = _price;
        newProduct.retailerAddress = _retailerAddress;
        ProductDetails[_productID] = newProduct;
    }
    
    function searchProductByCategory(
        bytes32 _productCategory
    )
        public
        constant
        returns(
            bytes32[] ProductID,
            uint256 ProductCategory
        ) {
        return (
            ProductArrayOnRetailer[_productCategory][msg.sender],
            ProductArrayOnRetailer[_productCategory][msg.sender].length
        );
    }

    function serachProductByID(
        bytes32 _productID
    )
        public
        constant
        isRetailer
        returns(
            bytes32 ProductID,
            bytes32 ProductCategory,
            uint256 ProductPrice,
            address ProductOwner,
            bool SoldOut
        ) {
        return(
            ProductDetails[_productID].productID,
            ProductDetails[_productID].category,
            ProductDetails[_productID].price,
            ProductDetails[_productID].retailerAddress,
            ProductDetails[_productID].isConsume
            );
    }

}