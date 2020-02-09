# ElectrumX CLI tool

**NOTE: this is work in progress. Use at your own risk, you have been warned!**

This is an attempt to come up with a nice [ElectrumX](https://github.com/kyuupichan/electrumx) CLI tool written in bash using parts of [`bitcoin-bash-tools`](https://github.com/grondilu/bitcoin-bash-tools), `Copyright (C) 2013 Lucien Grondin (grondilu@yahoo.fr)`. This is **not** using the `RPC` interface but talking [ElectrumX protocol](https://electrumx.readthedocs.io/en/latest/protocol-methods.html) to a given server directly. Besides `Master Node` related functionality which i am not planning to implement myself, these protocol methods are not implemented (yet):

  + `blockchain.transaction.broadcast`
  + `server.add_peer`

  See the [ElectrumX v1.14 docs](https://electrumx.readthedocs.io/en/latest/) for more info and a list of protocol methods  and their description.

  Pull requests are welcome!

## Prerequisites

Install these packages:

```
$ sudo apt install jq nmap bc
```

**NOTE**: `nmap` is needed because of `ncat`. `bc` is needed because we need to do some precise maths. Additionally, a `sleep` binary must be in your `$PATH`, but that should come with everybodies default install. 

## Installation

```
$ git clone github.com/BloodyNora/electrumx-cli
$ cd electrumx-cli
$ git submodule init
$ git submodule update
$ sudo cp electrumx-completion.bash /etc/bash_completion.d/
```

## General usage

```bash
$ ./electrumx chain height
```

Per default, `electrumx` will try and talk to `tcp://el0.veruscoin.io:17485` (SSL/TLS isn't supported yet). To connect to a different host and/or port, do this: 

```bash
$ H=electrum1.cipig.net P=10001 ./electrumx chain subscribe
```

You can have `electrumx` echo the server it uses to `STDERR` if you set `${D}` to a non-empty value (currently any value will work): 

```bash
$ D=1 ./electrumx srv ping
```

Per default, all but the `subscribe` commands (-> all simple requests) will wait for 0.5s before returning. The `subscribe` commands will timeout after 600s. To change either one at runtime, set `T` to a higher value like this: 

```bash
$ T=1.5 ./electrumx srv features
```

*or*

```bash
$ T=3600 ./electrumx chain subscribe
```

## ElectrumX Protocol Methods

### `blockchain.block.header`

| Position | Parameter | Description                                    |
|---------:|-----------|------------------------------------------------|
| 1        | `height`  | Which block height to get the block header for |

#### Example
```bash
$ ./electrumx chain header 800200
04000100d5db2d209f4ffeaf2e3807e4ecf0899a129f72ab2af2f4e88963...
```

### `blockchain.block.headers`

| Position | Parameter | Description                                    |
|---------:|-----------|------------------------------------------------|
| 1        | `height`  | Which block height to get the block header for |
| 2        | `number`  | Number of block headers to get                 |

#### Example

```bash
$ ./electrumx chain headers 800200 2
{
  "hex": "04000100d5db2d209f4f...00000004000100d23d40d8bc3...000000",
  "count": 2,
  "max": 2016
}
```

### `blockchain.estimatefee`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `numconfirm`  | Estimation of fee when the minimum number of confirmations for a transaction should be `numconfirm`. |

#### Example
```bash
$ ./electrumx chain estimatefee 15
0.00011079
```

### `blockchain.relayfee`

*This method has no parameters*

#### Example
```bash
$ ./electrumx chain relayfee
0.00000100
```

### `blockchain.headers.subscribe`

*This method has no parameters*

#### Example

```bash
$ ./electrumx chain subscribe
{
  "hex": "040001005e611e9febbf6564d473a379bf19...",
  "height": 873532
}
[
  {
    "hex": "04000100cfe4bf46a761a79d7a328c8594...",
    "height": 873537
  }
]
```

### `'current chain height'`

**NOTE**: This is not directly backed by any protocol method but was easy to do using `blockchain.headers.subscribe` and a short subscription time.

*This method has no parameters*

#### Example
```bash
$ ./electrumx chain height
873582
```

### `blockchain.scripthash.get_balance`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `address`     | `P2PKH` or `P2SH` address to get balance for   |

#### Example

```bash
$ ./electrumx addr balance RBBxnQZyPhAwcejNK25wdQEpp6JgTkfbww
5116.03321921
```

### `blockchain.scripthash.get_history`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `address`     | `P2PKH` or `P2SH` address to get balance for   |

#### Example

```bash
$ ./electrumx addr history bCm5tsaA5PagFf6kGTL9KowaGds2qcH28i
[
  {
    "tx_hash": "ff1ec4aff6c58cb2e9ad6a212057b8c81ef20bfecf7b42fd71a7419e4bfcc3d0",
    "height": 57787
  },
  {
    "tx_hash": "ec73d5daa516565c751830ecc88e188dd77512a13ba37df92b1fc11ab8ab54fa",
    "height": 671640
  },
  {
    "tx_hash": "279387fee138b648a7a80687cbbe17b27a035a704b7985231c4a0fd22315ad92",
    "height": 846488
  }
]
```

### `blockchain.scripthash.get_mempool`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `address`     | `P2PKH` or `P2SH` address to get balance for   |

#### Example

```bash
./electrumx addr mempool bCm5tsaA5PagFf6kGTL9KowaGds2qcH28i
[
  {
    "tx_hash": "279387fee138b648a7a80687cbbe17b27a035a704b7985231c4a0fd22315ad92",
    "height": 0,
    "fee": 0
  }
]
```

### `blockchain.scripthash.listunspent`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `address`     | `P2PKH` or `P2SH` address to get balance for   |

#### Example

```bash
$ ./electrumx addr unspent bCm5tsaA5PagFf6kGTL9KowaGds2qcH28i
[
  {
    "tx_hash": "279387fee138b648a7a80687cbbe17b27a035a704b7985231c4a0fd22315ad92",
    "tx_pos": 0,
    "height": 846488,
    "value": 4800059000
  }
]
```

### `blockchain.scripthash.subscribe`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `address`     | `P2PKH` or `P2SH` address to get balance for   |

#### Example

```bash
$ ./electrumx addr subscribe bCm5tsaA5PagFf6kGTL9KowaGds2qcH28i
82444c5f8b2b55ef6e02e95f1a2bd259a0e32a5281402fbf2a952f3ea9c292e2
```

**NOTE**: The result is a `scripthash status`. For more info click [here](https://electrumx.readthedocs.io/en/latest/protocol-basics.html#status).

### `blockchain.transaction.get`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `txid`        | ID of transaction to display                   |

#### Example

```bash
$ ./electrumx tx get 9c48270d8071b65a9109ef2ace74266f712ab3a98fb593c15ef51cf491eba3dc
{
  "hex": "0400008085202f89010000000000000000000000000000000000000000000000000000000000000000ffffffff050389540d00ffffffff0100180d8f000000001976a91414f312dbdeaba05d5b76ecd9a306b72020deee6288ac00000000000000000000000000000000000000",
  "txid": "9c48270d8071b65a9109ef2ace74266f712ab3a98fb593c15ef51cf491eba3dc",
  "overwintered": true,
  "version": 4,
  "versiongroupid": "892f2085",
  "locktime": 0,
  "expiryheight": 0,
  "vin": [
    {
      "coinbase": "0389540d00",
      "sequence": 4294967295
    }
  ],
  "vout": [
    {
      "value": 24,
      "valueSat": 2400000000,
      "n": 0,
      "scriptPubKey": {
        "type": "pubkeyhash",
        "reqSigs": 1,
        "addresses": [
          "RBBxnQZyPhAwcejNK25wdQEpp6JgTkfbww"
        ],
        "asm": "OP_DUP OP_HASH160 14f312dbdeaba05d5b76ecd9a306b72020deee62 OP_EQUALVERIFY OP_CHECKSIG",
        "hex": "76a91414f312dbdeaba05d5b76ecd9a306b72020deee6288ac"
      }
    }
  ],
  "vjoinsplit": [],
  "valueBalance": 0,
  "vShieldedSpend": [],
  "vShieldedOutput": [],
  "blockhash": "000000000046587d850582a5e56e264ccc9a69269da850f40ab598e5e050a35a",
  "height": 873609,
  "confirmations": 1,
  "time": 1580988668,
  "blocktime": 1580988668
}
```

### `blockchain.transaction.id_from_pos`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `height`      | Block height to search for tx in               |
| 2        | `position`    | Position of tx in block, starting from zero    |

#### Example

```bash
$ ./electrumx tx get_pos 800200 1
{
  "tx_hash": "3993b129d3054b3dd334615d14907e559fb94b9d4d6fe3be8dd8315538a21316",
  "merkle": [
    "7194e209aa8518384239eacdb37f08fd3bf381148a1935a15b51c8490a93d7e7"
  ]
}
```

### `mempool.get_fee_histogram`

*This method has no parameters*

#### Example

```bash
$ ./electrumx mempool get_fh
[
  [
    12,
    128812
  ],
  [
    4,
    92524
  ],
  [
    2,
    6478638
  ],
  [
    1,
    22890421
  ]
]
```

### `server.banner`

*This method has no parameters*

#### Example

```bash
$ ./electrumx srv banner
You are connected to an ElectrumX 1.14.0 server.
```

### `server.donation_address`

*This method has no parameters*

#### Example

```bash
$ ./electrumx srv donations
RGKb9BGcWbjS2Mee1DaGXbub4u4zEUgkUQ
```

### `server.features`

*This method has no parameters*

#### Example

```bash
$ ./electrumx srv features
{
  "hosts": {},
  "pruning": null,
  "server_version": "ElectrumX 1.14.0",
  "protocol_min": "1.4",
  "protocol_max": "1.4.2",
  "genesis_hash": "027e3758c3a65b12aa1046462b486d0a63bfa1beae327897f56c5cfb7daaae71",
  "hash_function": "sha256",
  "services": []
}
```

**NOTE**: See [this document](https://electrumx.readthedocs.io/en/latest/protocol-methods.html#server-features) for a description of the features.

### `server.peers.subscribe`

*This method has no parameters*

#### Example

```bash
$ ./electrumx srv peers
[
  "107.150.45.210",
  "e.anonyhost.org",
  [
    "v1.0",
    "p10000",
    "t",
    "s995"
  ]
]
```

### `server.ping`

*This method has no parameters*

#### Example

```bash
$ ./electrumx srv ping
pong!
```

### `server.version`

*This method has no parameters*

#### Example

```bash
$ ./electrumx srv version
ElectrumX 1.14.0
```
