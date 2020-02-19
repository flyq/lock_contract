pragma solidity 0.4.24;

import "./Roles.sol";

/**
 * @title The rent main contract
 * @dev Defines a contract able to rent and return
 * @dev 先简单点，不能预约几天后开始的，比如明天到后天的工位。都是直接从 now 到结束时间
 */
contract Renting is WhitelistedRole {
    using SafeMath for uint256;

    // created after the rent-function was executed
    event LogRented(
        uint256 indexed id,
        address indexed user,
        uint256 rentedFrom,         // 开始时间
        uint256 rentedUntil,        // 结束时间
        uint256 indexed totalPrice, // 总价
    );

    event LogNewPlace(uint256 indexed id, uint256 indexed perPrice);

    event LogRmPlace(uint256 indexed id);

    event LogWorkToFree(uint256 indexed id, uint256 beforeBegin, uint256 beforeEnd);

    event LogFreeToStop(uint256 indexed id);

    event LogStopToFree(uint256 indexed id);

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
     * @dev 管理员只有在工位无人使用的时候设置为暂停状态。
     */
    enum Status {
        Stop,
        Free,
        OnWork
    }

    // admin

    /**
     * @dev 管理员注册工位，注册工位即可出租
     * @param _perPrice 租用工位的单价，每小时多少（0.0001 ETH），比如每小时1ETH，这里需要输入10000，这么做因为
     * @param 无法输入小数，直接以 Wei 计，前端输入要有18个零左右，麻烦。
     */
    function addPlace(uint256 _id, uint256 _perPrice) public onlySuperAdmin {
        require(_id != 0, "the Place id shouldn't be 0"); // 因为isPlaceExist根据是否是 0 来判断是否初始化
        require(!isPlaceExist(_id), "the Place id already exist");
        places[_id] = Place({
            id: _id,
            status: Status.Free,
            user: address(0),
            begin: 0,
            end: 0,
            perPrice: _perPrice.mul(10**14)
        });
        ids.push(_id);

        emit LogNewPlace(_id, _perPrice);
    }

    /**
     * @dev 管理员移除工位
     */
    function rmPlace(uint256 _id) public onlySuperAdmin {
        require(isPlaceExist(_id), "the Place id doesn't exist");
        upgradePlaceStatus(_id);

        require(places[_id].status == Status.Free, "the Place is on rented");

        delete places[_id];

        uint256 i = 0;
        uint256 length = ids.length;
        while (i < length) {
            if (ids[i] == _id) {
                ids[i] = ids[length-1];
                ids.length--;
                break;
            }
        }

        emit LogRmPlace(_id);
    }

    /**
     * @dev 管理员暂停工位
     */
    function stopPlace(uint256 _id) public onlySuperAdmin {
        require(isPlaceExist(_id), "the Place id doesn't exist");
        upgradePlaceStatus(_id);

        require(places[_id].status == Status.Free, "the Place is on rented");
        places[_id].status == Status.Stop;

        emit LogFreeToStop(_id);
    }

    /**
     * @dev 管理员启动暂停的工位
     */
    function unStopPlace(uint256 _id) public onlySuperAdmin {
        require(isPlaceExist(_id), "the Place id doesn't exist");
        upgradePlaceStatus(_id);

        require(places[_id].status == Status.Stop, "the Place isn't on Stop");
        places[_id].status == Status.Free;

        emit LogStopToFree(_id);
    }

    // normal
    /**
     * @param _id the Place id
     * @param _secondsToRent the time of rental in seconds
     */
    function rent(uint256 _id, uint256 _secondsToRent) external payable onlyWhitelisted {
        require(isPlaceExist(_id), "the Place id doesn't exist");
        upgradePlaceStatus(_id);
        require(places[_id].status == Status.Free, "the Place's status is not free");

        uint256 _price = places[_id].perPrice.mul(_secondsToRent).div(3600);
        require(msg.value >= _price, "the fee is not enough");

        places[_id].user = msg.sender;


        uint256 _overfee = msg.value.sub(_price);
        msg.sender.transfer(_overfee);





    }

    /**
     * @dev 流程上是租户到期自动终止合同，不用调用合约。但是合约的一些状态此时需要更新，因此任何人都可以调用。
     * @dev 先简单点，不能预约几天后开始的，比如明天到后天的工位。都是直接从 now 到结束时间
     * @dev 因此不需要检测 start
     */
    function upgradePlaceStatus(uint256 _id) public {
        require(isPlaceExist(_id), "the Place id doesn't exist");
        if (places[_id].status != Status.OnWork) {
            return;
        } else if (places[_id].end > now) {
            return;
        } else {
            places[_id].status = Status.Free;
            uint256 _begin = places[_id].begin;
            uint256 _end = places[_id].end;
            places[_id].begin = 0;
            places[_id].end = 0;

            emit LogWorkToFree(_id, _begin, _end);
        }
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