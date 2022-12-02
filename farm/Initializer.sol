// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IOWNER {
    function owner() external view returns (address);
    function renounceOwnership() external;
    function transferOwnership(address newOwner) external;
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IFuryToken {
    function setMinter(address _minter, bool _flag) external;
}

interface IReferral {
    function setOperator(address _operator, bool _flag) external;
}

interface IMasterChef {
    function poolLength() external view returns (uint256 pools);
    function add(uint256 _allocPoint, address _lpToken, bool _isRegular, bool _withUpdate) external;
    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate ) external;
    function pendingFury(uint256 _pid, address _user) external view returns (uint256);
    function massUpdatePools() external;
    function furyPerBlock(bool _isRegular) external view returns (uint256 amount);
    function furyPerBlockToBurn() external view returns (uint256 amount);
    function deposit(uint256 _pid, uint256 _amount, address _referrer) external;
    function withdraw(uint256 _pid, uint256 _amount) external;
    function emergencyWithdraw(uint256 _pid) external;
    function burnFury(bool _withUpdate) external;
    function updateFuryRate(uint256 _burnRate, uint256 _regularFarmRate, uint256 _specialFarmRate, bool _withUpdate) external;
    function updateBurnAdmin(address _newAdmin) external;
    function updateWhiteList(address _user, bool _isValid) external;
    function updateBoostContract(address _newBoostContract) external;
    function updateDevAddress(address _devAddr) external;
    function updateBoostMultiplier(address _user, uint256 _pid, uint256 _newMultiplier) external;
    function getBoostMultiplier(address _user, uint256 _pid) external view returns (uint256);
    function updateStartBlock(uint256 _startBlock) external;
}

interface IFURYPool {
    function init(address dummyToken) external;
    function unlock(address _user) external;
    function deposit(uint256 _amount, uint256 _lockDuration, address _referrer) external;
    function withdrawByAmount(uint256 _amount) external;
    function withdraw(uint256 _shares) external;
    function withdrawAll() external;
    function setAdmin(address _admin) external;
    function setTreasury(address _treasury) external;
    function setOperator(address _operator) external;
    function setBoostContract(address _boostContract) external;
    function setVFuryContract(address _VFury) external;
    function setFreePerformanceFeeUser(address _user, bool _free) external;
    function setOverdueFeeUser(address _user, bool _free) external;
    function setWithdrawFeeUser(address _user, bool _free) external;
    function setPerformanceFee(uint256 _performanceFee) external;
    function setPerformanceFeeContract(uint256 _performanceFeeContract) external;
    function setWithdrawFee(uint256 _withdrawFee) external;
    function setOverdueFee(uint256 _overdueFee) external;
    function setWithdrawFeeContract(uint256 _withdrawFeeContract) external;
    function setWithdrawFeePeriod(uint256 _withdrawFeePeriod) external;
    function setMaxLockDuration(uint256 _maxLockDuration) external;
    function setDurationFactor(uint256 _durationFactor) external;
    function setDurationFactorOverdue(uint256 _durationFactorOverdue) external;
    function setUnlockFreeDuration(uint256 _unlockFreeDuration) external;
    function setBoostWeight(uint256 _boostWeight) external;
    function inCaseTokensGetStuck(address _token) external;
    function pause() external;
    function unpause() external;
    function calculatePerformanceFee(address _user) external view returns (uint256);
    function calculateOverdueFee(address _user) external view returns (uint256);
    function calculateWithdrawFee(address _user, uint256 _shares) external view returns (uint256);
    function calculateTotalPendingFuryRewards() external view returns (uint256);
    function getPricePerFullShare() external view returns (uint256);
    function available() external view returns (uint256);
    function balanceOf() external view returns (uint256);
}

interface IFURYFlexiblePool {
    function deposit(uint256 _amount, address _referrer) external;
    function withdraw(uint256 _shares) external;
    function withdrawAll() external;
    function setAdmin(address _admin) external;
    function setTreasury(address _treasury) external;
    function setPerformanceFee(uint256 _performanceFee) external;
    function setWithdrawFee(uint256 _withdrawFee) external;
    function setWithdrawFeePeriod(uint256 _withdrawFeePeriod) external;
    function setWithdrawAmountBooster(uint256 _withdrawAmountBooster) external;
    function emergencyWithdraw() external;
    function inCaseTokensGetStuck(address _token) external;
    function pause() external;
    function unpause() external;
    function getPricePerFullShare() external view returns (uint256);
    function available() external view returns (uint256);
    function balanceOf() external view returns (uint256);
}

interface IDummyToken {
    function mintTokens(address _to, uint256 _amount) external;
    function management(address _manager, bool _flag) external;
}

interface IRandomNumberGenerator {
    function setFee(uint256 _fee) external;
    function setKeyHash(bytes32 _keyHash) external;
    function setLotteryAddress(address _lightFurySwapLottery) external;
}

interface ILightFurySwapLottery {
    function setOperatorAndTreasuryAndInjectorAddresses(
        address _operatorAddress,
        address _treasuryAddress,
        address _injectorAddress
    ) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

contract Initializer is Ownable {

    IUniswapV2Router02 public router;
    IUniswapV2Factory public factory;
    address public BUSD = address(0x1c7f85bFdFBC965289B7A523833fBED1FAFCFD6d);
    address public FURY_ETH_lp;
    address public BUSD_ETH_lp = address(0xb2a2d1A857E9562cB2d025583b7DDc50BD3bb8e2);
    address public FURY_BUSD_lp;
    address public projectOwner = address(0x976899e6Cf1b9aa1De8F8dF95fc8bFe897DBf70e);
    address public projectTreasury = address(0xe4bb49583e45F43d989571091546353d16E8E5C9);
    address public projectDev = address(0x763bd45B2b1500d62F2cfC0D7a7816c19a4BAd3A);

    constructor(){}

    function initialize(
        address fury,
        address referral,
        address masterChef,
        address furyPool,
        address furyFlexiblePool,
        address dFURYPOOL,
        address dLOTTO,
        address randomNumberGenerator,
        address lightFurySwapLottery
    ) external onlyOwner {
        router = IUniswapV2Router02(0x2154D5532E78b28d486d2D0A4140291bCDC5AB60);
        factory = IUniswapV2Factory(router.factory());
        FURY_ETH_lp = factory.createPair(fury, router.WETH());
        FURY_BUSD_lp = factory.createPair(fury, BUSD);

        IFuryToken(fury).setMinter(masterChef, true);
        IFuryToken(fury).setMinter(furyPool, true);
        IFuryToken(fury).setMinter(furyFlexiblePool, true);
        uint256 balance = IERC20(fury).balanceOf(address(this));
        IERC20(fury).transfer(projectOwner, balance);
        IOWNER(fury).transferOwnership(projectOwner);

        IReferral(referral).setOperator(masterChef, true);
        IReferral(referral).setOperator(furyPool, true);
        IReferral(referral).setOperator(furyFlexiblePool, true);
        IOWNER(referral).transferOwnership(projectOwner);

        IMasterChef(masterChef).updateBurnAdmin(projectOwner);
        IMasterChef(masterChef).updateDevAddress(projectDev);
        IMasterChef(masterChef).updateWhiteList(furyPool, true);
        IMasterChef(masterChef).add(57600, dFURYPOOL, false, false); // 0
        IMasterChef(masterChef).add(0, dLOTTO, false, false); // 1
        IMasterChef(masterChef).add(4000, FURY_ETH_lp, true, false); // 2
        IMasterChef(masterChef).add(3000, BUSD_ETH_lp, true, false); // 3
        IMasterChef(masterChef).add(2000, FURY_BUSD_lp, true, false); // 4
        IOWNER(masterChef).transferOwnership(projectOwner);

        IFURYPool(furyPool).setAdmin(projectOwner);
        IFURYPool(furyPool).setTreasury(projectTreasury);
        IFURYPool(furyPool).setOperator(projectOwner);
        balance = IERC20(dFURYPOOL).balanceOf(address(this));
        IERC20(dFURYPOOL).approve(furyPool, balance);
        IFURYPool(furyPool).init(dFURYPOOL);
        IOWNER(furyPool).transferOwnership(projectOwner);

        IFURYFlexiblePool(furyFlexiblePool).setAdmin(projectOwner);
        IFURYFlexiblePool(furyFlexiblePool).setTreasury(projectTreasury);
        IOWNER(furyFlexiblePool).transferOwnership(projectOwner);
        IOWNER(dFURYPOOL).transferOwnership(projectOwner);
        IOWNER(dLOTTO).transferOwnership(projectOwner);

        IRandomNumberGenerator(randomNumberGenerator).setFee(100000000000000000);
        IRandomNumberGenerator(randomNumberGenerator).setKeyHash(
            0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15
        );
        IRandomNumberGenerator(randomNumberGenerator).setLotteryAddress(lightFurySwapLottery);
        IOWNER(randomNumberGenerator).transferOwnership(projectOwner);

        ILightFurySwapLottery(lightFurySwapLottery).setOperatorAndTreasuryAndInjectorAddresses(
            projectOwner, projectTreasury, projectOwner
        );
        IOWNER(lightFurySwapLottery).transferOwnership(projectOwner);
    }

    function selfDestruct() external onlyOwner {
        selfdestruct(payable(msg.sender));
    }

}