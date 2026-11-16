# UB

The UB token contract, and the LayerZero OFT wiring that gives it a balance on more than
one chain.

- `ub.sol` — the token. ERC-20 plus `ERC20Burnable`, name `Unibase`, symbol `UB`,
  18 decimals, the whole 10,000,000,000 minted once at deployment. There is no mint
  function left to call, so the supply cannot grow.
- `ub-oft/` — the LayerZero OFT setup: an Adapter on Ethereum, the OFT itself on the
  other chains.
- `remix/` — the Remix workspace the token was compiled and deployed from.

---

## Addresses

**Every address below was read from the chain on 2026-11-16**, not copied from a
deployment file. [Check them yourself](#check-them-yourself) rather than trusting this
page — it takes one command per address.

### Mainnet

| Chain | Address | Role |
| --- | --- | --- |
| Ethereum | [`0x6944E1DF6Bf5972305f9Ab25dF47ef10De01bcc8`](https://etherscan.io/token/0x6944E1DF6Bf5972305f9Ab25dF47ef10De01bcc8) | **The canonical ledger.** All 10,000,000,000 UB was issued here. |
| BNB Smart Chain | [`0x40b8129B786D766267A7a118cF8C07E31CDB6Fde`](https://bscscan.com/token/0x40b8129B786D766267A7a118cF8C07E31CDB6Fde) | Bridged mirror (OFT) |
| Base | [`0x51d9eEF6d49E2782f99D43F659d4f0cB493C28CC`](https://basescan.org/token/0x51d9eEF6d49E2782f99D43F659d4f0cB493C28CC) | Bridged mirror (OFT) |
| Ethereum | [`0xaFc34e2eD3037D5d52209Ed27A93d6df46C07C35`](https://etherscan.io/address/0xaFc34e2eD3037D5d52209Ed27A93d6df46C07C35) | Bridge adapter — locks and releases against the ledger |

All three report `Unibase` / `UB` / 18 decimals.

**The two mirrors will not show ten billion, and that is correct.** Bridging out of
Ethereum locks UB in the adapter and mints the same amount on the destination; bridging
back burns it and releases the original. A mirror's supply is whatever has been bridged
to that chain at the moment you look. On 2026-11-16 that was about 1.945B on BNB Smart
Chain and 4,428 on Base. Adding the three figures together double-counts what the
adapter is holding — **circulating supply is the Ethereum figure.**

Only Ethereum uses an Adapter. The other chains run the OFT itself, which mints and
burns, so there is no separate token for an adapter to wrap there.

### Testnet

Separate deployments. They share the name and symbol of the real token and **none of
them is worth anything.**

| Chain | Address | Supply |
| --- | --- | --- |
| Base Sepolia | [`0x27C8b63E5aCD5298035B984AC3ea3f39d522A700`](https://sepolia.basescan.org/token/0x27C8b63E5aCD5298035B984AC3ea3f39d522A700) | 10,000,000,000 |
| BNB Smart Chain testnet | [`0xC488F83A897E8AFF387D4124D46a63Dd33cb9c97`](https://testnet.bscscan.com/token/0xC488F83A897E8AFF387D4124D46a63Dd33cb9c97) | 4,000,000,000 |
| BNB Smart Chain testnet | [`0x7c5AC49563d7046906333AC2CA28E602327CFe1A`](https://testnet.bscscan.com/token/0x7c5AC49563d7046906333AC2CA28E602327CFe1A) | 4,000,000,000 |

The two on BNB testnet are two deployments with identical metadata — `Unibase` / `UB` /
18 / 4,000,000,000 each. Nothing on-chain tells them apart; Unibase DA's address table
calls the second one the DAO token.

---

## ⚠️ Do not take addresses from `ub-oft/deployments/`

Every artifact in that folder is a test or mock contract, in directories named
`-mainnet` because they were deployed on mainnet, not because the tokens are real.
Three of them answer `symbol()` with `UB` on a supply of 10. They are kept because
`hardhat-deploy` reads them, and labelled in
[`ub-oft/deployments/README.md`](ub-oft/deployments/README.md).

Counting what was verified on 2026-11-16: **ten** contracts across these chains answer
`symbol()` with `UB`. Three are the production tokens above. Three are testnets. The
remaining four are mocks and test deployments on mainnet — and one of those,
`0x1B600603BC1629CC14963A764382bB5ebBDe5C02` on BNB Smart Chain, also answers `name()`
with `Unibase`, which makes it indistinguishable from the real token by metadata alone.

**Four of those addresses were written down in this repository's own files** — three in
`deployments/`, one as the example in `ub-oft/README.md`. That is the reason this
section exists.

---

## Check them yourself

Nothing here needs to be believed. Any ERC-20 will tell you what it is:

```bash
# symbol() — expect 0x…5542, which is "UB"
curl -s -X POST https://ethereum-rpc.publicnode.com \
  -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","id":1,"method":"eth_call","params":[{
        "to":"0x6944E1DF6Bf5972305f9Ab25dF47ef10De01bcc8",
        "data":"0x95d89b41"},"latest"]}'
```

Swap `data` for `0x06fdde03` (`name`), `0x313ce567` (`decimals`) or `0x18160ddd`
(`totalSupply`), and the URL for `bsc-rpc.publicnode.com` or `base-rpc.publicnode.com`.
A block explorer answers the same question with fewer steps; the point is that the
answer comes from the chain and not from a file someone edited.

---

## Audit

The ERC-20 was audited by PeckShield. The report is published in full:
[PeckShield-Audit-Report-ERC20-Unibase-v1.0.pdf](https://github.com/unibaseio/Unibase-audit-report/blob/main/PeckShield-Audit-Report-ERC20-Unibase-v1.0.pdf).

## Security

Vulnerabilities go to **security@unibase.com**, which is also published under RFC 9116
at [unibase.com/.well-known/security.txt](https://unibase.com/.well-known/security.txt).

> **The contract source says otherwise, and that is not the address to use.** Both
> copies of the token source — `ub.sol` and `remix/contracts/ub.sol`, which are byte-for-byte
> identical — carry `@custom:security-contact security@openledger.xyz` in their NatSpec.
> It is a leftover from the template the contract was written from.
>
> Neither file is edited, on purpose: the source is verified on block explorers, and
> changing even a comment changes the hash they matched against. The deployed bytecode
> cannot be changed either way. Reports go to **security@unibase.com**.
