const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const BestSwapFactoryModule = buildModule("TokenModule", (m) => {
  // Retrieve values from environment variables
  const feeSetterAddress =
    process.env.FEE_SETTER_ADDRESS ||
    "0x7d026bc78947A76096BA1256Bb1EF3113eAB3eB6";
  const totalFeeBasisPoint = process.env.TOTAL_FEE_BASIS_POINT
    ? parseInt(process.env.TOTAL_FEE_BASIS_POINT)
    : 50;
  const feeToBasisPoint = process.env.FEE_TO_BASIS_POINT
    ? parseInt(process.env.FEE_TO_BASIS_POINT)
    : 10;

  // Validate the parameters to prevent deployment issues
  if (
    isNaN(totalFeeBasisPoint) ||
    isNaN(feeToBasisPoint) ||
    !feeSetterAddress
  ) {
    throw new Error(
      "Invalid configuration: Check environment variables for FEE_SETTER_ADDRESS, TOTAL_FEE_BASIS_POINT, and FEE_TO_BASIS_POINT."
    );
  }

  // Deploy BestSwapFactory with validated constructor arguments
  const bestSwapFactory = m.contract("BestSwapFactory", [
    feeSetterAddress,
    totalFeeBasisPoint,
    feeToBasisPoint,
  ]);

  return { bestSwapFactory };
});

module.exports = BestSwapFactoryModule;
