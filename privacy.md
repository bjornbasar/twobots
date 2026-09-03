# Privacy Policy

**Effective:** 19 August 2026 · **Last updated:** 19 August 2026

This policy explains what personal information **[twobots.dev](https://twobots.dev/)** and the apps
and games published there (each an "app", together the "apps") collect, why, and what you can do
about it. It sits alongside our **[Terms of Use](/terms/)**.

## Who we are

**TwoBots Apps** is the name under which **Bjorn Basar**, an independent software engineer based in
Aotearoa New Zealand, publishes software. It is **not a registered company**, and no separate legal
entity operates the apps.

Throughout this policy, "we", "us" and "our" refer to TwoBots Apps as described above; "you" refers
to the person using an app. We are the **agency** responsible for the personal information described
here, for the purposes of the Privacy Act 2020.

## Contents

1. [What this policy covers](#1-what-this-policy-covers)
2. [The short version](#2-the-short-version)
3. [What we collect](#3-what-we-collect)
4. [What we do not collect](#4-what-we-do-not-collect)
5. [Why we collect it](#5-why-we-collect-it)
6. [Cookies](#6-cookies)
7. [How long we keep it](#7-how-long-we-keep-it)
8. [Who else can see it](#8-who-else-can-see-it)
9. [Where it is stored, and who runs it](#9-where-it-is-stored-and-who-runs-it)
10. [Security](#10-security)
11. [Your rights: access, correction and deletion](#11-your-rights-access-correction-and-deletion)
12. [Children](#12-children)
13. [Do Not Track and Global Privacy Control](#13-do-not-track-and-global-privacy-control)
14. [Changes to this policy](#14-changes-to-this-policy)
15. [Contact and complaints](#15-contact-and-complaints)

---

## 1. What this policy covers

This is the **base policy** shared by every app published under TwoBots Apps.

Some apps collect things only they collect — a household's calendar, a card collection, a budget.
Where an app has **additional privacy terms**, they are linked from that app and **prevail over this
base policy to the extent of any inconsistency**, for that app only. They add detail; they do not
take away any right this policy or the Privacy Act gives you.

This policy does not cover **[minified.work](https://www.minified.work/)**, which is a separate
service with [its own policy](https://www.minified.work/privacy/), or the personal sites at
`basar.co.nz`, which have [their own](https://www.basar.co.nz/privacy/) again.

## 2. The short version

- We collect what an app needs to work, and not much else.
- **We do not sell your information, and we do not use it to advertise to you.** There are no ad
  networks, no tracking pixels, and no third-party analytics companies.
- The apps run on **hardware we own, in New Zealand** — not on a commercial cloud platform.
- You can ask for a copy of your information, ask us to correct it, or ask us to delete it.

The rest of this page is the detail behind those four sentences.

## 3. What we collect

**Account information.** Where an app has accounts: your email address, a password, and a display
name if the app uses one. **We never store your password itself** — only a one-way hash of it (see
section 10). Some apps instead let you sign in with your Google Account: if you choose that, Google
tells us your email address and an account identifier, and we never see or store your Google
password at all.

**The content you put in.** This is most of what the apps hold, and it differs by app — recipes,
a card collection and decks, budget categories and transactions, a household's calendar, chores and
lists, game results. You keep ownership of it; our Terms of Use set out the limited permission you
give us to store and display it back to you.

**Technical logs.** Our reverse proxy records every request: your IP address, the date and time, the
page or endpoint requested, the HTTP status, your browser's user-agent, and the referring page if
your browser sends one. This is ordinary web-server logging, and it is how the service is operated
and defended.

**Analytics — on the games only.** [tongits.twobots.dev](https://tongits.twobots.dev/) and
[pusoy.twobots.dev](https://pusoy.twobots.dev/) load **GoatCounter**, which we host ourselves. It is
**cookieless**, does not follow you between sites, and per its documentation does not store your IP
address — it uses a short-lived salted hash to recognise repeat views within a session. It records
the page path, referring URL, page title, screen width, and derives an approximate country and your
browser and operating system from the request. **The other apps have no analytics at all.**

**Push notification subscriptions.** Where an app offers push reminders and you turn them on, your
browser gives us a subscription endpoint, which we store so we can send them. Turning notifications
off, or removing the app from your browser, ends it.

**Anything you email us.** If you write to us, we keep your message and address so we can reply and
keep a record.

## 4. What we do not collect

- **No payment or card details.** The apps are free. Where an app ever charges, payment is handled
  by a payment provider or an app store and **card details never reach us** — that app's additional
  terms will say so.
- No advertising identifiers, ad networks, or tracking pixels.
- No Google Analytics, Meta pixel, or any third-party analytics company.
- No cross-site tracking, and no attempt to build a profile of you.
- No sale or trade of personal information, for any purpose.
- **No biometric or location data.** Where an app reads a photo — importing a recipe, or scanning a
  card — the image is processed **in your browser** and is not uploaded to us for that purpose.

## 5. Why we collect it

| What | Why |
|---|---|
| Account information | To let you sign in, to keep your data yours, and to contact you about your account |
| Your content | To provide the app — it is the thing the app exists to hold |
| Technical logs | To operate the service, diagnose faults, and defend against abuse |
| Analytics (games only) | To know roughly how many people played, and from where |
| Push subscriptions | To send only the notifications you asked for |
| Email correspondence | To reply, and to keep a record |

We do not use your content to train machine-learning models.

## 6. Cookies

The apps set **strictly necessary cookies only** — the ones that make signing in work:

- a **session cookie**, so the app knows it is still you between requests;
- a **CSRF token**, which protects you from a hostile site acting as you.

They are not advertising cookies, they do not track you across sites, and there is nothing to opt
into. Clearing them signs you out.

**Cloudflare** sits in front of the apps and may set its own strictly necessary cookies, most
commonly `__cf_bm` for bot management. We do not control or read those.

The marketing page at [twobots.dev](https://twobots.dev/) sets **no cookies of its own**.

## 7. How long we keep it

| What | How long |
|---|---|
| Your account and content | Until you delete it, or ask us to |
| Technical logs | **14 days**, then deleted — they rotate daily |
| Analytics (games only) | Aggregate counts, kept indefinitely; not linked to an identified person |
| Push subscriptions | Until you turn notifications off or the subscription expires |
| Email correspondence | While it remains relevant, then deleted |
| Backups | Backups are taken for operational purposes and expire on their normal cycle. Deleted content can persist in a backup until it does |

## 8. Who else can see it

**Cloudflare** — sits in front of everything as CDN and protection, so your request reaches
Cloudflare before it reaches us. It processes your IP address and keeps its own logs under its own
policy.

**Postmark** — sends transactional email for us (sign-in, address confirmations, security alerts).
It receives your email address and the content of those messages.

**Google** — where an app offers "Sign in with Google", your browser talks to Google directly to
approve it; Google then tells us your email address and an account identifier. We never receive or
see your Google password, and request nothing beyond your name and email (no access to your Drive,
Calendar, Contacts, or anything else in your Google Account). You can revoke this access any time
from your Google Account's [connected apps settings](https://myaccount.google.com/permissions).

**Push services** — where you enable push notifications, delivery goes through the push service your
browser uses, typically **Google's Firebase Cloud Messaging**, **Mozilla**, or **Apple**, depending
on your browser. They handle the delivery, not the content of your account.

**Scryfall** — the card-collection app fetches public card data and images from Scryfall so it can
show them. It is a lookup of public information; your collection is not sent there.

**People you share with.** Where an app has households or shared spaces, the people you invite can
see what you share into them. That is the feature working.

**Otherwise, only where the law requires it** — to comply with a legal obligation, or to respond to
a lawful request such as a court order or warrant, or where necessary to establish, exercise or
defend a legal claim.

**We do not sell your information to anyone, for any purpose.**

## 9. Where it is stored, and who runs it

The apps and their databases run on **hardware we own, in New Zealand**. There is no commercial
cloud provider holding your data.

Being honest about what that means: this is **self-hosted infrastructure operated by one person**,
not a data centre with staff on call. Our Terms of Use say there is no uptime guarantee, and the
same applies here — **keep your own copy of anything you cannot afford to lose**.

Cloudflare is global, so your request passes through whichever of its data centres is nearest you,
which may be outside New Zealand. Postmark and the push services likewise operate outside New
Zealand. Where personal information goes overseas, we rely on those providers' own obligations, and
we send them no more than the function requires.

## 10. Security

- Passwords are stored as a **one-way hash** — **bcrypt** or **argon2id** depending on the app —
  never as text we could read.
- Everything is served over **HTTPS**, and session cookies are marked `Secure` and `HttpOnly`.
- Sign-in forms carry CSRF protection.
- Access to the servers is restricted to us.

**What we do not claim:** no system is perfectly secure, this one is run by one person, and we
cannot guarantee that a determined attacker will never succeed. If a breach occurs that is likely to
cause you serious harm, we will notify you and the Office of the Privacy Commissioner as the Privacy
Act requires.

## 11. Your rights: access, correction and deletion

Under the **Privacy Act 2020** you may:

- **ask whether we hold personal information about you, and ask for a copy** (information privacy
  principle 6);
- **ask us to correct it** (principle 7).

You can also **ask us to delete your account and its content**, and we will, subject only to
anything the law requires us to keep and to backups expiring on their normal cycle. Where an app has
a delete-account function, using it does the same thing.

Email **[dev@twobots.dev](mailto:dev@twobots.dev)**. We will respond as soon as reasonably
practicable and within **20 working days**, as the Act requires. There is no charge.

**A practical limit worth knowing.** Technical logs are keyed to IP addresses, not to people. Unless
you can tell us the IP address and roughly when you visited, we usually cannot find those records or
confirm they are yours — and they are deleted after 14 days regardless. Analytics on the games is
aggregate and not linked to an identified person. That is a consequence of collecting as little as
we do, not a refusal to help. Your account and its content are a different matter: those we can find
and hand over.

## 12. Children

You must be at least **13 years old** to use an app that requires an account, and if you are under
18 you should use the apps only with the involvement of a parent or guardian. This matches our Terms
of Use.

Some apps are designed for households and may hold information a parent enters about their own
family, including children. That information is under the control of the adult who entered it, and
they can correct or delete it at any time.

If you believe a child has given us personal information without a parent or guardian's involvement,
email us and we will delete it.

## 13. Do Not Track and Global Privacy Control

A straight answer rather than a claimed courtesy: **technical logs and the games' analytics do not
change based on a Do Not Track or Global Privacy Control signal.** Logging happens before any such
preference could be read, and the analytics script does not check for them.

There is, however, no tracking to switch off — no advertising cookies, no cross-site identifier, no
profile, and nothing shared with an advertiser. A content blocker stops the analytics request
entirely, and every page works fully without it.

## 14. Changes to this policy

We may update this policy by posting a revised version on this page with a new effective date. Where
a change materially affects how we handle information we already hold, we will make a reasonable
effort to tell account holders directly.

## 15. Contact and complaints

Any privacy question, or a request under section 11: **[dev@twobots.dev](mailto:dev@twobots.dev)**

If you are not satisfied with how we handle it, you can complain to the **Office of the Privacy
Commissioner**: [privacy.org.nz](https://www.privacy.org.nz) ·
[enquiries@privacy.org.nz](mailto:enquiries@privacy.org.nz) · 0800 803 909

See also our **[Terms of Use](/terms/)**.
