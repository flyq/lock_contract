pragma solidity 0.4.24;

import "./Roles.sol";

/**
 * @title The rent main contract
 * @dev Defines a contract able to rent and return
 */
contract Renting is WhitelistedRole {

    // created after the rent-function was executed
    event LogRented(
        uint256 indexed id,
        address indexed user,
        uint256 rentedFrom,         // 开始时间
        uint256 rentedUntil,        // 结束时间
        uint256 indexed totalPrice, // 总价
    );

    event LogNewPlace(uint256 indexed id, uint256 indexed perPrice);

    /**
     * @dev 工位数据结构
     */
    struct Place {
        uint256 id;         // 工位id；
        Status status;      // 工位状态；
        address user;       // 工位租用者，若是UnInit，Free，则为0x0地址
        uint256 begin;      // 这轮次租用的开始时间，Unix时间戳，若是UnInit，Free，则为0
        uint256 end;        // 这轮此租用的结束时间，Unix时间戳，若是UnInit，Free，则为0
        uint256 perPrice;   // 租用单价，perPrice Wei/h。有工位 Id，就会有单价，即初始化时就设置好，后续可以调整。
    }

    mapping (uint256=>Place) places;
    uint256[] ids;

    /**
     * @dev 工位状态包括暂停状态（不能租）；自由状态（可以租）；被使用状态（已被占用，不能租）
     * @dev 存在某个时刻，工位其实租用已经结束（本应该为Free状态），但是此时status仍是OnWork，需根据时间判断
     */
    enum Status {
        Stop,
        Free,
        OnWork
    }

    /**
     * @dev 管理员注册工位，注册工位即可出租
     */
    function addPlace(uint256 _id, uint256 _perPrice) public onlySuperAdmin {
        require(!isPlaceExist(_id), "the Place id already exist");
        places[_id] = Place({
            id: _id,
            status: Status.Free,
            user: address(0),
            begin: 0,
            end: 0,
            perPrice: _perPrice
        });
        ids.push(_id);

        emit LogNewPlace(_id, _perPrice);
    }

    /**
     * @param id the Place id
     * @param secondsToRent the time of rental in seconds
     * @param begin the start time of rental
     */
    function rent(uint256 id, uint256 secondsToRent, uint256 begin) external payable {

    }



    /**
     * @param id the Place id
     * @return price to be payed for renting the device
     * @dev the total price for rentinng the Place
     */
    function price(uint256 id, uint256 secondsToRent) public view returns (uint256) {

    }





    // view

    /// returns the current amount of renting states
    /// @param id deviceid
    /// @return amount of states of a device
    function getStateCount(Status status) external view returns (uint256) {

    }

    /// returns the important informations of a state 
    /// @param id deviceid
    /// @param index stateindex
    /// @return controller, rentedFrom, rentedUntil and properties of the given index beloning to the state
    function getPlaceInfo(uint256 id) external view returns (address controller, uint64 rentedFrom, uint64 rentedUntil, uint128 properties);
    function getPlaceState(uint256 id) public view returns(Status) {

    }

    function isPlaceExist(uint256 _id) public view returns (bool) {
        if(places[_id].id != 0) {
            return true;
        } else {
            return false;
        }
    }
}