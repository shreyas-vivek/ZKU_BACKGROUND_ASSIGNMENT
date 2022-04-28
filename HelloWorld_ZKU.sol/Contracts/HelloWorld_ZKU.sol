// SPDX-License-Identifier: MIT

//written by SHREYAS VIVEK shreyasvivek01@gmail.com`

//solidity compiler version specification
pragma solidity >=0.7.0 <0.9.0;

//name and creation of contract named HelloWorld
contract HelloWorld {
    ///storeNum contract variable stores the number to be stored
    uint storedNum;

    /// Method for storing new number
    /// storeNumber function to store the number
    function storeNumber(uint number) public {

        // number that is to be stored is stored in the storeNum variable
        storedNum = number;
    }


    /// Method for retrieving the stored number
    function retrieveNumber() public view returns (uint) {
        return storedNum;
    }
}