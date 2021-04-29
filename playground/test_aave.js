import { v1, v2 } from '@aave/protocol-js';

// returns user summary data in big units.
v1.formatUserSummaryData(
  poolReservesData,
  rawUserReserves,
  userId,
  usdPriceEth,
  currentTimestamp
);

// returns user summary data in small units with 0 decimal places, except health-factor.
v1.computeRawUserSummaryData(
  poolReservesData,
  rawUserReserves,
  userId,
  usdPriceEth,
  currentTimestamp
);

// returns reserves data formatted to big units.
console.log(v2.formatReserves(reserves, currentTimestamp));