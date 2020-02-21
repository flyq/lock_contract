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
        "_perPrice" : "\u79df\u7528\u5de5\u4f4d\u7684\u5355\u4ef7\uff0c\u6bcf\u5c0f\u65f6\u591a\u5c11\uff080.0001 ETH\uff09\uff0c\u6bd4\u5982\u6bcf\u5c0f\u65f61ETH\uff0c\u8fd9\u91cc\u9700\u8981\u8f93\u516510000\uff0c\u8fd9\u4e48\u505a\u56e0\u4e3a\u65e0\u6cd5\u8f93\u5165\u5c0f\u6570\uff0c\u76f4\u63a5\u4ee5 Wei \u8ba1\uff0c\u524d\u7aef\u8f93\u5165\u8981\u670918\u4e2a\u96f6\u5de6\u53f3\uff0c\u9ebb\u70e6\u3002"
      }
    },
    "getIdFromIndex(uint256)" : 
    {
      "details" : "getIdFromIndex get in from ids array",
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
      "details" : "rmPlace \u7ba1\u7406\u5458\u5220\u9664\u5de5\u4f4d",
      "params" : 
      {
        "_id" : "the id of the Place that will be deleted."
      }
    },
    "stopPlace(uint256)" : 
    {
      "details" : "stopPlace \u7ba1\u7406\u5458\u6682\u505c\u5de5\u4f4d",
      "params" : 
      {
        "_id" : "the id of the Place that will be stoped."
      }
    },
    "unStopPlace(uint256)" : 
    {
      "details" : "unStopPlace \u7ba1\u7406\u5458\u542f\u52a8\u5df2\u6682\u505c\u7684\u5de5\u4f4d",
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
      "details" : "upgradePlaceStatus upgrade the status of the Place\u6d41\u7a0b\u4e0a\u662f\u79df\u6237\u5230\u671f\u81ea\u52a8\u7ec8\u6b62\u5408\u540c\uff0c\u4e0d\u7528\u8c03\u7528\u5408\u7ea6\u3002\u4f46\u662f\u5408\u7ea6\u7684\u4e00\u4e9b\u72b6\u6001\u6b64\u65f6\u9700\u8981\u66f4\u65b0\uff0c\u56e0\u6b64\u4efb\u4f55\u4eba\u90fd\u53ef\u4ee5\u8c03\u7528\u3002\u5148\u7b80\u5355\u70b9\uff0c\u4e0d\u80fd\u9884\u7ea6\u51e0\u5929\u540e\u5f00\u59cb\u7684\uff0c\u6bd4\u5982\u660e\u5929\u5230\u540e\u5929\u7684\u5de5\u4f4d\u3002\u90fd\u662f\u76f4\u63a5\u4ece now \u5230\u7ed3\u675f\u65f6\u95f4\u56e0\u6b64\u4e0d\u9700\u8981\u68c0\u6d4b start",
      "params" : 
      {
        "_id" : "the Place id"
      }
    },
    "withdraw(uint256)" : 
    {
      "details" : "withdraw \u7ba1\u7406\u5458\u63d0\u53d6\u6536\u76ca",
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