// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.5.16;

import './interfaces/IBestSwapFactory.sol';
import './BestSwapPair.sol';

contract BestSwapFactory is IBestSwapFactory {
    address public feeTo;
    address public feeSetter;
    uint public feeToBasisPoint;
    uint public totalFeeBasisPoint;
    uint public MAX_EVER_ALLOWED_TOTAL_FEE_BASIS_POINT = 50; // 50 basis points

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    constructor(address _feeSetter, uint _totalFeeBasisPoint, uint _feeToBasisPoint) public {
        require(_totalFeeBasisPoint>=_feeToBasisPoint, '_totalFeeBasisPoint should be larger than or equal to _feeToBasisPoint');
        feeSetter = _feeSetter;
        totalFeeBasisPoint = _totalFeeBasisPoint;
        feeToBasisPoint = _feeToBasisPoint;
    }

    function allPairsLength() external view returns (uint) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB) external returns (address pair) {
        require(tokenA != tokenB, 'BestSwap: IDENTICAL_ADDRESSES');
        (address token0, address token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'BestSwap: ZERO_ADDRESS');
        require(getPair[token0][token1] == address(0), 'BestSwap: PAIR_EXISTS'); // single check is sufficient
        bytes memory bytecode = type(BestSwapPair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IBestSwapPair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeSetter, 'BestSwap: FORBIDDEN - only current feeSetter can update feeTo');
        address previousFeeTo = feeTo;
        feeTo = _feeTo;
        emit FeeToUpdated(feeTo, previousFeeTo);
    }

    function setFeeSetter(address _feeSetter) external {
        require(msg.sender == feeSetter, 'BestSwap: FORBIDDEN - only current feeSetter can update next feeSetter');
        address previousFeeSetter = feeSetter;
        feeSetter = _feeSetter;
        emit FeeSetterUpdated(feeSetter, previousFeeSetter);
    }

    function setFeeToBasisPoint(uint _feeToBasisPoint) external {
        require(msg.sender == feeSetter, 'BestSwap: FORBIDDEN - only current feeSetter can update feeToBasisPoint');
        require(_feeToBasisPoint >= 0, 'BestSwap: FORBIDDEN - _feeToBasisPoint need to be bigger than or equal to 0');
        require(_feeToBasisPoint <= totalFeeBasisPoint, 'BestSwap: FORBIDDEN - _feeToBasisPoint need to be smaller than or equal to totalFeeBasisPoint');
        uint previousFeeToBasisPoint = feeToBasisPoint;
        feeToBasisPoint = _feeToBasisPoint;
        emit FeeToBasisPointUpdated(feeToBasisPoint, previousFeeToBasisPoint);
    }

    function setTotalFeeBasisPoint(uint _totalFeeBasisPoint) external {
        require(msg.sender == feeSetter, 'BestSwap: FORBIDDEN - only current feeSetter can update feeToBasisPoint');
        require(_totalFeeBasisPoint >= feeToBasisPoint, 'BestSwap: FORBIDDEN - _totalFeeBasisPoint need to be bigger than or equal to feeToBasisPoint');
        require(_totalFeeBasisPoint <= MAX_EVER_ALLOWED_TOTAL_FEE_BASIS_POINT, 'BestSwap: FORBIDDEN - _totalFeeBasisPoint could never go beyond MAX_EVER_ALLOWED_TOTAL_FEE_BASIS_POINT');
        uint previousTotalFeeBasisPoint = totalFeeBasisPoint;
        totalFeeBasisPoint = _totalFeeBasisPoint;
        emit TotalFeeBasisPointUpdated(totalFeeBasisPoint, previousTotalFeeBasisPoint);
    }
}
