import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-foundry";
import "@nomicfoundation/hardhat-verify";
import * as dotenv from "dotenv";

dotenv.config();

const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.28",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
            details: {
              yul: true,
              yulDetails: {
                stackAllocation: true,
                optimizerSteps: "u"
              }
            }
          },
          viaIR: true,
          evmVersion: "paris"
        }
      }
    ]
  },
  networks: {
    "optimism-sepolia": {
      url: `https://sepolia.optimism.io`,
      accounts: process.env.WALLET_PRIVATE_KEY ? [process.env.WALLET_PRIVATE_KEY] : [],
      chainId: 11155420
    },
    "monad-testnet": {
      url: `https://testnet-rpc.monad.xyz`,
      accounts: process.env.WALLET_PRIVATE_KEY ? [process.env.WALLET_PRIVATE_KEY] : [],
      chainId: 10143
    }
  },
  sourcify: {
    enabled: true,
    apiUrl: "https://sourcify-api-monad.blockvision.org",
    browserUrl: "https://testnet.monadexplorer.com"
  },
  etherscan: {
    enabled: false,
  }
  // etherscan: {
  //   enabled: false,
  //   apiKey: {
  //     "optimism-sepolia": process.env.ETHERSCAN_API_KEY || "",
  //     "monad-testnet": process.env.MONAD_API_KEY || ""
  //   },
  //   customChains: [
  //     {
  //       network: "optimism-sepolia",
  //       chainId: 11155420,
  //       urls: {
  //         apiURL: "https://api-sepolia-optimistic.etherscan.io/api",
  //         browserURL: "https://sepolia-optimism.etherscan.io"
  //       }
  //     }
  // ]
  // }
};

export default config;