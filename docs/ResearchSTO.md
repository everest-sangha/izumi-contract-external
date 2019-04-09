# STO Research

STO research document, full ecosystem comparison, by write-up by Peter from EVG.

## Existing work

### Existing security token types

[ST 20](https://github.com/PolymathNetwork/polymath-core) ([Polymath](https://polymath.network/)) (no ERC/EIP): polymath original security token interface. Simple `verifyTransfer`, but modular approach to implement this single function.

[ERC-1400](https://github.com/ethereum/EIPs/issues/1411) ([Polymath](https://polymath.network/) and [Fabian Vogelsteller](https://github.com/frozeman), moved to 1411) (ERC, open draft): "Security Token Standard"
Builds on: ERC-1594, ERC-1644, ERC-1643. Enables controller-based partioned force-transfers.

[ERC-1594](https://github.com/ethereum/EIPs/issues/1594) ([Polymath](https://polymath.network/) and [Fabian Vogelsteller](https://github.com/frozeman)) (ERC, open draft): "core security token standard".
- `transfer[From]WithData`: initiate a transfer (success only if canTransfer allows it)
- `isIssuable`: if initial issuance phase is active
- `issue`: create new supply
- `redeem[From]`: burn tokens from a given account, used to decrease supply.
- `canTransfer[From]`: check if user is allowed to make a given transfer.
- more complete Event system for issuance than others, explicit requirements.

[ERC-1410](https://github.com/ethereum/eips/issues/1410) ([Polymath](https://polymath.network/) and [Fabian Vogelsteller](https://github.com/frozeman) (ERC, open draft): "Partially Fungible Token Standard". Partitions token balances per-user.

[ERC-1404](https://github.com/ethereum/EIPs/issues/1404) ([TokenSoft](https://www.tokensoft.io/)) (ERC, open draft): "Simple Restricted Token Standard" (`detectTransferRestriction` + `messageForTransferRestriction`). Not affiliated to ERC-1400, similarities with ERC-902, separated messages from validity checks. Mentions ERC-1444, which should have been off-chain.

[ERC-1462](http://eips.ethereum.org/EIPS/eip-1462) ([Atlant](https://atlant.io)) (EIP, draft): "Base Security Token" (`check<Mint,Burn,Transfer,TranferFrom>Allowed` + `<attach/lookup>Document`)

[ERC-902](http://eips.ethereum.org/EIPS/eip-902) ([Finhaven](https://www.finhaven.com/)) (EIP, draft): "Token validation": very general `check`, with status codes from ERC 1066 (same author).

[S3](https://github.com/OpenFinanceIO/smart-securities-standard) ([OpenFinance.io](https://openfinance.io/)) (no ERC/EIP): Token with off-chain transfer approval. ERC-20 compliant using a "TokenFront", but transfers will be stuck until a validator provides an error code (0 for approval of transfer). Implements complete separation of token-balances from tokens, into a unified `CapTables` contract. (possible log-bloom inefficiency, but makes big token-logic upgrades easy).

[R-token](https://github.com/harborhq/r-token) ([Harbor](https://harbor.com/)) (no ERC/EIP): extract regulatory logic into a Regulator-Service contract. A service registry directs to the service being used.
- Regulated Token (R-token): ERC-20 token compliant
- Regulator Service: handles verification of `transfer`/`transferFrom`, through a `check` function.
- Service Registry: routes R-token calls to regulator-service calls
- Very similar to ERC-902. Just wrapped in an service pattern, with non-standard status-codes from the `check`.

[DS protocol](https://securitize.sfo2.digitaloceanspaces.com/whitepapers/DS-Protocolv1.0.pdf) ([Securitize](https://www.securitize.io/)) (no ERC/EIP): "Digital Securities protocol". Not quite the same as the others, more like a commercialized protocol draft. 
- ERC-20 token compliant
- Compliance Service: handles `transfer`/`transferFrom`
- "DS Apps" can be attached to a token for additional capabilities (votes, dividends).
- Trust service: enable other services, DS Apps, and 3rd parties to use features.
- Communication service: pushes events to investors.
- Registry service: user registry. Track investors by ID, instead of address.


[Atomic-DSS](https://github.com/AtomicCapital/atomic-dss) ([Atomic Capital](https://atomiccapital.io/)) (no ERC/EIP): "Digital Security Standard". Regulator service (`verify(transfer) -> code` and `restrictionMessage(code) -> string`), attached to a simple but modified (very direct `onlyOwner` force transfers, minting and burning) ERC-20, with an additional `notRestricted(transfer)` modifier on `transfer` and `transferFrom`, and supply controlled by the contract owner.

### Existing token types

[ERC-20](https://eips.ethereum.org/EIPS/eip-20) (Community, [Fabian Vogelsteller](https://github.com/frozeman), [Vitalik Buterin](https://github.com/vbuterin)) (EIP, final): Token Standard
[ERC-721](http://eips.ethereum.org/EIPS/eip-721) ([Community](http://erc721.org/)) (EIP, final): Non-Fungible Token Standard
[ERC-777](https://eips.ethereum.org/EIPS/eip-777) (EIP, draft): A New Advanced Token Standard. Backwards compatible with ERC-20. Solution to reduce `approve/transferFrom` to a single call. Token holders can assign operators for their account. And transfer can contain extra data.
[ERC-223](https://github.com/ethereum/EIPs/issues/223) (ERC, open draft): an  effort from long ago to avoid transfers to contracts that cannot handle them, making the transferred value inaccessible. Instead, contracts should implement a receiver method.
[ERC-667](https://github.com/ethereum/EIPs/issues/677) (ERC, open draft): `transferAndCall` for sender contract, `onTokenTransfer` for receiver contract.
[ERC-865](https://github.com/ethereum/EIPs/issues/865) (ERC, open draft) and [ERC-965](https://github.com/ethereum/EIPs/issues/965) (ERC, open draft): `transferPreSigned` and `sendByCheque`. Proposals to enable transfers by third parties when signed by the user. Could have been implemented with normal `transferWithData` too, but standardizes the Events emitted on such a transfer.
[ERC-1155](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1155.md) ([Enjin](https://enjin.com)) (EIP, last call): Multi Token Standard.
[ERC-1644](https://github.com/ethereum/EIPs/issues/1644) ([Polymath](https://polymath.network/) and [Fabian Vogelsteller](https://github.com/frozeman)) (ERC, open draft): Controller Token Operation Standard
[ERC-1724](https://github.com/ethereum/EIPs/issues/1724) ([Aztec](https://www.aztecprotocol.com/)) (ERC, open draft): Confidential Token standard. UTXO-like model, with ZK-proofs to proof validity of "join-split" transactions. Value is transferred in the form of notes; anonymous but public owners, and secret values. Note the differences in method signatures to ERC-20.
[ERC 827](https://github.com/ethereum/eips/issues/827) (ERC, open draft): `transferAndCall`, `transferFromAndCall`, `approveAndCall`: highlights the power of an extra data field in transfers, to enbale users to make direct single-call actions (instead of doing it in two steps: approve and transfer). 
[ERC 884](https://eips.ethereum.org/EIPS/eip-884) (EIP, draft): Delaware General Corporations Law (DGCL) compatible share token. This standard focuses on investor identities coupled to share tokens, and very verbose management. It reads more like a legal document, than a token interface. It fits some of the requirements for security tokens, but is difficult to extend, and too verbose and restrictive as an interface to standardize for wider usage.

### Existing utility types

[ERC-1066](https://eips.ethereum.org/EIPS/eip-1066) ([Finhaven](https://www.finhaven.com/)) (EIP, last call, near-final): Status Codes (byte sized codes)
[ERC-1444](https://eips.ethereum.org/EIPS/eip-1444) (EIP, draft): Localized Messaging with Signal-to-Text
[ERC-838](https://github.com/ethereum/EIPs/issues/838) (ERC, open draft): Revert, throw and error handling discussion. Ideally we can trace reverts, define standard errors, and catch errors with parametrized data. It will take a while before it can be used however.
[ERC-1643](https://github.com/ethereum/EIPs/issues/1643) ([Polymath](https://polymath.network/) and [Fabian Vogelsteller](https://github.com/frozeman)) (ERC, open draft): Document Management Standard (`<set/get/remove>Document` + `getAllDocuments`)
[ERC-1644](https://github.com/ethereum/EIPs/issues/1644) ([Polymath](https://polymath.network/) and [Fabian Vogelsteller](https://github.com/frozeman)) (ERC, open draft): Controller Token Operation Standard. Force transfers for security tokens.


## Modularity

The different security token approaches have different levels of opinination:

1. Raw: just a `verify` function to hack into your ERC-20 transfer.
2. Minimal (but well defined): a `verify` function with clear expectations on in and outputs (status codes/reason).
3. Core: a minimal but complete approach to handle issuance, verified transfers, and token burning. With basic events.
4. Full: the common understanding of security tokens: issuance, verified transfers, token burning, force-transfers (with events)
5. Opinionated: integration of practices not specific to security tokens (such as upgrade patterns)
6. Extra: layers that extend the full definition in opinionated ways. E.g. use of tranches.
7. Platform-specific: design choices made to work with surrounding platform components, and services.

Although it is tempting to take on Platform-specific features, we believe that a flexible token interface can facilitate more innovation, and has better chances of being accepted as a standard.

On the contrary, the "raw" level does not further the ecosystem by much, it merely imposes an additional restriction on ERC-20 tokens.

The reasonable solution is to standardize on the "core" level: provide enough flexibility for innovation, but also specify a "security token" well enough to implement financial services around it.

With enough flexibility, the "full" level can be implemented with backwards compatibility, and may be standardized later, if the need arises.

Opinionated requirements in standards are not destructive, but could be avoided, and should be to allow for innovation.

And with enough modularity, the "extra" layer can be designed as an add-on, to be standardized separately.

Platform specific-features should be excluded from standardization, but are important to implementers for a coherent and maintainable platform.

## Analysis

How the existing solutions rank:

1) Raw: ERC-902 without ERC-1066
2) Minimal: ERC-902, ERC-1404
3) Core: ERC-1594, ERC-1462
4) Full: Atomic-DSS
5) Opinionated: R-token, ST-20
6) Extra: ERC-1410, ERC-1400
7) Platform-specific: S3, DS-protocol


### Raw, minimal

As a STO platform, specification is important to us. Having well documented standardized issuance and redemption interfaces and events increases interoperability with our platform, and enables larger adoption.

#### Candidates

ERC-902 is well designed, but the functionality is too minimal. We support the use of status-codes, and this standard draft is authored by the same people as ERC-1066. An interesting property is that tokens can share validation logic, since it is in a separate contract. The "`Validation`" events are something to avoid however: we are duplicating the ERC-20 events to just make status codes indexed in the event log. 

ERC-1404 is just poorly designed:
- It does not improve on ERC-20.
- No standard status codes.
    - Poor choice of making "0" = "allow". Allow by default is not a good security practice.
    - Bad decision for on-chain translation of status codes. The only reason of doing it on-chain is the failure to standardize codes well off-chain.

### Core

In this layer, there is nothing that we do not need. Token issuance, token redemption (burning), and verified transfers are the essential parts to standardize. And standardized events for each of these functionalities are welcome. The question is, will this be sufficient? As an interface, yes. As an implementation, no. Things like force transfers are important too, but not strictly necessary to standardize: they can just be a part of the normal interface, as a subset of the transfer verification system.


#### "`withData`"
At the same time, we cannot afford to get stuck because of limitations in a standard. To solve this, we like to see the flexibility of the extra data field included in the core security token standard.

However, we do understand that external calls like ERC-827 are not a great idea (e.g. you accidentally enable a re-entrancy attack). Hence, we prefer just leaving it as a data field, and not forcing anyone to make any sort of call. Just leave the possibility open, may the need arise.

We are more interested in the type of data provided to transfer functions like those in ERC-1724: supplying things like proof-data to enable more advanced types of transfers. Having user-supplied data available during transfer verification enables future off-chain data solutions.

A few examples of transfers using (partially) off-chain data:

- data = a (cryptographically) signed cheque, enabling them to transfer an amount from someones account to their own.
- data = a Merkle-proof: the contract just needs to know the Merkle-root (32 bytes) of a full issuance (e.g. 10K investors), and users can issue their allotted value to themselves by providing an inclusion proof (their leaf-node + a Merkle-branch, enabling to contract to verify inclusion with just the root)
- data = a proof of certain data existing off-chain, enabling the verification code to handle special cases.
- data = an inclusion proof of KYC data, and the rule allowing the transfer; when implemented symmetrically, the data and rule may be salted and hashed, and a transfer can be verified, without revealing any of the KYC data.

#### Candidates

Both ERC-1594, ERC-1462 look promising. ERC-1462 however, is less of a security-token, and more of a permissioned ERC-20. And ERC-1462 requires document attachment functionality, as well as verbose transfer checks (it could have been just one interface). And with the inclusion of the functions handling the transfer checks in the standard, they fail to provide the flexibility of the extra data field. ERC-1594 here does a better job at not duplicating the transfer interface for every type of transfer, and provides the data field we need for future improvements.

### Full

It is tempting to add a lot of extra functions in a standard: so much functionality! But then you realize that you are only really limiting yourself to improve on these functionalities, and make adoption of the standard harder.

A compromise would be to just standardize a `ForceTransfer` event and leave implementation open: a `forceTransfer` function is optional, a normal `transferFrom` function, with permission check, can work just as well.

#### Candidates

The Atomic-DSS is a "full" implementation; it provides everything you would expect, but in a way that is not suited for further extensions or flexibility.
It limits possibilities by not allowing for an extra data field, and enforcing a particular regulator-service pattern. It also makes the same mistake as ERC-1404 to make "human-readable" error codes an on-chain function, whereas it would be much better to do so off-chain.

### Opinionated

Architecture design and integration rules are close to being platform-specific, but could be adopted for alternative products. However, it does impose a lot of restrictions on new custom features, as these features may not have been considered by the designers. Newer products should learn from the design choices, but not attach themselves too much to opinionation in existing products.

#### Candidates

R-token is relatively minimal, but heavily opinionated on the contract architecture: a service registry is used for upgrading, and there are expectations on how a regulator service is updated with new rules and data.
This is understandable, given that they are building a product, and not looking to standardize first. Like ERC-1400, they also opted for [`0 = allow`](https://github.com/harborhq/r-token/blob/f4bde844b69ebd67a60130d2b1e390d3c2639d1b/contracts/RegulatorService.sol#L35) (bad security practice), and left other status-codes undefined, instead of adopting a standard, or proposing a new one.

The original ST-20 is very interesting, as it is created by one of the early movers in the space. The creators, Polymath, have moved to create a new standard however: ERC-1400. Their original security token design, ST-20, has a very extensive architecture: Polymath core [describes](https://github.com/PolymathNetwork/polymath-core#the-polymath-core-architecture) an impressive amount of architectural components: a token module registry, token module factories, a token registry, token factories, token module instances, and different STO models.
There is a lot to learn from this diversity of components, but adopting this (relatively old) architecture would introduce a lot of technical debt and design restrictions. Rather, we start more minimal, with insight into the current state-of-the-art solutions, and design towards an optimal but flexible solution for the primary problem: what features benefit investors, willing to partake in the security token ecosystem, the most. Problems first, solutions second.

### Extra

Unsurprisingly, some security token platforms/designers try to get an edge with extra features. However, being locked in with non-standardized token balance systems is something to avoid: if the system is not standardized, there is bad to zero compatiblity with existing wallets. We think it is preferable to build extra solutions with existing core mechanics as a base, for a minimal compatibility. Instead of building something with fundamentally different properties, and wrapping it to make it appear as compatible. This preference not just stems from compability concerns, it also makes conversions to the older system less implicit.

#### Candidates

ERC-1410 is a standard that introduces a tranche-based (i.e. partitioned) balance system. Tranches are like subsets of the balance a normal ETH address would hold, but tagged with properties, and some subsets may not be transferred to others. Although this solves the identity tracking problem (an investor just uses a single address), it does break ERC-20 semantics, and makes transfers illogical (you either have to define defaults, or have to think about the tranche number during transfer). Instead, re-using the ETH-account system is not that bad: all we have to do is connect addresses to one investor, and we can use an address as a tranche: regulator code can prevent a transfer from one tranche to the other. This makes the system fully compatible with existing ERC-20 wallets, and is super easy to adopt (managing multiple addresses is a feature that is already supported by many wallets). The downside is that there is more burden on the regulator contract to track tainting of addresses, as this meta data is not native to the address. Tranches incur a maintainance cost as well however, and we would only opt for adoption after acceptance of the standard and wallet creators showing intentions to support it.

ERC-1400 is an umbrella of different ERCs: partitioning (ERC-1410), contract controllers (ERC-1644), document attachment (ERC-1643), and more. It is complete, but some of the functionality may get in the way of improvements, or may be added later. We are undecided if we want to support the ERC-1644 force-transfer interface. We could opt to conform to the same event format (although a bit verbose), and opt for the addition of explicit force functions. However, the minimal but flexible core interface enables implementers to do the same, so we think ERC-1644 does not need standardization. Or maybe just the events, which are useful to the public, compared to the functions which are not just unnecessary entry points, they are also specific to a very small group of operator-users.


### Platform-specific

Innovation does not need to be limited to a standard, if you aim to create enough of a user-ecosystem to complement the lesser adoption. Platforms like S3 and DS-protocol aim to provide a bigger security token landscape, making platform-specific design choices on the way. It is a trade-off between compatibility with the rest of the ETH ecosystem, and the scope of the product.

#### Candidates

S3 has very peculiar take at security tokens: transfer verification is off-chain, but queued on-chain. For fast-transfers within their marketplace, they seem to exploit the ability to ignore on-chain settlement, as they are the ones verifying transfers later. This seems to provide compatibility with ERC-20, and act like a fully verified security token, but it is less transparent, and the users fully rely on the verifiers to be online.
This approach is undesirable for us, but a modified approach may well be a good fallback to support classical ERC-20 transfers (without data parameter), after a possible future switch to transfer processing based on transactions containing off-chain data (with proof/signature).

DS-protocol is, like the name says, more of protocol than a token guideline. Functionalities are nicely encapsulated, but verbosely packaged into apps, relying on services and registries to attach everything together. The token design is ERC-20 compatible, but the DS v1 whitepaper does not describe what their future intentions are with token interface design. Relying on DS apps for functionality upgrades works, but we would like to see more freedom in the token design itself, for more fundamental changes (e.g. use of private off-chain KYC data).


## Conclusion

After this analysis, the decision to adapt a "core" standard should be unsurprising. ERC-1594 performs here very well, but leaves things to desire for forced transfers. As mentioned earlier, ERC-1644 may complement it well, but may be a bit too much when going for a minimal design. From here, the real differences between STO platforms are made in implementation: compatibility, KYC flow, ability to upgrade, and future planning for innovation are just as important, if not more, than the interface.

Compatibility is achieved by supporting ERC-20, and using it as a building block, instead of a wrapper, for partitioned tokens.

KYC flow is achieved by tracking investor identity for each address, and only then making a mapping from investor ID to KYC data, stored in an external storage contract.

Upgrade ability is a matter of separating the regulatory logic from the contract, in a minimal but complete manner: providing all the transfer data, including the additional data argument for future use.

The list of data types potentially provided through the additional data argument should give a good idea of the different innovations being researched. The design and implementation of these will be covered in a future write-up.


## Disclaimer

We are not affiliated with any of the above projects, but do not claim to be unbiased or fully informed. This is not investment advice.
