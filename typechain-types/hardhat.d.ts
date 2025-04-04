/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { ethers } from "ethers";
import {
  DeployContractOptions,
  FactoryOptions,
  HardhatEthersHelpers as HardhatEthersHelpersBase,
} from "@nomicfoundation/hardhat-ethers/types";

import * as Contracts from ".";

declare module "hardhat/types/runtime" {
  interface HardhatEthersHelpers extends HardhatEthersHelpersBase {
    getContractFactory(
      name: "Ownable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Ownable__factory>;
    getContractFactory(
      name: "IERC1155Errors",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC1155Errors__factory>;
    getContractFactory(
      name: "IERC20Errors",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC20Errors__factory>;
    getContractFactory(
      name: "IERC721Errors",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721Errors__factory>;
    getContractFactory(
      name: "ERC721",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ERC721__factory>;
    getContractFactory(
      name: "ERC721Enumerable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ERC721Enumerable__factory>;
    getContractFactory(
      name: "IERC721Enumerable",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721Enumerable__factory>;
    getContractFactory(
      name: "IERC721Metadata",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721Metadata__factory>;
    getContractFactory(
      name: "IERC721",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721__factory>;
    getContractFactory(
      name: "IERC721Receiver",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC721Receiver__factory>;
    getContractFactory(
      name: "ERC721Holder",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ERC721Holder__factory>;
    getContractFactory(
      name: "ERC165",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ERC165__factory>;
    getContractFactory(
      name: "IERC165",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IERC165__factory>;
    getContractFactory(
      name: "Math",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Math__factory>;
    getContractFactory(
      name: "Strings",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Strings__factory>;
    getContractFactory(
      name: "BaseNFT",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.BaseNFT__factory>;
    getContractFactory(
      name: "Factory",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Factory__factory>;
    getContractFactory(
      name: "FeeVault",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.FeeVault__factory>;
    getContractFactory(
      name: "Price",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Price__factory>;
    getContractFactory(
      name: "Registry",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Registry__factory>;
    getContractFactory(
      name: "Storage",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Storage__factory>;
    getContractFactory(
      name: "Trade",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Trade__factory>;
    getContractFactory(
      name: "FlipNFT",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.FlipNFT__factory>;
    getContractFactory(
      name: "Trait",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.Trait__factory>;
    getContractFactory(
      name: "IBaseNFT",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IBaseNFT__factory>;
    getContractFactory(
      name: "IPrice",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IPrice__factory>;
    getContractFactory(
      name: "IStorage",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.IStorage__factory>;
    getContractFactory(
      name: "ITrade",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.ITrade__factory>;
    getContractFactory(
      name: "FlipPeriphery",
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<Contracts.FlipPeriphery__factory>;

    getContractAt(
      name: "Ownable",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.Ownable>;
    getContractAt(
      name: "IERC1155Errors",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC1155Errors>;
    getContractAt(
      name: "IERC20Errors",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC20Errors>;
    getContractAt(
      name: "IERC721Errors",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC721Errors>;
    getContractAt(
      name: "ERC721",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.ERC721>;
    getContractAt(
      name: "ERC721Enumerable",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.ERC721Enumerable>;
    getContractAt(
      name: "IERC721Enumerable",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC721Enumerable>;
    getContractAt(
      name: "IERC721Metadata",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC721Metadata>;
    getContractAt(
      name: "IERC721",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC721>;
    getContractAt(
      name: "IERC721Receiver",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC721Receiver>;
    getContractAt(
      name: "ERC721Holder",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.ERC721Holder>;
    getContractAt(
      name: "ERC165",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.ERC165>;
    getContractAt(
      name: "IERC165",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IERC165>;
    getContractAt(
      name: "Math",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.Math>;
    getContractAt(
      name: "Strings",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.Strings>;
    getContractAt(
      name: "BaseNFT",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.BaseNFT>;
    getContractAt(
      name: "Factory",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.Factory>;
    getContractAt(
      name: "FeeVault",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.FeeVault>;
    getContractAt(
      name: "Price",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.Price>;
    getContractAt(
      name: "Registry",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.Registry>;
    getContractAt(
      name: "Storage",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.Storage>;
    getContractAt(
      name: "Trade",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.Trade>;
    getContractAt(
      name: "FlipNFT",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.FlipNFT>;
    getContractAt(
      name: "Trait",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.Trait>;
    getContractAt(
      name: "IBaseNFT",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IBaseNFT>;
    getContractAt(
      name: "IPrice",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IPrice>;
    getContractAt(
      name: "IStorage",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.IStorage>;
    getContractAt(
      name: "ITrade",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.ITrade>;
    getContractAt(
      name: "FlipPeriphery",
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<Contracts.FlipPeriphery>;

    deployContract(
      name: "Ownable",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Ownable>;
    deployContract(
      name: "IERC1155Errors",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC1155Errors>;
    deployContract(
      name: "IERC20Errors",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC20Errors>;
    deployContract(
      name: "IERC721Errors",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC721Errors>;
    deployContract(
      name: "ERC721",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.ERC721>;
    deployContract(
      name: "ERC721Enumerable",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.ERC721Enumerable>;
    deployContract(
      name: "IERC721Enumerable",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC721Enumerable>;
    deployContract(
      name: "IERC721Metadata",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC721Metadata>;
    deployContract(
      name: "IERC721",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC721>;
    deployContract(
      name: "IERC721Receiver",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC721Receiver>;
    deployContract(
      name: "ERC721Holder",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.ERC721Holder>;
    deployContract(
      name: "ERC165",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.ERC165>;
    deployContract(
      name: "IERC165",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC165>;
    deployContract(
      name: "Math",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Math>;
    deployContract(
      name: "Strings",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Strings>;
    deployContract(
      name: "BaseNFT",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.BaseNFT>;
    deployContract(
      name: "Factory",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Factory>;
    deployContract(
      name: "FeeVault",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.FeeVault>;
    deployContract(
      name: "Price",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Price>;
    deployContract(
      name: "Registry",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Registry>;
    deployContract(
      name: "Storage",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Storage>;
    deployContract(
      name: "Trade",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Trade>;
    deployContract(
      name: "FlipNFT",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.FlipNFT>;
    deployContract(
      name: "Trait",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Trait>;
    deployContract(
      name: "IBaseNFT",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IBaseNFT>;
    deployContract(
      name: "IPrice",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IPrice>;
    deployContract(
      name: "IStorage",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IStorage>;
    deployContract(
      name: "ITrade",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.ITrade>;
    deployContract(
      name: "FlipPeriphery",
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.FlipPeriphery>;

    deployContract(
      name: "Ownable",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Ownable>;
    deployContract(
      name: "IERC1155Errors",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC1155Errors>;
    deployContract(
      name: "IERC20Errors",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC20Errors>;
    deployContract(
      name: "IERC721Errors",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC721Errors>;
    deployContract(
      name: "ERC721",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.ERC721>;
    deployContract(
      name: "ERC721Enumerable",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.ERC721Enumerable>;
    deployContract(
      name: "IERC721Enumerable",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC721Enumerable>;
    deployContract(
      name: "IERC721Metadata",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC721Metadata>;
    deployContract(
      name: "IERC721",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC721>;
    deployContract(
      name: "IERC721Receiver",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC721Receiver>;
    deployContract(
      name: "ERC721Holder",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.ERC721Holder>;
    deployContract(
      name: "ERC165",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.ERC165>;
    deployContract(
      name: "IERC165",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IERC165>;
    deployContract(
      name: "Math",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Math>;
    deployContract(
      name: "Strings",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Strings>;
    deployContract(
      name: "BaseNFT",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.BaseNFT>;
    deployContract(
      name: "Factory",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Factory>;
    deployContract(
      name: "FeeVault",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.FeeVault>;
    deployContract(
      name: "Price",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Price>;
    deployContract(
      name: "Registry",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Registry>;
    deployContract(
      name: "Storage",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Storage>;
    deployContract(
      name: "Trade",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Trade>;
    deployContract(
      name: "FlipNFT",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.FlipNFT>;
    deployContract(
      name: "Trait",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.Trait>;
    deployContract(
      name: "IBaseNFT",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IBaseNFT>;
    deployContract(
      name: "IPrice",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IPrice>;
    deployContract(
      name: "IStorage",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.IStorage>;
    deployContract(
      name: "ITrade",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.ITrade>;
    deployContract(
      name: "FlipPeriphery",
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<Contracts.FlipPeriphery>;

    // default types
    getContractFactory(
      name: string,
      signerOrOptions?: ethers.Signer | FactoryOptions
    ): Promise<ethers.ContractFactory>;
    getContractFactory(
      abi: any[],
      bytecode: ethers.BytesLike,
      signer?: ethers.Signer
    ): Promise<ethers.ContractFactory>;
    getContractAt(
      nameOrAbi: string | any[],
      address: string | ethers.Addressable,
      signer?: ethers.Signer
    ): Promise<ethers.Contract>;
    deployContract(
      name: string,
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<ethers.Contract>;
    deployContract(
      name: string,
      args: any[],
      signerOrOptions?: ethers.Signer | DeployContractOptions
    ): Promise<ethers.Contract>;
  }
}
