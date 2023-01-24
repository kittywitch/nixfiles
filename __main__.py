"""The Katzian Monorepo Pulumi Stack"""

import pulumi
from pulumi import Output
import pulumi_tailscale as tailscale
import pulumi_cloudflare as cloudflare
from typing import Optional
import collections
import json
import jsonpickle

tailnet = tailscale.get_devices()

zones_ = {"inskip": "inskip.me"}

record_dict = collections.OrderedDict(
    {
        "inskip": {
            "gmail": [
                {
                    "recordType": "caa",
                    "flags": 0,
                    "tag": "iodef",
                    "value": "mailto:acme@inskip.me",
                },
                {"recordType": "caa", "flags": 0, "tag": "issuewild", "value": ";"},
                {
                    "recordType": "caa",
                    "flags": 0,
                    "tag": "issue",
                    "value": "letsencrypt.org",
                },
                {"recordType": "mx", "priority": 1, "value": "aspmx.l.google.com"},
                {"recordType": "mx", "priority": 5, "value": "alt1.aspmx.l.google.com"},
                {"recordType": "mx", "priority": 5, "value": "alt2.aspmx.l.google.com"},
                {
                    "recordType": "mx",
                    "priority": 10,
                    "value": "alt3.aspmx.l.google.com",
                },
                {
                    "recordType": "mx",
                    "priority": 10,
                    "value": "alt4.aspmx.l.google.com",
                },
                {
                    "recordType": "mx",
                    "priority": 15,
                    "value": "6uyykkzhqi4zgogxiicbuamoqrxajwo5werga4byh77b2iyx3wma.mx-verification.google.com",
                },
                {
                    "recordType": "txt",
                    "domain": "@",
                    "value": "v=spf1 include:_spf.google.com ~all",
                },
                {
                    "recordType": "txt",
                    "domain": "google._domainkey",
                    "value": "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAkxag/EmXQ89XQmLrBDPpPtZ7EtEJT0hgvWf/+AFiOfBOm902tq9NbTTvRJ2dLeBLPaV+hNvq2Alc7UfkKUDlLTWQjeuiC6aOnRKQQg3LZ2W25U3AlIj0jd2IPiUhg9JGV4c66XiqQ5ylTBniShfUUyeAXxbPhYFBCkBg62LZcO/tFpFsdKWtZzLjgac5vTJID+M4F8duHpkA/ZCNNUEmtt7RNQB/LLI1Gr5yR4GdQl9z7NmwtOTo9pghbZuvljr8phYjdDrwZeFTMKQnvR1l2Eh/dZ8I0C4nP5Bk4QEfmLq666P1HzOxwT6iCU6Tc+P/pkWbrx0HJh39E1aKGyLJMQIDAQAB",
                },
                {
                    "recordType": "txt",
                    "domain": "_dmarc",
                    "value": "v=DMARC1; p=none; rua=mailto:dmarc-reports@inskip.me",
                },
            ],
        },
    }
)

class DnsRecord:
    def __init__(self, **data):
        self.recordType = data["recordType"].upper() if "recordType" in data else None
        self.zone = zones[data["zone"]] if "zone" in data else zones["inskip"]
        self.recorded = None
        self.priority = data["priority"] if "priority" in data else None
        self.flags = data["flags"] if "flags" in data else None
        self.value = data["value"]
        self.domain = data["domain"] if "domain" in data else "@"
        self.ttl = data["ttl"] if "ttl" in data else 3600
        self.tag = data["tag"] if "tag" in data else None
        self.data = data

    def record(self):
        self.name = f'{self.recordType}-{self.data["zone"] if "zone" in self.data else "inskip"}-{self.domain if self.domain != None else "@"}-{self.priority if self.priority != None else "na"}-{hash(self.value)}'
        if self.recordType == "CAA":
            self.recorded = cloudflare.Record(
                self.name,
                zone_id=self.zone.id,
                type=self.recordType,
                ttl=self.ttl,
                name=self.domain,
                data={
                    "flags": self.flags,
                    "tag": self.tag,
                    "value": self.value,
                },
            )
        else:
            self.recorded = cloudflare.Record(
                self.name,
                zone_id=self.zone.id,
                type=self.recordType,
                priority=self.priority,
                value=self.value,
                ttl=self.ttl,
                name=self.domain,
            )


class ARecord(DnsRecord):
    def __init__(self, **data):
        super().__init__(**data)
        self.recordType = "A"
        self.priority = None
        self.record()


class AAAARecord(DnsRecord):
    def __init__(self, **data):
        super().__init__(**data)
        self.recordType = "AAAA"
        self.priority = None
        self.record()


class MXRecord(DnsRecord):
    def __init__(self, **data):
        super().__init__(**data)
        self.recordType = "MX"
        self.record()


class TXTRecord(DnsRecord):
    def __init__(self, **data):
        super().__init__(**data)
        self.recordType = "TXT"
        self.priority = None
        self.record()


class CAARecord(DnsRecord):
    def __init__(self, **data):
        super().__init__(**data)
        self.recordType = "CAA"
        self.record()


def ConstructorToType(type):
    return {
        "a": ARecord,
        "aaaa": AAAARecord,
        "mx": MXRecord,
        "txt": TXTRecord,
        "caa": CAARecord,
    }[type.lower()]


zones = {
    alias: cloudflare.Zone(alias, jump_start=False, zone=value, plan="free")
    for alias, value in zones_.items()
}

tailscale_devices_ = tailscale.get_devices()

tailscale_devices = {
    device.name: device.addresses for device in tailscale_devices_.devices
}

records = {**{
    i: ConstructorToType(content["recordType"])(**content)
    for i, content in enumerate(record_dict["inskip"]["gmail"])
}, **{
    f"tailscale-{name.split('.')[0]}": {
        recordType: ConstructorToType(recordType)(
            value=addresses[i], domain=name.split(".")[0], zone="inskip"
        )
        for i, recordType in enumerate(["A", "AAAA"])
    }
    for name, addresses in tailscale_devices.items()
}}

pulumi.info(jsonpickle.encode(records, indent=2))
