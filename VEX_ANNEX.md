# Annexe VEX — Vulnérabilités critiques non corrigeables

**Image :** `erpnext-poc-crm:v16-fixed2` · **Re-scan :** 2026-08-20
**Format machine :** [`vex.cdx.json`](sbom-image-final/vex.cdx.json) (CycloneDX VEX)

> **Statut global : aucune des 8 CVE n'est exploitée dans la nature.**
> Vérifié le 2026-08-20 contre le catalogue **CISA KEV** (Known Exploited Vulnerabilities) : **0/8**.
> Scores **EPSS** (probabilité d'exploitation à 30 j) : tous faibles — max **3,18 %** (zlib),
> les 7 autres **sous 0,6 %**.

Cette annexe traite les **8 vulnérabilités critiques subsistant après correction** de l'image.
**Toutes** sont des paquets **Debian bookworm sans correctif amont** (`NO-FIX`) : il est
techniquement impossible de les patcher localement tant que Debian n'a pas publié de correctif.
Chaque entrée porte un statut VEX justifié à partir de la configuration réelle du conteneur.

---

## Ce qui a changé depuis le premier scan

Le re-scan (base de vulnérabilités à jour) a fait bouger le paysage :

- **+6 CVE critiques Chromium** (CVE-2026-17651 à 17656) apparues entre-temps → **corrigées** par
  `apt upgrade` (Chromium 150 → 151). Elles ne figurent plus dans l'image.
- **tar 7.5.1 (CVE-2026-59873)** : un correctif amont existe désormais (7.5.19). tar était embarqué
  dans **npm** (outil de build, hors runtime) → **retiré de l'image**. Ce critique a donc disparu.
- **Résultat** : la seule CVE critique qui disposait d'un correctif a été traitée ; **les 8 restantes
  n'ont aucun correctif disponible**.

---

## Synthèse

| CVE | Paquet | EPSS | CISA KEV | Correctif amont | Statut VEX |
|-----|--------|-----:|:--------:|:---------------:|-----------|
| CVE-2023-45853 | zlib1g | 3,18 % | non | aucun | `not_affected` — code absent |
| CVE-2026-58016 | libglib2.0-0 | 0,55 % | non | aucun | `not_affected` — code non atteignable |
| CVE-2025-7458 | libsqlite3-0 | 0,24 % | non | aucun | `in_triage` — surveillé |
| CVE-2026-13221 | perl-modules-5.36 | 0,43 % | non | aucun | `in_triage` — surveillé |
| CVE-2026-42496 | perl-modules-5.36 | 0,43 % | non | aucun | `in_triage` — surveillé |
| CVE-2026-57433 | perl-modules-5.36 | 0,36 % | non | aucun | `in_triage` — surveillé |
| CVE-2026-8376 | perl-modules-5.36 | 0,44 % | non | aucun | `in_triage` — surveillé |
| CVE-2026-6653 | libxml2 | 0,36 % | non | aucun | `in_triage` — surveillé |

---

## Détail par vulnérabilité

### Non affecté (justifié)

**CVE-2023-45853 — zlib1g** · débordement de tas (MiniZip)
`not_affected` / *code_not_present*. La faille est dans **MiniZip** (composant *contrib*), **non
compilé** dans la bibliothèque partagée `libz` de Debian. Debian classe `zlib1g` comme non affecté.

**CVE-2026-58016 — libglib2.0-0** · sous-débordement d'entier (introspection D-Bus)
`not_affected` / *code_not_reachable*. Le code vulnérable (`gdbusintrospection`) concerne D-Bus,
**non utilisé** dans le conteneur (aucun bus D-Bus au runtime).

### En triage — surveillés (aucun correctif amont)

Présents au runtime mais **sans patch Debian disponible à ce jour**. Réponse : `update` dès publication
amont ; **re-scan mensuel**.

**CVE-2025-7458 — libsqlite3-0** · débordement d'entier SQLite
SQLite **n'est pas** la base applicative (MariaDB l'est). Reachability faible (outillage interne),
pas d'entrée SQL non fiable exposée.

**CVE-2026-13221 / 42496 / 57433 / 8376 — perl-modules-5.36** · regex incorrectes, traversée
archive-tar, débordement Storable, débordement de tas regex
Perl est **hors du chemin de requête applicatif** (scripts système). Exploitation nécessite une
**entrée locale malveillante** (regex / archive / données sérialisées forgées) — pas de surface
exposée côté application.

**CVE-2026-6653 — libxml2** · DoS via XML forgé
Atteignable **uniquement** si l'application parse du XML non fiable. Impact = déni de service
(pas d'exécution de code). Surveillé.

---

## Note méthodologique

Ces évaluations VEX sont **préliminaires** et fournies pour accélérer la revue ; les statuts
`not_affected` reposent sur la configuration réelle du conteneur (pas de D-Bus, MariaDB comme SGBD)
et doivent être **validés par l'équipe sécurité**. Les données EPSS (first.org) et CISA KEV sont
datées du **2026-08-20** et évoluent — à réévaluer au re-scan.
