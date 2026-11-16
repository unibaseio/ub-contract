## Deploy UB Token

### Use REMIX

1. Open https://remix.ethereum.org/
2. Create a new workspace
3. Create a blank project
4. Upload ./remix folder
5. Compile and Deploy

## Deploy UB OFT

1. cd ./ub-oft
2. yarn install
3. update `tokenAddress`

   ```
> **Two notes on the snippet below.**
>
> The `tokenAddress` is a placeholder. It used to be a real address,
> `0x1B600603BC1629CC14963A764382bB5ebBDe5C02`, which on BNB Smart Chain answers
> `name()` with **"Unibase"** and `symbol()` with **"UB"** — the same strings as the
> real token — while holding a supply of 10,000. An example address that is
> indistinguishable from the thing it is an example of is how a wrong address ends up
> in production. Verified on-chain 2026-11-16.
>
> The snippet also puts an `oftAdapter` under `bsc-mainnet`, which the production
> deployment does not do: only Ethereum uses an Adapter (lock and release against the
> canonical ledger). BNB Smart Chain and Base run the OFT itself (mint and burn), so
> there is no token for an adapter to wrap there. Read this as LayerZero's generic
> example, not as how UB is wired.

   networks: {
       'bsc-mainnet': {
           eid: EndpointId.BSC_V2_MAINNET,
           url: process.env.RPC_URL_BSC_MAINNET || 'https://bsc-rpc.publicnode.com',
           accounts,
           oftAdapter: {
               tokenAddress: '0xYOUR_TOKEN_ADDRESS', // the ERC-20 the adapter wraps
           },
       },
       'base-mainnet': {
           eid: EndpointId.BASE_V2_MAINNET,
           url: process.env.RPC_URL_BASE_MAINNET || 'https://base-rpc.publicnode.com',
           accounts,
       }
   }
   ```

4. npx hardhat lz:deploy

5. npx hardhat lz:oapp:wire --oapp-config layerzero.config.ts

## Test token transfer

```js
npx hardhat lz:oft:send --src-eid 30102 --dst-eid 30184 --amount 3 --to 0x1234567890123456789012345678901234567890
```
