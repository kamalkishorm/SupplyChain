pragma solidity ^0.4.18;
import './Authorizer.sol';
import './Owned.sol';
import './Manager.sol';

 contract Retailer is Owned {
    Manager mgr;
   struct RetailerDetails {
        bytes32 retailerName;
        bytes32 designation;
       // authorizationType authorizerType;
        bytes32 additionalInfo;
    }

    mapping(address => RetailerDetails) Retailers;
 
    function addRetailer(
        address _retailer, 
        bytes32 _retailerName, 
        bytes32 _retailerDesignation, 
        //authorizationType _authorizserType, 
        bytes32 _additionalInfo
    )
        onlyOwner 
        public
        {
        RetailerDetails memory newRetailer;
        newRetailer.retailerName = _retailerName;
        newRetailer.designation = _retailerDesignation;
        //newRetailer.authorizerType = authorizationType(_authorizserType);
        newRetailer.additionalInfo = _additionalInfo;
        Retailers[_retailer] = newRetailer;
    }

     function viewRetailer(
         address _retailer
     ) 
         public 
         constant 
         returns(
            bytes32 _retailerName, 
            bytes32 _retailerDesignation, 
    //         authorizationType authorizerType, 
             bytes32 additionalInfo
            ) {
        require(msg.sender == owner || msg.sender == _retailer);
        return (Retailers[_retailer].retailerName,Retailers[_retailer].designation,Retailers[_retailer].additionalInfo);
     }
     
     function Retailer(
        address managerContractAddress
    ) 
        public 
        {
        mgr = Manager(managerContractAddress);
       
    }



    function requestProduct(
        //bytes32 _inventorID,
        bytes32 _productName,
        uint256 _units
        //uint256 _pricePerUnit
    ) 
        public 
       // isInventor(_inventorID)
        {
        mgr.broadcastProductRequirement(_productName,_units);
    }
    
    
    
    
}
