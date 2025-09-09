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
   networks: {
       'bsc-mainnet': {
           eid: EndpointId.BSC_V2_MAINNET,
           url: process.env.RPC_URL_BSC_MAINNET || 'https://bsc-rpc.publicnode.com',
           accounts,
           oftAdapter: {
               tokenAddress: '0x1B600603BC1629CC14963A764382bB5ebBDe5C02', // Set the token address for the OFT adapter
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
