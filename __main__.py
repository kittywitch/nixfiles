"""The Katzian Monorepo Pulumi Stack"""

import pulumi
from pulumi import Output
import pulumi_tailscale as tailscale
#import pulumi_cloudflare as cloudflare

tailnet = tailscale.get_devices()

domain_names = [
    "inskip.me",
    "gensokyo.zone",
    "kittywit.ch",
    "dork.dev"
]

#domains = {zone: cloudflare.Zone(
#    jump_start = False,
#    resource_name = zone,
#    zone = zone,
#    plan = "free"
#) for zone in domain_names}
