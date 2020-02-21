# lock_contract

## how to compile
```shell
truffle compile
```

## api
```jsong
======= Renting.sol:Renting =======
Developer Documentation
{
  "methods" : 
  {
    "addPlace(uint256,uint256)" : 
    {
      "details" : "\u7ba1\u7406\u5458\u6ce8\u518c\u5de5\u4f4d\uff0c\u6ce8\u518c\u5de5\u4f4d\u5373\u53ef\u51fa\u79df\u65e0\u6cd5\u8f93\u5165\u5c0f\u6570\uff0c\u76f4\u63a5\u4ee5 Wei \u8ba1\uff0c\u524d\u7aef\u8f93\u5165\u8981\u670918\u4e2a\u96f6\u5de6\u53f3\uff0c\u9ebb\u70e6\u3002",
      "params" : 
      {
        "_perPrice" : "\u79df\u7528\u5de5\u4f4d\u7684\u5355\u4ef7\uff0c\u6bcf\u5c0f\u65f6\u591a\u5c11\uff080.0001 ETH\uff09\uff0c\u6bd4\u5982\u6bcf\u5c0f\u65f61ETH\uff0c\u8fd9\u91cc\u9700\u8981\u8f93\u516510000\uff0c\u8fd9\u4e48\u505a\u56e0\u4e3a"
      }
    },
    "getIdFromIndex(uint256)" : 
    {
      "return" : "element of ids;"
    },
    "getPlaceInfo(uint256)" : 
    {
      "details" : "returns the important informations of a state",
      "params" : 
      {
        "_id" : "Place id"
      },
      "return" : "controller, rentedFrom, rentedUntil and properties of the given index beloning to the state"
    },
    "getPrice(uint256,uint256)" : 
    {
      "details" : "the total price for rentinng the Place",
      "params" : 
      {
        "_id" : "the Place id"
      },
      "return" : "price to be payed for renting the device"
    },
    "getStateCount(uint8)" : 
    {
      "details" : "returns the current amount of statescall upgradeAllPlaceStatus() before call this function, or the amount is not accurate;",
      "params" : 
      {
        "_status" : "deviceid"
      },
      "return" : "amount of states of a device"
    },
    "getTotalAmount()" : 
    {
      "details" : "get the total amount of Places"
    },
    "rent(uint256,uint256)" : 
    {
      "params" : 
      {
        "_id" : "the Place id",
        "_secondsToRent" : "the time of rental in seconds"
      }
    },
    "rmPlace(uint256)" : 
    {
      "details" : "\u7ba1\u7406\u5458\u79fb\u9664\u5de5\u4f4d"
    },
    "stopPlace(uint256)" : 
    {
      "details" : "\u7ba1\u7406\u5458\u6682\u505c\u5de5\u4f4d"
    },
    "unStopPlace(uint256)" : 
    {
      "details" : "\u7ba1\u7406\u5458\u542f\u52a8\u6682\u505c\u7684\u5de5\u4f4d"
    },
    "upgradeAllPlaceStatus2(uint256,uint256)" : 
    {
      "details" : "upgrade [_a, _b] status"
    },
    "upgradePlaceStatus(uint256)" : 
    {
      "details" : "\u6d41\u7a0b\u4e0a\u662f\u79df\u6237\u5230\u671f\u81ea\u52a8\u7ec8\u6b62\u5408\u540c\uff0c\u4e0d\u7528\u8c03\u7528\u5408\u7ea6\u3002\u4f46\u662f\u5408\u7ea6\u7684\u4e00\u4e9b\u72b6\u6001\u6b64\u65f6\u9700\u8981\u66f4\u65b0\uff0c\u56e0\u6b64\u4efb\u4f55\u4eba\u90fd\u53ef\u4ee5\u8c03\u7528\u3002\u5148\u7b80\u5355\u70b9\uff0c\u4e0d\u80fd\u9884\u7ea6\u51e0\u5929\u540e\u5f00\u59cb\u7684\uff0c\u6bd4\u5982\u660e\u5929\u5230\u540e\u5929\u7684\u5de5\u4f4d\u3002\u90fd\u662f\u76f4\u63a5\u4ece now \u5230\u7ed3\u675f\u65f6\u95f4\u56e0\u6b64\u4e0d\u9700\u8981\u68c0\u6d4b start"
    },
    "withdraw(uint256)" : 
    {
      "details" : "\u7ba1\u7406\u5458\u63d0\u53d6\u6536\u76ca"
    }
  },
  "title" : "The rent main contract"
}
User Documentation
{
  "methods" : {}
}

======= Roles.sol:Roles =======
Developer Documentation
{
  "methods" : {},
  "title" : "Roles"
}
User Documentation
{
  "methods" : {}
}

======= Roles.sol:SuperAdminRole =======
Developer Documentation
{
  "methods" : {},
  "title" : "SuperAdminRole"
}
User Documentation
{
  "methods" : {}
}

======= Roles.sol:WhitelistedRole =======
Developer Documentation
{
  "methods" : {},
  "title" : "WhitelistedRole"
}
User Documentation
{
  "methods" : {}
}

======= SafeMath.sol:SafeMath =======
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