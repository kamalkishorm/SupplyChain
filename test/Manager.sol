pragma solidity ^0.4.18;
import './Owned.sol';
// import './Warehouse.sol';
import './Retailer.sol';

contract Manager is Owned 
{
    // Warehouse war;------------------
    struct ManagerDetails 
    {
        address managerID;
        bytes32 name;
        bytes32 designation;
        bytes32 additionalInfo;
    }
    struct RetailerRequirement
    {
        address productID;
        bytes32 productName;
        uint256 units;
    }
    // --------------------------------
    // function Manager(address warehouseAddress)
    // {
    //   war = Warehouse(warehouseAddress) ;
    // }
    // ------------------------------------
    
     mapping(address => ManagerDetails) Managers;
     mapping(address => RetailerRequirement) retailerRequirement;
     
     function addManager(
        address _manager, 
        bytes32 _name, 
        bytes32 _designation, 
        bytes32 _additionalInfo
    )
        onlyOwner 
        public
        {
            ManagerDetails memory newManager;
            newManager.name = _name;
            newManager.designation = _designation;
            newManager.additionalInfo = _additionalInfo;
            Managers[_manager] = newManager;
        }
    function viewManager(address _manager) public constant returns(bytes32 name, bytes32 designamtion, bytes32 additionalInfo)
    {
        require(msg.sender == owner || msg.sender == _manager);
        return (Managers[_manager].name,Managers[_manager].designation,Managers[_manager].additionalInfo);
    }
    // --------------------
    // function requestRawMatrials(bytes32 _managerID,bytes32 _groupID,uint256 _units) public 
    //     // isInventor(_inventorID)
    // {
    //     war.broadcastProductRequirement(_managerID,_groupID,_units);
    // }
// 	------------------------------------
   
    
    
    function broadcastProductRequirement(bytes32 _productName, uint256 _units)external
    {
        
        RetailerRequirement memory newRetailerRequirement;
        newRetailerRequirement.productName = _productName;
        newRetailerRequirement.units += _units;
       
    }
}