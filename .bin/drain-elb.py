#!/usr/bin/python3

import argparse
import boto3
import json


def main():
    parser = argparse.ArgumentParser(
        description="Remove instance(s) from the associated ELB Target Groups"
    )
    parser.add_argument(
        "instance_names",
        type=str,
        metavar="INSTANCE",
        help="Name tag(s) of the instance(s) to remove from ELBs",
        nargs="+"
    )
    parser.add_argument(
        "--profile",
        dest="aws_profile",
        type=str,
        metavar="aws_profile",
        help="AWS profile to use"
    )
    parser.add_argument(
        "--dryrun",
        action="store_true",
        help="Only run as dryrun without making changes"
    )

    args = parser.parse_args()

    if args.aws_profile:
        session = boto3.Session(profile_name=args.aws_profile)
    else:
        session = boto3.Session()

    client = session.client("elbv2")

    targets = get_alb_targets(session)
    for instance in get_instance_id(session, args.instance_names):
        for tg in targets[instance["Id"]]:
            if args.dryrun:
                print(
                    "DRYRUN: Removed {0} from {1}".format(
                        instance["Name"],
                        tg
                    )
                )
            else:
                response = client.deregister_targets(
                    TargetGroupArn=tg,
                    Targets=[{"Id": instance["Id"]}]
                )
                if response["ResponseMetadata"]["HTTPStatusCode"] == 200:
                    print(
                        "Removed {0} from {1}".format(
                            instance["Name"],
                            tg
                        )
                    )
                else:
                    print(
                        "Issue removing {0} from {1}".format(
                            instance["Name"],
                            tg
                        )
                    )
                    print(json.dumps(response, indent=4, sort_keys=True))


def get_instance_name(instance):
    try:
        for tag in instance["Tags"]:
            if tag["Key"] == "Name":
                return tag["Value"]
        return "none"
    except Exception:
        return "none"


def get_instance_id(session, name):
    try:
        instances = []
        client = session.client("ec2")
        response = client.describe_instances(
            Filters=[
                {
                    "Name": "tag:Name",
                    "Values": name
                }
            ]
        )["Reservations"]

        for r in response:
            for instance in r["Instances"]:
                instances.append(
                    {
                        "Id": instance["InstanceId"],
                        "Name": get_instance_name(instance)
                    }
                )

        return instances

    except Exception:
        print("Error occured while getting InstanceId")
        return []


def get_alb_targets(session):
    try:
        client = session.client("elbv2")
        targets = {}
        for tg in client.describe_target_groups()["TargetGroups"]:
            for t in client.describe_target_health(
                TargetGroupArn=tg["TargetGroupArn"]
            )["TargetHealthDescriptions"]:
                target = t["Target"]["Id"]
                if target not in targets:
                    targets[target] = []

                targets[target].append(
                    tg["TargetGroupArn"]
                )
        return targets
    except Exception:
        print("Error occured while getting targets")
        return {}

def datetime_handler(x):
    if isinstance(x, datetime.datetime):
        return x.isoformat()
    raise TypeError("Unknown type")


if __name__ == "__main__":
    main()
