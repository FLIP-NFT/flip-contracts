/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import {
  Contract,
  ContractFactory,
  ContractTransactionResponse,
  Interface,
} from "ethers";
import type { Signer, ContractDeployTransaction, ContractRunner } from "ethers";
import type { NonPayableOverrides } from "../../../common";
import type { Trait, TraitInterface } from "../../../src/examples/Trait";

const _abi = [
  {
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    name: "tokenSeed",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
] as const;

const _bytecode =
  "0x60806040523461002057610011610789565b60405160da6108c3823960da90f35b600080fd5b634e487b7160e01b600052604160045260246000fd5b90601f01601f191681019081106001600160401b0382111761005c57604052565b610025565b9061007561006e60405190565b928361003b565b565b6001600160401b03811161005c5760200290565b61009761009c91610077565b610061565b90565b6001600160401b03811161005c57602090601f01601f19160190565b906100c86100978361009f565b918252565b6100d760076100bb565b660233030303030360cc1b602082015290565b61009c6100cd565b6100fc60076100bb565b6611a3232323232360c91b602082015290565b61009c6100f2565b61012160076100bb565b660234646303030360cc1b602082015290565b61009c610117565b61014660076100bb565b660233030464630360cc1b602082015290565b61009c61013c565b61016b60076100bb565b661198181818232360c91b602082015290565b61009c610161565b61019060076100bb565b660234646464630360cc1b602082015290565b61009c610186565b6101b560076100bb565b6611a3231818232360c91b602082015290565b61009c6101ab565b6101da60076100bb565b661198182323232360c91b602082015290565b61009c6101d0565b6101ff60076100bb565b660234646413530360cc1b602082015290565b61009c6101f5565b61022460076100bb565b660233830303038360cc1b602082015290565b61009c61021a565b61024960076100bb565b660233030383030360cc1b602082015290565b61009c61023f565b61026e60076100bb565b660233830303030360cc1b602082015290565b61009c610264565b61029360076100bb565b660233830383030360cc1b602082015290565b61009c610289565b6102b860076100bb565b660233030383038360cc1b602082015290565b61009c6102ae565b6102dd60076100bb565b660234330433043360cc1b602082015290565b61009c6102d3565b61030260076100bb565b660233830383038360cc1b602082015290565b61009c6102f8565b634e487b7160e01b600052600060045260246000fd5b634e487b7160e01b600052602260045260246000fd5b9060016002830492168015610369575b602083101461036457565b610333565b91607f1691610359565b9061038690600019906020036008021c90565b8154169055565b61009c61009c61009c9290565b91906103ab61009c6103c39361038d565b90835460001960089290920291821b191691901b1790565b9055565b6100759160009161039a565b8181106103de575050565b806103ec60006001936103c7565b016103d3565b9060009161041d61040882600052602060002090565b928354600019600883021c1916906002021790565b905555565b919290602082101561048757601f8411600114610451576103c3929350600019600883021c1916906002021790565b509061048261007593600161047961046e85600052602060002090565b92601f602091010490565b820191016103d3565b6103f2565b506104c7829361049e600194600052602060002090565b6104c06020601f860104820192601f8616806104cf575b50601f602091010490565b01906103d3565b600202179055565b6104db90888603610373565b386104b5565b92909168010000000000000000821161005c576020111561053a57602081101561051b576103c391600019600883021c1916906002021790565b60019160ff191661053184600052602060002090565b55600202019055565b60019150600202019055565b90815461055281610349565b9081831161057b575b818310610569575b50505050565b61057293610422565b38808080610563565b610587838383876104e1565b61055b565b600061007591610546565b906000036105a8576100759061058c565b61031d565b8181106105b8575050565b806105c66000600193610597565b016105ad565b9190918282106105db57505050565b6100759291906105ea565b9190565b91820191016105ad565b9068010000000000000000811161005c57610075916010906105cc565b9190601f811161062057505050565b61063261007593600052602060002090565b906020601f840181900483019310610652575b6020601f909101046104c0565b9091508190610645565b90610665815190565b906001600160401b03821161005c57610688826106828554610349565b85610611565b602090601f83116001146106c3576103c39291600091836106b8575b5050600019600883021c1916906002021790565b0151905038806106a4565b601f198316916106d885600052602060002090565b9260005b818110610716575091600293918560019694106106fd575b50505002019055565b01516000196008601f8516021c191690553880806106f4565b919360206001819287870151815501950192016106dc565b906100759161065c565b61074b6105e660109361009c85856105f4565b6000915b83831061075c5750505050565b600160208261077361076d84955190565b8661072e565b0192019201919061074f565b9061007591610738565b610075610796601061008b565b6107a56107a16100ea565b8252565b6107b76107b061010f565b6020830152565b6107c96107c2610134565b6040830152565b6107db6107d4610159565b6060830152565b6107ed6107e661017e565b6080830152565b6107ff6107f86101a3565b60a0830152565b61081161080a6101c8565b60c0830152565b61082361081c6101ed565b60e0830152565b61083661082e610212565b610100830152565b610849610841610237565b610120830152565b61085c61085461025c565b610140830152565b61086f610867610281565b610160830152565b61088261087a6102a6565b610180830152565b61089561088d6102cb565b6101a0830152565b6108a86108a06102f0565b6101c0830152565b6108bb6108b3610315565b6101e0830152565b600161077f56fe60806040526004361015601157600080fd5b635f51683660003560e01c14607b575b600080fd5b90602082820312602157503590565b90565b6035603560359290565b90604a906038565b600052602052604060002090565b6035916008021c81565b90603591546058565b60006077603592826042565b6062565b3460215760a06090608c3660046026565b606b565b6040519182918290815260200190565b0390f3fea264697066735822122065cff6008b9c37e52a9a21635939cded4bc195cb64007cb17fb66fe63cf2a1b564736f6c634300081c0033";

type TraitConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: TraitConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class Trait__factory extends ContractFactory {
  constructor(...args: TraitConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override getDeployTransaction(
    overrides?: NonPayableOverrides & { from?: string }
  ): Promise<ContractDeployTransaction> {
    return super.getDeployTransaction(overrides || {});
  }
  override deploy(overrides?: NonPayableOverrides & { from?: string }) {
    return super.deploy(overrides || {}) as Promise<
      Trait & {
        deploymentTransaction(): ContractTransactionResponse;
      }
    >;
  }
  override connect(runner: ContractRunner | null): Trait__factory {
    return super.connect(runner) as Trait__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): TraitInterface {
    return new Interface(_abi) as TraitInterface;
  }
  static connect(address: string, runner?: ContractRunner | null): Trait {
    return new Contract(address, _abi, runner) as unknown as Trait;
  }
}
