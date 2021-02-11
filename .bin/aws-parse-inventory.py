#!/usr/bin/python3

import argparse
import boto3
import csv
import datetime
import ipaddress
import json
import sys


def main():
    parser = argparse.ArgumentParser(
        description="Remove instance(s) from the associated ELB Target Groups"
    )
    parser.add_argument(
        "--profile",
        dest="aws_profile",
        type=str,
        metavar="aws_profile",
        help="AWS profile to use"
    )

    args = parser.parse_args()

    if args.aws_profile:
        session = boto3.Session(profile_name=args.aws_profile)
    else:
        session = boto3.Session()

    output = csv.writer(sys.stdout)
    ec2 = ec2_instances(session)
    for line in ec2:
        output.writerow(line)

    rds = rds_instances(session)
    for line in rds:
        output.writerow(line)

    alb = alb_instances(session)
    for line in alb:
        output.writerow(line)

    subnet = subnet_instances(session)
    for line in subnet:
        output.writerow(line)


def ec2_instances(session):
    client = session.client("ec2")

    output = []
    data = client.describe_instances()
    for instance in data["Reservations"]:
        for i in instance["Instances"]:
            tmp = []
            tmp.append(i["InstanceId"])
            tmp.append(i["PrivateIpAddress"])
            if i["VirtualizationType"]:
                tmp.append("Yes")
            else:
                tmp.append("No")
            if i["PublicDnsName"]:
                tmp.append("Yes")
            else:
                tmp.append("No")
            name = ""
            for tag in i["Tags"]:
                if tag["Key"] == "Name":
                    name = tag["Value"]
            tmp.append(name)
            tmp.append("")
            mac = []
            for interface in i["NetworkInterfaces"]:
                mac.append(interface["MacAddress"])
            tmp.append(",".join(mac))
            tmp.append("Yes")
            tmp.append(i["ImageId"])
            tmp.append("")
            tmp.append("")
            tmp.append("EC2")
            tmp.append(i["InstanceType"])
            tmp.append("")
            tmp.append("")
            tmp.append("")
            tmp.append("")
            tmp.append("")
            tmp.append("")
            tmp.append("")
            tmp.append(i["VpcId"])
            tmp.append("")
            tmp.append("")

            output.append(tmp)

    return output


def alb_instances(session):
    client = session.client("elbv2")
    ec2_client = session.client("ec2")

    output = []
    data = client.describe_load_balancers()
    for i in data["LoadBalancers"]:
        tmp = []

        interfaces = ec2_client.describe_network_interfaces(
            Filters=[
                {
                    "Name": "description",
                    "Values": [
                        "ELB " + "/".join(i["LoadBalancerArn"].split("/")[1:])
                    ]
                }
            ]
        )["NetworkInterfaces"]

        tmp.append(i["LoadBalancerArn"])
        ip_addresses = []
        for interface in interfaces:
            ip_addresses.append(interface["PrivateIpAddress"])
        tmp.append(", ".join(ip_addresses))
        tmp.append("Yes")
        if i["Scheme"] != "internal":
            tmp.append("Yes")
        else:
            tmp.append("No")
        tmp.append(i["DNSName"])
        tmp.append("")
        mac = []
        for interface in interfaces:
            mac.append(interface["MacAddress"])
        tmp.append(", ".join(mac))
        tmp.append("No")
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append("Load Balancer-application")
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append(i["VpcId"])
        tmp.append("")
        tmp.append("")

        output.append(tmp)

    return output


def rds_instances(session):
    client = session.client("rds")
    ec2_client = session.client("ec2")

    output = []
    data = client.describe_db_instances()
    for i in data["DBInstances"]:
        tmp = []

        interfaces = ec2_client.describe_network_interfaces(
            Filters=[
                {
                    "Name": "requester-id",
                    "Values": [
                        "amazon-rds"
                    ]
                }
            ]
        )["NetworkInterfaces"]

        tmp.append(i["DBInstanceArn"])
        ip_addresses = []
        for interface in interfaces:
            ip_addresses.append(interface["PrivateIpAddress"])
        tmp.append(", ".join(ip_addresses))
        tmp.append("Yes")
        tmp.append("No")
        tmp.append(i["Endpoint"]["Address"])
        tmp.append("")
        mac = []
        for interface in interfaces:
            mac.append(interface["MacAddress"])
        tmp.append(", ".join(mac))
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append("RDS")
        tmp.append(i["DBInstanceClass"])
        tmp.append("")
        tmp.append("AWS")
        tmp.append("%s-%s" % (i["Engine"], i["EngineVersion"]))
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append("")
        tmp.append(i["DBSubnetGroup"]["VpcId"])
        tmp.append("")
        tmp.append("")

        output.append(tmp)

    return output


def subnet_instances(session):
    client = session.client("ec2")

    output = []
    data = client.describe_subnets()
    for i in data["Subnets"]:

        vpc_subnet = i["VpcId"] + "/" + i["SubnetId"]
        ips = list(ipaddress.ip_network(i["CidrBlock"]).hosts())
        router_ip = ips[0]
        dns_ip = ips[1]

        gateway = [
            vpc_subnet + "/gateway",
            router_ip,
            "Yes",
            "No",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "Network",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            i["VpcId"],
            "",
            ""
        ]

        dns = [
            vpc_subnet + "/dns",
            dns_ip,
            "Yes",
            "No",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "Network",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            "",
            i["VpcId"],
            "",
            ""
        ]

        output.append(gateway)
        output.append(dns)

    return output


def datetime_handler(x):
    if isinstance(x, datetime.datetime):
        return x.isoformat()
    raise TypeError("Unknown type")


if __name__ == "__main__":
    main()
