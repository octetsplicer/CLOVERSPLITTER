# CLOVERSPLITTER
An experimental pure-Ruby implementation of Shamir's Secret Sharing (for academic/educational purposes only).

# WARNING
Please be aware that this gem has not undergone any form of security evaluation, and is provided for academic/educational purposes only. This gem is not recommended for usage under mission-critical circumstances and should not be relied upon to protect confidential or secret information, or any information with high availability or integrity requirements. This gem should be treated purely as a proof of concept and/or learning exercise. Users should assume that this gem is insecure and that any data it is used to split into shares may be lost.

## Description
This gem is a minimal and experimental implementation of Shamir's Secret Sharing in Ruby that splits a piece of text into a list of shares from which that text can later be recovered (assuming the splitting process worked correctly). By default, CLOVERSPLITTER uses the 18th Mersenne prime for share generation and produces a total of six shares with a minimum of three shares required for recovery. Although these defaults may be changed through optional parameters in the `CloverSplitter.generate_shares` function, doing so is not recommended and may cause errors or issues with secrecy and recovery.

## Dependencies
* Ruby >= 2.5.5 (CLOVERSPLITTER has not been tested on anything below 2.5.5)
* SecureRandom (included in the Ruby Standard Library)

## Installation
CLOVERSPLITTER can be installed as follows:
```
gem install cloversplitter
```

## Usage
A list of six shares (with a minimum of three shares required for secret recovery) may be generated as follows:
```
secret = "This is a secret piece of text!"
full_list = CloverSplitter.generate_shares(secret)
```
After a list of shares has been generated, the secret to which those shares pertain may be recovered from that list as follows:
```
recovered_secret = CloverSplitter.recover_secret(full_list)
```
The secret can also be recovered from a subset of the original shares, provided that the number of shares contained within that subset is equal to or greater than the minimum number of shares required for recovery:
```
partial_list = full_list[0, 3]
recovered_secret = CloverSplitter.recover_secret(partial_list)
```

## Author
Copyright (C) 2020 Peter Bruce Funnell

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
