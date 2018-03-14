pragma solidity ^0.4.18;
import './Owned.sol';

contract Authorizer is Owned {

    struct AuthorizerDetails {
        bytes32 name;
        bytes32 designation;
        authorizationType authorizerType;
        bytes32 additionalInfo;
    }

    mapping(address => AuthorizerDetails) Authorizers;

    enum authorizationType{registrar,validator}

    // modifier isRegistrar {
    //     if (uint(Authorizers[msg.sender].authorizerType) != 0) {
    //         assert(true);
    //     }
    //     _;
    // }

    // modifier isValidator {
    //     if (uint(Authorizers[msg.sender].authorizerType) != 1) {
    //         assert(true);
    //     }
    //     _;
    // }

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

    function isRegistrar(address caller) constant external returns(bool){
        if (uint(Authorizers[msg.sender].authorizerType) == 0) {
            return true;
        } else {
            return false;
        }
    }

    function isValidator(address caller) constant external returns(bool){
        if (uint(Authorizers[msg.sender].authorizerType) == 1) {
            return true;
        } else {
            return false;
        }
    }

}