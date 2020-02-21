# lock_contract

## how to compile
```shell
truffle compile
```

## api
```json
======= contracts/Renting.sol:Renting =======
Developer Documentation
{
  "methods" : 
  {
    "addPlace(uint256,uint256)" : 
    {
      "details" : "addPlace admin new a Place",
      "params" : 
      {
        "_id" : "the new Place id, It must not be 0.",
        "_perPrice" : "租用工位的单价，每小时多少（0.0001 ETH），比如每小时1ETH，这里需要输入10000，这么做因为无法输入小数，直接以 Wei 计，前端输入要有18个零左右，麻烦。"
      }
    },
    "getIdFromIndex(uint256)" : 
    {
      "details" : "getIdFromIndex get id from ids array",
      "params" : 
      {
        "_index" : "the index of ids array"
      },
      "return" : "element of ids, that is Place's id"
    },
    "getPlaceBegin(uint256)" : 
    {
      "details" : "getPlaceBegin get the begin infomation of a Place",
      "params" : 
      {
        "_id" : "Place id"
      },
      "return" : "begin's Unix timestamp of the Place."
    },
    "getPlaceEnd(uint256)" : 
    {
      "details" : "getPlaceEnd get the end infomation of a Place",
      "params" : 
      {
        "_id" : "Place id"
      },
      "return" : "end's Unix timestamp of the Place."
    },
    "getPlaceInfo(uint256)" : 
    {
      "details" : "getPlaceInfo get the detail infomation of a Place",
      "params" : 
      {
        "_id" : "Place id"
      },
      "return" : "status, user, begin and end infomation of the Place."
    },
    "getPlacePerPrice(uint256)" : 
    {
      "details" : "getPlacePerPrice get the perPrice infomation of a Place",
      "params" : 
      {
        "_id" : "Place id"
      },
      "return" : "the perPrice of the Place."
    },
    "getPlaceState(uint256)" : 
    {
      "details" : "getPlaceState get the State infomation of a Place",
      "params" : 
      {
        "_id" : "Place id"
      },
      "return" : "status of the Place."
    },
    "getPlaceUser(uint256)" : 
    {
      "details" : "getPlaceUser get the user infomation of a Place",
      "params" : 
      {
        "_id" : "Place id"
      },
      "return" : "user address of the Place."
    },
    "getPrice(uint256,uint256)" : 
    {
      "details" : "getPrice the total price for rentinng the Place",
      "params" : 
      {
        "_id" : "the Place id",
        "_secondsToRent" : "the duration of rent the Place"
      },
      "return" : "_price price to be payed for renting the Place"
    },
    "getStateCount(uint8)" : 
    {
      "details" : "getStateCount get the amount of Place that is in this Status. returns the current amount of states",
      "params" : 
      {
        "_status" : "the Status"
      },
      "return" : "_amount amount of states of a device"
    },
    "getTotalAmount()" : 
    {
      "details" : "getTotalAmount get the total amount of Places",
      "return" : "the amount of Places"
    },
    "isPlaceExist(uint256)" : 
    {
      "details" : "isPlaceExist judge whether a Place exist",
      "params" : 
      {
        "_id" : "Place id"
      },
      "return" : "if exist, true"
    },
    "rent(uint256,uint256)" : 
    {
      "details" : "rent user rent the Place",
      "params" : 
      {
        "_id" : "the Place id",
        "_secondsToRent" : "the time of rental in seconds"
      }
    },
    "rmPlace(uint256)" : 
    {
      "details" : "rmPlace 管理员删除工位",
      "params" : 
      {
        "_id" : "the id of the Place that will be deleted."
      }
    },
    "stopPlace(uint256)" : 
    {
      "details" : "stopPlace 管理员暂停工位",
      "params" : 
      {
        "_id" : "the id of the Place that will be stoped."
      }
    },
    "unStopPlace(uint256)" : 
    {
      "details" : "unStopPlace 管理员启动已暂停的工位",
      "params" : 
      {
        "_id" : "the id of the Place that will be unstoped."
      }
    },
    "upgradeAllPlaceStatus()" : 
    {
      "details" : "upgradeAllPlaceStatus upgrade the status of all Place."
    },
    "upgradeAllPlaceStatus2(uint256,uint256)" : 
    {
      "details" : "upgradeAllPlaceStatus2 upgrade the status of all Place.",
      "params" : 
      {
        "_a" : "the begin Place'index that want to be upgraded",
        "_b" : "the end Place'index that want to be upgraded"
      }
    },
    "upgradePlaceStatus(uint256)" : 
    {
      "details" : "流程上是租户到期自动终止合同，不用调用合约。但是合约的一些状态此时需要更新，因此任何人都可以调用。先简单点，不能预约几天后开始的，比如明天到后天的工位。都是直接从 now 到结束时间，因此不需要检测 start",
      "params" : 
      {
        "_id" : "the Place id"
      }
    },
    "withdraw(uint256)" : 
    {
      "details" : "withdraw 管理员提取收益",
      "params" : 
      {
        "_amount" : "the amount of Wei will be withdraw."
      }
    }
  },
  "title" : "The rent main contract"
}
User Documentation
{
  "methods" : 
  {
    "addPlace(uint256,uint256)" : 
    {
      "notice" : "Only admin can execute it.after this, user can rent it."
    },
    "getPlaceState(uint256)" : 
    {
      "notice" : "0 stand for Stop; 1 stand for Free, 2 stand for OnWork"
    },
    "getStateCount(uint8)" : 
    {
      "notice" : "make sure  upgradeAllPlaceStatus() is executed before call this function, or the amount is not accurate;"
    },
    "rent(uint256,uint256)" : 
    {
      "notice" : "Only Whitelisted can execute it."
    },
    "rmPlace(uint256)" : 
    {
      "notice" : "Only admin can execute it.Only the `Free` Place can be deleted"
    },
    "stopPlace(uint256)" : 
    {
      "notice" : "Only admin can execute it.Only the `Free` Place can be stoped"
    },
    "unStopPlace(uint256)" : 
    {
      "notice" : "Only admin can execute it.Only the `Stop` Place can be upstoped"
    },
    "upgradeAllPlaceStatus()" : 
    {
      "notice" : "if gas is too high, use upgradeAllPlaceStatus2"
    },
    "upgradeAllPlaceStatus2(uint256,uint256)" : 
    {
      "notice" : "upgrade the Place's status that is in ids[_a, _b]"
    },
    "withdraw(uint256)" : 
    {
      "notice" : "Only admin can execute it."
    }
  }
}

======= contracts/Roles.sol:Roles =======
Developer Documentation
{
  "methods" : {},
  "title" : "Roles"
}
User Documentation
{
  "methods" : {}
}

======= contracts/Roles.sol:SuperAdminRole =======
Developer Documentation
{
  "methods" : {},
  "title" : "SuperAdminRole"
}
User Documentation
{
  "methods" : {}
}

======= contracts/Roles.sol:WhitelistedRole =======
Developer Documentation
{
  "methods" : {},
  "title" : "WhitelistedRole"
}
User Documentation
{
  "methods" : {}
}

======= contracts/SafeMath.sol:SafeMath =======
Developer Documentation
{
  "methods" : {},
  "title" : "SafeMath v0.1.9"
}
User Documentation
{
  "methods" : {}
}
```