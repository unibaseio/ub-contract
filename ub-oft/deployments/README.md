# What is in this folder

**Nothing here is the production UB deployment.** Every artifact below was checked
against the chain it names on 2026-11-16 (`eth_call` for `name`, `symbol`, `decimals`,
`totalSupply`), and all of them are test or mock contracts. The directory names say
`-mainnet` because these test contracts were deployed on mainnet, not because the
tokens are real.

They are kept rather than deleted: `hardhat-deploy` reads this folder to decide what is
already deployed, and the records are an accurate history of what was run. They are
labelled instead.

| File | Address | On-chain identity | |
| --- | --- | --- | --- |
| `eth-mainnet/UBOFTAdapter.json` | `0xDE6eb7eC…488765` | adapter (no ERC-20 interface) | test adapter — wraps the UBT test token, not UB |
| `bsc-mainnet/UBOFT.json` | `0x073A0FaB…69B8a3` | **"Unibase Testnet" / UBT** / 1,000,000,000 | test token |
| `bsc-mainnet/UBERC20Mock.json` | `0x9aC71CDA…2f824b` | **"Unibase Mock" / UB** / supply 10 | mock, and it carries the symbol `UB` |
| `bsc-mainnet/UBOFTAdapter.json` | `0x9C172C5c…3dd5Cc` | adapter (no ERC-20 interface) | test adapter |
| `base-mainnet/UBOFT.json` | `0x88B77551…ACdD2b` | **"UBOFT" / UB** / supply 10 | test token, symbol `UB` |
| `base-mainnet/UBERC20Mock.json` | `0xd7E5AE94…752cb2` | **"Unibase Mock" / UB** / supply 10 | mock, symbol `UB` |

A fourth lookalike was found outside this folder, in `ub-oft/README.md`: the example
`tokenAddress` was `0x1B600603BC1629CC14963A764382bB5ebBDe5C02`, which on BNB Smart
Chain answers `name()` with **"Unibase"** and `symbol()` with **"UB"** — both strings
identical to the real token — on a supply of 10,000. It has been replaced with a
placeholder.

Three of the records above answer `symbol()` with **`UB`** and hold a supply of 10. They are
indistinguishable from the real token by symbol alone, which is exactly how an address
gets copied out of a repository and into the wrong place. Do not quote any address from
this folder as a UB contract address.

## The real ones

Verified the same way, on the same day:

| Chain | Address | | |
| --- | --- | --- | --- |
| Ethereum | `0x6944E1DF6Bf5972305f9Ab25dF47ef10De01bcc8` | Unibase / UB / 18 | 10,000,000,000 — the canonical ledger |
| BNB Smart Chain | `0x40b8129B786D766267A7a118cF8C07E31CDB6Fde` | Unibase / UB / 18 | bridged mirror |
| Base | `0x51d9eEF6d49E2782f99D43F659d4f0cB493C28CC` | Unibase / UB / 18 | bridged mirror |

The two mirrors hold whatever has been bridged out of Ethereum at the time you look, so
their supply is smaller than ten billion and changes. Adding the three figures together
double-counts what the adapter is holding on Ethereum; circulating supply is the
Ethereum figure.

The production bridge adapter on Ethereum is `0xaFc34e2eD3037D5d52209Ed27A93d6df46C07C35`,
which is **not** the adapter recorded in `eth-mainnet/` above.
