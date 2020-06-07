# CLOVERSPLITTER
A Ruby implementation of Samir's Secret Sharing.

# WARNING
Please be aware that this gem has not undergone any form of security evaluation. This gem is not recommended for usage under mission-critical circumstances and should not be relied upon to protect confidential or secret information. Users should assume that this gem is insecure until they can independently confirm otherwise.

## Description
This gem is a minimal implementation of Samir's Secret Sharing in Ruby that may be used to split a secret piece of text into a list of shares from which that text may later be recovered. By default, CLOVERSPLITTER uses the 18th Mersenne prime for share generation and produces a total of six shares with a minimum of three shares required for recovery. Although these defaults may be changed through optional parameters in the `cloversplitter.generate_shares` function, doing so is not recommended and may cause errors or issues with secrecy and recovery.

## Dependencies
* Ruby >= 2.5.5 (CLOVERSPLITTER has not been tested on anything below 2.5.5)
* SecureRandom (included in the Ruby Standard Library)

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

## Support
If you found this project useful and would like to encourage me to continue making open source software, please consider making a donation via the following link:

<style>.bmc-button img{height: 34px !important;width: 35px !important;margin-bottom: 1px !important;box-shadow: none !important;border: none !important;vertical-align: middle !important;}.bmc-button{padding: 7px 15px 7px 10px !important;line-height: 35px !important;height:51px !important;text-decoration: none !important;display:inline-flex !important;color:#FFFFFF !important;background-color:#FF813F !important;border-radius: 5px !important;border: 1px solid transparent !important;padding: 7px 15px 7px 10px !important;font-size: 28px !important;letter-spacing:0.6px !important;box-shadow: 0px 1px 2px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;margin: 0 auto !important;font-family:'Cookie', cursive !important;-webkit-box-sizing: border-box !important;box-sizing: border-box !important;}.bmc-button:hover, .bmc-button:active, .bmc-button:focus {-webkit-box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;text-decoration: none !important;box-shadow: 0px 1px 2px 2px rgba(190, 190, 190, 0.5) !important;opacity: 0.85 !important;color:#FFFFFF !important;}</style><link href="https://fonts.googleapis.com/css?family=Cookie" rel="stylesheet"><a class="bmc-button" target="_blank" href="https://www.buymeacoffee.com/peterfunnell"><img src="https://cdn.buymeacoffee.com/buttons/bmc-new-btn-logo.svg" alt="Buy me a coffee"><span style="margin-left:5px;font-size:28px !important;">Buy me a coffee</span></a>
