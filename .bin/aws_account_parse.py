#!/usr/bin/python3

import argparse
import json
import os

def main():
    parser = argparse.ArgumentParser(
        description="Remove instance(s) from the associated ELB Target Groups"
    )
    parser.add_argument(
        "-p",
        dest="profile",
        type=str,
        metavar="profile",
        help="Resolve the Account ID based on the profile",
    )
    parser.add_argument(
        "-a",
        dest="account",
        type=str,
        metavar="account",
        help="Resolve the Profile based on the Account ID"
    )

    args = parser.parse_args()

    with open(os.path.expanduser('~/.aws/account_mapping.json')) as f:
        data = json.load(f)

    if args.profile:
        print(data["profile"][args.profile])
    if args.account:
        print(data["account"][args.account])

if __name__ == "__main__":
    main()
