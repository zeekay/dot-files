#!/usr/bin/env python3

from eth_wallet import Wallet
from eth_wallet.utils import generate_entropy

import json

# 128 strength entropy
ENTROPY = generate_entropy(strength=128)
# Secret passphrase
PASSPHRASE = None  # str("meherett")
# Choose language english, french, italian, spanish, chinese_simplified, chinese_traditional, japanese & korean
LANGUAGE = "english"  # default is english

# Initialize wallet
wallet = Wallet()
# Get Ethereum wallet from entropy
wallet.from_entropy(entropy=ENTROPY, passphrase=PASSPHRASE, language=LANGUAGE)

# Derivation from path
# wallet.from_path("m/44'/60'/0'/0/0'")
# Or derivation from index
wallet.from_index(44, harden=True)
wallet.from_index(60, harden=True)
wallet.from_index(0, harden=True)
wallet.from_index(0)
wallet.from_index(0, harden=True)

# Print all wallet information's
print(json.dumps(wallet.dumps(), indent=4, ensure_ascii=False))
