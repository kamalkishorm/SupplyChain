pragma solidity ^0.4.18;
struct Supplier {
        address supplier;
        bytes32 name;
        bytes32 city;
    }
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
   }