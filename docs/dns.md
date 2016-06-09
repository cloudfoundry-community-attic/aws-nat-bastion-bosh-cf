# DNS

You'll need to be able to add **multi-level wildcard subdomains** to whatever root domain you plan to use with your deployment through this project. For example:

```
blobstore.run.example.com
```

Would be a multi-level wildcard subdomain that might be used for service discovery of the blobstore. This is just an example of _one_ possibility, though many more will be needed for a minimum viable deployment.

## Potential Providers

```c
#include <std/disclaimer.h>
```

**DISCLAIMER: THE INCLUSION OF THE BELOW PROVIDERS IS ABSOLUTELY NOT IN ANY WAY AN ENDORSEMENT, ADVERTISEMENT, OR IN ANY WAY A COMMERCIAL ENDEAVOR.** There is no official relationship between any of the below entities and the Cloud Foundry Community Project, Pivotal, Inc., Stark and Wayne Ltd., nor between the entity/ies below and/or any employee or associate of any of the foregoing. THE BELOW ENTITIES HAVE _NOT_ PROVIDED FINANCIAL OR OTHER COMPENSATION IN EXCHANGE FOR THEIR INCLUSION HERE.

These are a few providers various engineers working on the project happen to know about. We don't guarantee any specific feature set or minimum supported configuration is available at any of the below; we just happen to remember dealing with them at one point or another and it seemed possible to use their service to orchestrate the DNS piece that you'll need here relatively easily.

| Provider | Free Tier? | Comments |
| :------  | :-------: | :------  |
| [namecheap.com](https://www.namecheap.com) | Y | _Yes, works in FreeDNS mode._ |
| [cloudflare.com](https://www.cloudflare.com) | Y | _Works on free tier_ |
| [dnsimple.com](https://dnsimple.com) | N | Untested; claims to support wildcard, YMMV |
| [noip.com](http://www.noip.com) | N | Untested; claims to support wildcard, YMMV |
| [Google Cloud DNS](https://cloud.google.com/dns/) | N | Untested but I'll bet you a coke it'll work fine |
| [hover.com](http://www.hover.com) | Sorta? | Domain registrar; base product does include DNS management system that does support wildcard records |
| [dnsmadeeasy.com](http://www.dnsmadeeasy.com/) | N | Untested; claims to support wildcard dns records |

Honorable mention: [Lithium DNS](https://lidns.net) -- Unfortunately it doesn't seem they're able to support wildcard dns records _yet_, but that appears to be because they're quite new. When I tested this provider I found that I was able to specify some sorta weird settings, like an `A` record for a personal domain pointing at `127.0.0.1` _and it actually works_. Might be a good tool to use in certain situations (personal dev domains, possibly other applications, etc.)

### Your Domain Registrar

You may not have to do much to get wildcard support for your DNS records. Turns out some more forward-thinking domain name registrars already support this feature within their own domain management control panel. I personally tested Hover today and did indeed find it working just fine. I'd be surprised if the mainstream guys out there didn't either already support this feature, or aren't at least _scrambling_ to do so at the earliest possibility.

### Dynamic DNS?

We haven't tested this with dynamic dns yet, but _in theory_ it could work if you can get the same domain schema set up:

```
A.B.yourdomain.tld
```

Where `A` and `B` can and will differ, potentially changing often (hence the need for a wildcard). But hey, if you can get it based on `yourdomain.tld` instead of `dynamicdns-providers-domain.tld` as the root, it _should_ work.

### Know of something that should be in this list?

If you'd like to add to this list, fork this project, create a branch and add to this list. Our criteria for acceptance is simple:

+ Not in any way an advertisement or benefitting a specific company/individual;
+ Supports multi-tier widlcard DNS records (CNAME)
+ If you're going to put them on the list, we expect you to test that feature before adding it to this list.
+ _Free tier or no-cost usage is **not** required, but it's a "nice to have"_ so if they do have a free tier, and it works for this purpose, please let the world know.

> Why not AWS Route53?

You ever heard that old saying, "don't put all your eggs in one basket?" This product's MVP, and likely around ~80% of its users, will be pushing this to AWS. _Putting all your stuff in Amazon's hands makes you a victim to vendor lock-in and puts you at higher risk for SPOF based on the vendor and their whims._

That said, if you really want to do that, go right ahead. I can't see any reason they _wouldn't_ support wildcard subdomains.

## What do I actually _need_ here when setting up a wildcard subdomain?

Some places differentiate between a _multi-level_ or _multi-tier_ wildcard subdomain (e.g. `A.B.yourdomain.tld`) and others just call it and a single-tier wildcard subdomain the same thing: a wildcard subdomain (e.g. `*.yourdomain.tld`).

**In theory, a basic `*.yourdomain.tld` CNAME record should work.**

That said, this is going to depend entirely on the the DNS provider, their back-end implementation, and maybe even just the javascript in their browser application checking regexs too aggressively. _You'll just have to try it yourself to be sure._

# Suggestion: do a test run on  personal or non-vital domain first.

Point those nameservers wherever, wait for propagation to clear, then push some new records with your new DNS provider as a trial run first, **before** risking putting your production domain on a provider that may not be quite right.

# Use `dig` to check on things

Example:

```
$ dig blobstore.run.myapp.tld


; <<>> DiG 9.8.3-P1 <<>> a.b.cloudforge.one
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47776
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;a.b.yourdomain.tld.		IN	A

;; ANSWER SECTION:
a.b.yourdomain.tld.	         1799	IN	CNAME	some-aws-hostname.amazonaws.com.
some-aws-hostname.amazonaws.com. 3600   IN	A       999.999.999.999.

;; Query time: 139 msec
;; SERVER: 192.168.1.1#53(192.168.1.1)
;; WHEN: Tue Jun  7 22:19:38 2016
;; MSG SIZE  rcvd: 130
```

While I'd prefer to explain this visually, here's a brief rundown of what some of these things mean for anyone who just needs a quick "get to the point", like I often do :smiley:

```
;; QUESTION SECTION:
;a.b.yourdomain.tld            IN     A
```

This is the question you asked: "hey, what's a.b.yourdomain.tld?". Since you didn't specify the DNS record type it automatically assumed you were asking about its `A` record (`A` record = "authoritative" record; normally that goes to an IP address and "anchors" a domain somewhere).

```
;; ANSWER SECTION:
a.b.yourdomain.tld.	         1799	IN	CNAME	some-aws-hostname.amazonaws.com.
```

"Hey, I found an answer to your question!" the hostname `a.b.yourdomain.tld` is actually a `CNAME` - short for "Canonical Name" which often "aliases" one hostname to either another `CNAME` or to another `A` record - and it has a value of `some-aws-hostname.amazonaws.com`. So if you want to reach that, you'll need to look up the A record for `some-aws-hostname.amazonaws.com`.

```
some-aws-hostname.amazonaws.com. 3600   IN	A      999.999.999.999.
```

"...which, by the way, I'm awesome because _I just did that for you automagically!_ Turns out that's indeed an `A` record with an IP address of `999.999.999.999`." (No that's not a real ipv4 address, I just put that in there as a placeholder.)

```
;; Query time: 139 msec
```

It took 139 miliseconds to perform this query. In terms of DNS over UDP, that's pretty slow and honestly since this is a copy/paste from my local dev machine, I'm now reeeeeaaaly thinking about overhauling my DNS setup...

```
;; SERVER: 192.168.1.1#53(192.168.1.1)
```

Aha, that's why it was so slow! `192.168.1.1` is my cheap cheesey little in-home Netgear wireless router! My query went to something with low CPU and memory throughput - a cheap appliance, basically - instead of going to a real DNS provider. And because that little guy didn't have the information cached, he had to reach out through the internet to my ISP's default DNS server (which likely had to do some nefarious privacy-invasive nonsense, thus making it slower) to get the record and return it to me. Waaaay too much work. Better approach: specify my own list of nameservers through my operating system's standard interface.

#### ...and there you have it - a quick and useful DNS primer to get you started!

