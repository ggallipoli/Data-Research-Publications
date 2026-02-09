# CLAUDE.md — AI Assistant Guide

## Repository Overview

This is an **academic research data repository** maintained by Giovanni Gallipoli (University of British Columbia). It contains replication datasets and code for 16 peer-reviewed economics publications spanning 2012–2026, published in top journals (AER, JPE, REStud, JOLE, JIE, RED, JME, CJE, QE).

**Purpose:** Public archive for research transparency and reproducibility.

**Repository URL:** https://github.com/ggallipoli/Data-Research-Publications

## Project Structure

```
Data-Research-Publications/
├── README.md                          # Index of all 16 publications with links
├── CLAUDE.md                          # This file
├── *.txt                              # Standalone text files for some papers
├── Gallipoli_Low_Mitra_JOLE2026       # Newest publication reference
│
├── Skill-Dispersion-and-Trade-Flows/           # AER 2012
├── Education-and-Crime-over-the-Life-Cycle/    # REStud 2014
├── Unobservable-Skill-Dispersion-.../          # JIE 2014
├── Macroeconomic-Effects-of-Job-Reallocations/ # REA 2013
├── Ability-Parental-Valuation-of-.../          # JHR 2014
├── Human-Capital-Spill-Overs-.../              # RED 2017
├── The-Costs-of-Occupational-Mobility-.../     # JEEA 2018
├── Structural-Transformation-.../              # JME 2018
├── Markov-Chain-Approximations-for-Life-Cycle/ # RED 2019
├── LippiPerri_exercise/                        # JME 2023
├── replication-code - JOLE 2023 FIRMS/         # JOLE 2025
└── Permanent-Income-Inequality                 # QE 2022 (reference)
```

Several publications host their data externally on Dropbox (items 10–13, 16) due to size constraints.

### Per-Project Directory Convention

Most project directories follow this layout:

```
ProjectName/
├── DATA SETS/
│   ├── Data/         # Stata .dta files, CSVs, raw data
│   ├── Code/         # Analysis scripts (.do, .py, .m, .R)
│   └── RawData/      # Original source data
└── DOCUMENTATION/
    ├── README.txt    # Replication instructions
    └── (appendices)
```

## Languages and Tools

| Language   | Prevalence | Usage                              |
|------------|------------|------------------------------------|
| **Stata**  | ~70%       | Primary statistical analysis       |
| **Matlab** | ~40%       | Econometric estimation, figures    |
| **R**      | ~30%       | Statistical analysis, processing   |
| **Python** | 2 projects | Network analysis, firm estimation  |
| **Fortran**| 1 project  | Numerical computation (Markov)     |
| **LaTeX**  | 1 project  | Document preparation               |

## No Build System, Tests, CI/CD, or Linting

This repository has **no**:
- Package manager or build system
- Automated test suite
- CI/CD pipelines
- Linting or formatting configuration
- `.gitignore` file

Validation is done by running replication scripts and comparing output to published tables/figures.

## Key Project-Specific Notes

### JOLE 2023 FIRMS (`replication-code - JOLE 2023 FIRMS/`)
- Python dependencies: numpy, scipy, pandas, matplotlib, networkx
- Stata 17MP required
- Pipeline: `finalsample.do` → `networkconstruction.py` → `groupedanalysis.do` → `firmestimation.py`
- Originally run on Statistics Sweden's MONA secure server (40 threads, 500 GB RAM)

### Markov-Chain Approximations (`Markov-Chain-Approximations-for-Life-Cycle/`)
- Requires Intel Fortran compiler + Intel MKL library
- R >= 3.3 with packages: data.table, statar
- Interactive parameter selection at runtime (mode, rho, method, nygrid)
- Code archived in `FGP_all_code.zip`

### Projects with External Data
Publications 10 (JPE 2019), 11 (LE 2020), 12 (CJE 2021), 13 (QE 2022), and 16 (JOLE 2026) host datasets on Dropbox. Links are in the root README.md.

## Conventions for AI Assistants

1. **Do not modify data files** (`.dta`, `.csv`, `.xlsx`). These are published replication datasets.
2. **Do not modify analysis scripts** without explicit instruction. Published code must match journal supplements.
3. **README.md** is the primary index — keep it consistent with the numbered publication list format when editing.
4. **New publications** should be added to README.md following the existing format:
   ```
   N. **Title**, [Data and Code](link), [Paper](link) <br/>
   *Authors* <br/>
   Journal, Vol.X, pages, Year
   ```
5. **Directory naming** uses hyphens between words matching the paper title.
6. **Confidential data** — some projects use restricted-access microdata (e.g., Swedish SCB registers, NLSY, PSID). These cannot be distributed and are noted in project READMEs.
7. **Large files** — the repo is ~345 MB. Some datasets are hosted externally on Dropbox to stay within GitHub limits.
