# Architecture

This document describes the choices made on an implementation level to build towards the security token architecture of the future.

## Role Based Access Control (RBAC)

One of the bigger open ended problems of ERC-1400 is the permission system.
As a big STO platform, you do not want your KYC administration to have the same permissions as an issuer.
Risk management requires a strong implementation of roles: a way to prevent "leaking" of permissions.
Hence, we decided to implement the [RBAC pattern](https://docs.openzeppelin.org/docs/learn-about-access-control.html#role-based-access-control-rolessol) by Open-Zeppelin.
This pattern is widely applied, and audited for correctness.

The current architecture divides roles like this:

- `RegulatorService`
  - Role: `Regulator`: able to do force transfers and redemptions/burning
- `StoreKYC`
  - Role: `KYCAdmin`: able to change KYC data
- `AddressIdentities`
  - Role: `IdentityAssigner`: able to change address identities
- `SecurityToken`
  - `TransferChecker`
    - Role: `RegServAppointer`: able to change the regulator service for a given contract.
  - `TokenIssuance`
    - Role: `Issuer`: able to issue tokens to an address (checked by regulator, capped)

Note that roles are contract-bound, meaning that each token can have its own issuers,
 and different accounts may be used per token by regulators, to lower the effect of a key compromise.

To use roles professionally, instead of relying on the default assignment of every role to the address deploying the contract, you would follow the following procedure:

1. Deploy contracts, roles are assigned to contract deployer
2. For every type of role, assign an address (or multiple) that will be kept cold, away from the system, 
 to make future role changes if necessary. This will be the back-up for your system.
3. As contract creator, start assigning roles to trusted accounts. Assign roles to issuers, regulators, etc.
  - You may want to assign some of the roles to the same address.
   e.g. the KYC is managed by the same system that assigns addresses to investors.
4. You can start on-boarding customers. The KYC admin and identity admin can introduce a new user.
 The the issuer can issue them funds after that (given that the user KYC data conforms to the issue rule).
5. Roles may be switched, anyone with a specific role, can assign new addresses to have the same type of role.
  - In the future you may want to consider either tracking role assignment (there are already events for this!),
   and/or put limits on how many addresses can hold a given role.


<!-- ### Multi-sigs

We are aware of multi-sig accounts and fully support the use of them. A list of multi-sigs can be found [here](https://medium.com/@yenthanh/list-of-multisig-wallet-smart-contracts-on-ethereum-3824d528b95e). We think the Consensys multi-sig is a good choice.

However, the contract system is fully independent from the multi-sig.
You register the address corresponding to the multi-sig to the necessary roles in the system, no need for special contract functions, it works the same for any type of address.
Just read the multi-sig documentation well, and experiment with it, to not make mistakes.
The flexibility of allowing any type of address to be used,
 means we can have fast-paced development and testing with regular accounts, and use multi-sigs for testing of release candidates and in production. -->

## Force-transfers

Force-transfers are a re-occurring theme in security tokens. Not all standards support them explicitly however.
From a legal point of view, it is important to be able to make changes when forced by a regulator.
Ideally (from an automation point of view), the regulator him/herself participates in the system, and is fully independent.
More likely, you register the responsible entities behind the token platform as regulators, and have them act when a regulator asks them to. 

To facilitate these force-transfers, we need to allow for arbitrary changes in a token. Very un-crypto like (anarchists point of view),
 but perfectly fine when you are A) very explicit about the possibility. And B) notify users when it happens.

Some minimal security token standards ignore this, and leave it up to the implementer (the standard does not prevent you from adding it).
Some other security standards go over-board by polluting the contract interface with extra functions, and duplicating functionality, or making it non-changeable.

The best way of doing force-transfers would be to notify users through Ethereum event-logs, which they can look and filter for independently.
Notifying the user of the possibility is more abstract: adding extra "force" functions to the contract is not much better than just telling off-chain when on-boarding them.

One could opt to integrate the ERC-1644 of polymath, but this results in:
- Lack of ability to upgrade force-transfer functionality
- Duplication of regulator role: the regulator role may allow different changes in the regulator contract (e.g. freezing transfer functionality),
 and one would not want to keep track of the role between contracts (the token contract being the force-transfer entry point). 

The current approach is to use a minimal but explicit force-transfer event, and set clear expectations off-chain.
Considering regulator-initiated actions as force-transfers, and marking them as such, is a clean approach (does not require extra functions in token),
 and the encapsulation of this logic within the regulator service makes updates of it possible. 

More technical details can be found in the SecurityToken documentation, and the STO research doc can be inquired for comparison between standards/platforms.


## Transfer-from

Transfer-from is what ERC-20 defined.
Just normal transfers are only as powerful as any other ledger system (unless wrapped in a smartcontract...),
 but with a basic approval system, accounts can be coupled closely to applications.
This coupling is particularly interesting in the smart-contract space, since contract source code can be verified,
 and does not change. Hence, you could trust an application more easily, and use your wallet funds with ease within this application.

Decentralized exchanges benefited a lot from this, and so do other dApps that require some form of interop with an user account.

For similar reasons, people have been looking to improve the transfer-from flow, as it is so powerful.
The concern however, is to not enable exploits, or put to much of a burden on contracts that want to use the interface.
The approve<->transferFrom flow is well standardized, supported by ERC-20, and makes sense to adopt.
With the addition of the extra-data argument (see future-plans discussion),
 we need a counterpart to `transferFrom` that allows for this same data that the renewed `transfer` allows.
This seems to be understood in the core ERC-1594 standard, that includes such transferFrom function: `transferFromWithData(...)`   


## Regulator Service contract per Token

Sharing a regulator service between tokens is tricky: all storage needs to be either externalized or put in a mapping,
 even the smallest non-sensible things.
A slim service model is still very useful; upgrading is easy.
A per-token service looks like a good trade-off:
 - Tokens can have fully independent rule-sets if necessary
 - Upgrades can be phased out: upgrading all security tokens at once through a shared registry model sounds great,
   but the possible platform-wide downtime after a failure is something to avoid.
 - The regulator service can be aware of the exact token being used.
   There is no over-head in passing token references, or generalizing too much.
 - The transition to a shared model is open: if we decide to move towards a shared regulator service,
   we replace the regulator service with a proxy, pointing to the shared contract.
 - The regulator service can be made aware of transfers easily, to track extra data outside of the token. This enables additional transfer requirements to be fully upgradeable:
    e.g. a holder limit of 2000 investors can be changed to only apply to a subset of investors, without having to re-deploy the security token itself.

## Shared KYC and Identities

User-data is something that we do not want to replicate between tokens.
To achieve this, we track KYC data in a separate contract, keyed by investor ID.
Investor IDs are not addresses, we keep them separate to be able to add additional user-data stores, 
 if necessary in the future. And since multiple addresses can be used by an investor (see discussion on tranches),
 we need an "identity" mapping from ETH address to investor ID.

## Build on ERC-20, not simulate

ERC-20 is a solid base, preferable over simulating a non-standard balance system that has to be adopted by major other players before being useful.
By extending the core of ERC-20 with security-token functionality, we ensure compatibility, 
 and preserve important semantics: a "balance" of an address represents exactly that, not a mixture of different tranches with different taints.
Such designs should be build as a layer on top of the ERC-20: a good UX can be achieved just as well, if not better,
 by making tranches more coherent to the standard, and easy to look up with 3rd party tools.

### Tranches from the perspective of the regulator service

It is important to note that addresses are not a lesser of tranches: addresses can be tracked just as well.
We make this a task for the regulator service, rather than the token, to be able to upgrade this functionality,
 and not clutter the token with costly overhead on the management of tranches.
