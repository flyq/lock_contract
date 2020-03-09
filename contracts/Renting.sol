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
        uint256 indexed totalPrice  // 总价
    );

    event LogNewPlace(uint256 indexed id, uint256 indexed perPrice);

    event LogRmPlace(uint256 indexed id);

    event LogFreeToStop(uint256 indexed id);

    event LogStopToFree(uint256 indexed id);

    event LogWorkToFree(uint256 indexed id, uint256 beforeBegin, uint256 beforeEnd);

    event LogFreeToWork(
        uint256 indexed id,
        uint256 begin,
        uint256 end,
        address  indexed user,
        uint256 indexed totalPrice
    );

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
     * @dev addPlace admin new a Place
     * @param _id the new Place id, It must not be 0.
     * @param _perPrice 租用工位的单价，每小时多少（0.0001 ETH），比如每小时1ETH，这里需要输入10000，这么做因为无法输入小数，直接以 Wei 计，前端输入要有18个零左右，麻烦。
     * @notice Only admin can execute it.
     * @notice after this, user can rent it.
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
     * @dev rmPlace 管理员删除工位
     * @param _id the id of the Place that will be deleted.
     * @notice Only admin can execute it.
     * @notice Only the `Free` Place can be deleted
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
     * @dev stopPlace 管理员暂停工位
     * @param _id the id of the Place that will be stoped.
     * @notice Only admin can execute it.
     * @notice Only the `Free` Place can be stoped
     */
    function stopPlace(uint256 _id) public onlySuperAdmin {
        require(isPlaceExist(_id), "the Place id doesn't exist");
        upgradePlaceStatus(_id);

        require(places[_id].status == Status.Free, "the Place is on rented, or already stopped");
        places[_id].status == Status.Stop;

        emit LogFreeToStop(_id);
    }

    /**
     * @dev unStopPlace 管理员启动已暂停的工位
     * @param _id the id of the Place that will be unstoped.
     * @notice Only admin can execute it.
     * @notice Only the `Stop` Place can be upstoped
     */
    function unStopPlace(uint256 _id) public onlySuperAdmin {
        require(isPlaceExist(_id), "the Place id doesn't exist");
        upgradePlaceStatus(_id);

        require(places[_id].status == Status.Stop, "the Place isn't on Stop");
        places[_id].status == Status.Free;

        emit LogStopToFree(_id);
    }

    /**
     * @dev withdraw 管理员提取收益
     * @param _amount the amount of Wei will be withdraw.
     * @notice Only admin can execute it.
     */
    function withdraw(uint256 _amount) public onlySuperAdmin {
        msg.sender.transfer(_amount);
    }

    // normal
    /**
     * @dev rent user rent the Place
     * @param _id the Place id
     * @param _secondsToRent the time of rental in seconds
     * @notice Only Whitelisted can execute it.
     */
    function rent(uint256 _id, uint256 _secondsToRent) external payable onlyWhitelisted {
        require(isPlaceExist(_id), "the Place id doesn't exist");
        upgradePlaceStatus(_id);
        require(places[_id].status == Status.Free, "the Place's status is not free");

        uint256 _price = getPrice(_id, _secondsToRent);
        require(msg.value >= _price, "the fee is not enough");

        places[_id].status = Status.OnWork;
        places[_id].user = msg.sender;
        places[_id].begin = now;
        places[_id].end = now.add(_secondsToRent);


        uint256 _overfee = msg.value.sub(_price);
        msg.sender.transfer(_overfee);

        emit LogFreeToWork(_id, now, now.add(_secondsToRent), msg.sender, _price);
    }

    /**
     * @dev upgradePlaceStatus upgrade the status of the Place
     * @param _id the Place id
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
     * @dev upgradeAllPlaceStatus upgrade the status of all Place.
     * @notice if gas is too high, use upgradeAllPlaceStatus2
     */
    function upgradeAllPlaceStatus() public {
        for(uint256 i = 0; i < ids.length; i++) {
            uint256 _id = ids[i];
            upgradePlaceStatus(_id);
        }
    }

    /**
     * @dev upgradeAllPlaceStatus2 upgrade the status of all Place.
     * @param _a the begin Place'index that want to be upgraded
     * @param _b the end Place'index that want to be upgraded
     * @notice upgrade the Place's status that is in ids[_a, _b]
     */
    function upgradeAllPlaceStatus2(uint256 _a, uint256 _b) public {
        require(_a < _b, "error order");
        require(_b < ids.length, "should smaller than ids.length");
        for(uint256 i = _a; i <= _b; i++) {
            uint256 _id = ids[i];
            upgradePlaceStatus(_id);
        }
    }

    // view

    /**
     * @dev getPrice the total price for rentinng the Place
     * @param _id the Place id
     * @param _secondsToRent the duration of rent the Place
     * @return _price price to be payed for renting the Place
     */
    function getPrice(uint256 _id, uint256 _secondsToRent) public view returns (uint256) {
        require(isPlaceExist(_id), "the Place id doesn't exist");
        uint256 _price = places[_id].perPrice.mul(_secondsToRent).div(3600);
        return _price;
    }

    /**
     * @dev getStateCount get the amount of Place that is in this Status. returns the current amount of states
     * @param _status the Status
     * @return _amount amount of states of a device
     * @notice make sure  upgradeAllPlaceStatus() is executed before call this function, or the amount is not accurate;
     */
    function getStateCount(Status _status) external view returns (uint256) {
        uint256 _amount = 0;
        for(uint256 i = 0; i < ids.length; i++) {
            uint256 _id = ids[i];
            if (places[_id].status == _status) {
                _amount++;
            }
        }
        return _amount;
    }

    /**
     * @dev getTotalAmount get the total amount of Places
     * @return the amount of Places
     */
    function getTotalAmount() external view returns (uint256) {
        return ids.length;
    }

    /**
     * @dev getIdFromIndex get id from ids array
     * @param _index the index of ids array
     * @return element of ids, that is Place's id
     */
    function getIdFromIndex(uint256 _index) external view returns (uint256) {
        require(_index < ids.length, "error _index");
        return ids[_index];
    }

    /**
     * @dev getPlaceInfo get the detail infomation of a Place
     * @param _id Place id
     * @return status, user, begin and end infomation of the Place.
     */
    function getPlaceInfo(uint256 _id) external view returns (Status _status, address _user, uint256 _begin, uint256 _end, uint256 _perPrice) {
        require(isPlaceExist(_id), "the place _id is not exists");

        _status = places[_id].status;
        _user = places[_id].user;
        _begin = places[_id].begin;
        _end = places[_id].end;
        _perPrice = places[_id].perPrice;
    }

    /**
     * @dev getPlaceState get the State infomation of a Place
     * @param _id Place id
     * @return status of the Place.
     * @notice 0 stand for Stop; 1 stand for Free, 2 stand for OnWork
     */
    function getPlaceState(uint256 _id) public view returns(Status) {
        require(isPlaceExist(_id), "the place _id is not exists");

        return places[_id].status;
    }

    /**
     * @dev getPlaceUser get the user infomation of a Place
     * @param _id Place id
     * @return user address of the Place.
     */
    function getPlaceUser(uint256 _id) public view returns(address) {
        require(isPlaceExist(_id), "the place _id is not exists");

        return places[_id].user;
    }

    /**
     * @dev getPlaceBegin get the begin infomation of a Place
     * @param _id Place id
     * @return begin's Unix timestamp of the Place.
     */
    function getPlaceBegin(uint256 _id) public view returns(uint256) {
        require(isPlaceExist(_id), "the place _id is not exists");

        return places[_id].begin;
    }

    /**
     * @dev getPlaceEnd get the end infomation of a Place
     * @param _id Place id
     * @return end's Unix timestamp of the Place.
     */
    function getPlaceEnd(uint256 _id) public view returns(uint256) {
        require(isPlaceExist(_id), "the place _id is not exists");

        return places[_id].end;
    }

    /**
     * @dev getPlacePerPrice get the perPrice infomation of a Place
     * @param _id Place id
     * @return the perPrice of the Place.
     */
    function getPlacePerPrice(uint256 _id) public view returns(uint256) {
        require(isPlaceExist(_id), "the place _id is not exists");

        return places[_id].perPrice;
    }

    /**
     * @dev isPlaceExist judge whether a Place exist
     * @param _id Place id
     * @return if exist, true
     */
    function isPlaceExist(uint256 _id) public view returns (bool) {
        if(places[_id].id != 0) {
            return true;
        } else {
            return false;
        }
    }
}