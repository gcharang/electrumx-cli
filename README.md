# CLI ElectrumX / Litemode CLI tool

**NOTE: this is work in progress. Use at your own risk, you have been warned!**

This is an attempt to come up with a nice ElectrumX CLI tool written in bash (and a litte bit of NodeJS because there sadly is no `bitcoinbash-lib`). This is **not** using the `RPC` interface but talking ElectrumX protocol to a given server directly. Besides `Master Node` related functionality which i am not planning to implement (feel free to PR tho), these ElectrumX protocol methods are not implemented (yet):

  + `blockchain.transaction.broadcast`
  + `server.add_peer`

  See the [ElectrumX v1.14 docs](https://electrumx.readthedocs.io/en/latest/) for more info and a list of ElectrumX protocol methods and their description.

## Prerequisites
Install these packages:
```
apt install jq nmap
```

Note: `nmap` is needed because of `ncat`. Additionally, a `sleep` binary must be in your path, but that should come with everybodies default install.

## Installation

```
git clone github.com/BloodyNora/electrumx-cli
cd electrumx-cli
npm install -g
```

## General usage

### `electrumx`

This is the ElectrumX console client. 

#### Basic usage
```
./electrumx chain height
```

### `scripthash`

This utility is written in NodeJS and making use of [`bitcoinjs-lib`](https://github.com/bitcoinjs/bitcoinjs-lib/). It takes a `P2PKH`- or `P2SH`-address as the only argument and turns it into the `scripthash` that ElectrumX expects for various operations such as `blockchain.scripthash.get_balance` or `blockchain.scripthash.listunspent`.

**NOTE:** Currently, this **does not work** for Verus ID addresses as `bitcoinjs-lib` does not know about them.

```
./scripthash RVD4qyD5oPnAUZaeapRSdExgyEi5wbdCqX
```

## ElectrumX Protocol Methods

### `blockchain.block.header`

| Position | Parameter | Description                                    |
|---------:|-----------|------------------------------------------------|
| 1        | `height`  | Which block height to get the block header for |

#### Example
```
./electrumx chain header 800200
04000100d5db2d209f4ffeaf2e3807e4ecf0899a129f72ab2af2f4e88963000000000000...
```

### `blockchain.block.headers`

| Position | Parameter | Description                                    |
|---------:|-----------|------------------------------------------------|
| 1        | `height`  | Which block height to get the block header for |
| 2        | `number`  | Number of block headers to get                 |

#### Example

```
./electrumx chain headers 800200 2
{
  "hex": "04000100d5db2d209f4f...00000004000100d23d40d8bc3...000000",
  "count": 2,
  "max": 2016
}
```

### `blockchain.estimatefee`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `numconfirm`  | Estimation of fee when target number of confirmations should be `numconfirm`. |

#### Example
```
./electrumx chain estimatefee
-1
```

### `blockchain.relayfee`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| *n/a*    | *n/a*         | *This method has no parameters*                |

#### Example
```
./electrumx chain relayfee
0.00000100
```

### `blockchain.headers.subscribe`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| *n/a*    | *n/a*         | *This method has no parameters*                |

#### Example

```
./electrumx chain subscribe
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

**NOTE:** Per default, the subscription will last for 10min. To change it, prefix the invocation with `S=N` where `N` is the number of seconds: 

```
S=3600 ./electrumx chain subscribe
```

### `'current chain height'`

**NOTE**: This is not a protocol method but was easy to do using `blockchain.headers.subscribe`.

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| *n/a*    | *n/a*         | *This method has no parameters*                |

#### Example
```
./electrumx chain height
873582
```

### `blockchain.scripthash.get_balance`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `address`     | `P2PKH` or `P2SH` address to get balance for   |

#### Example

```
./electrumx addr balance RBBxnQZyPhAwcejNK25wdQEpp6JgTkfbww
5116.03321921
```

### `blockchain.scripthash.get_history`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `address`     | `P2PKH` or `P2SH` address to get balance for   |

#### Example

```
./electrumx addr history bCm5tsaA5PagFf6kGTL9KowaGds2qcH28i
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

### `blockchain.scripthash.listunspent`

| Position | Parameter     | Description                                    |
|---------:|---------------|------------------------------------------------|
| 1        | `address`     | `P2PKH` or `P2SH` address to get balance for   |

#### Example

```
./electrumx addr unspent bCm5tsaA5PagFf6kGTL9KowaGds2qcH28i
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

### `blockchain.transaction.get`

### `blockchain.transaction.id_from_pos`

### `mempool.get_fee_histogram`

### `server.banner`

### `server.donation_address`

### `server.features`

### `server.peers.subscribe`

### `server.ping`

### `server.version`
