# nccs-summer-2024
NASA Center for Climate Simulation Internship, Summer 2024

# Overview
This repository documents my work and accomplishments during my internship at the NASA Center for Climate Simulation (NCCS) in the Summer of 2024. My work focused on two main areas: GEOS OSU Micro-benchmarking across various supercomputing systems to evaluate MPI performance and scalability (objective-1), and conducting GEOS I/O benchmarking on Discover to compare the performance of DNB09 and DTSE01 file systems (objective-2). Objective 1 was completed in full and a paper detailing this research is included in the repository. Objective 2, which focused on benchmarking GEOS I/O on Discover, was initiated in the last two weeks of my internship and remains ongoing at NCCS. This repository includes benchmarking results, scripts, reports, and system build instructions.

# *Note: Intel MPI / Azure Issue Update

A few days before my internship ended, Intel provided a software fix for the Intel MPI issue on Azure. This issue is addressed in full detail in my paper. While this fix came after I had already completed my paper and research findings, I was able to run the necessary benchmarks just before wrapping up my internship. The results of these Azure benchmarks, along with detailed tuning summaries for all four systems, are included in the attached data. This update provides additional insights that complement the original research.

# Table of Contents
- [Objective 1: GEOS OSU Micro-benchmarking](#objective-1-geos-osu-micro-benchmarking)
- [Objective 2: GEOS I/O Benchmarking on Discover](#objective-2-geos-io-benchmarking)
- [Scripts](#scripts)
- [Reports](#reports)
- [Documentation](#documentation)

# Objective 1: GEOS OSU Micro-benchmarking
The `/benchmarks-objective-1/` directory contains the benchmarking data for GEOS OSU Micro-benchmarking.

# Objective 2: GEOS I/O Benchmarking on Discover
The `/benchmarks-objective-2/` directory contains the benchmarking data for GEOS I/O benchmarking performed on Discover.

# Scripts
The `/scripts-objective-1/` and `/scripts-objective-2/` directories include scripts I developed or utilized during my internship. Each script is documented with comments to explain its purpose and usage. All scripts used for objective-1 were built by William Woodford and manually adjusted per architecture and system specification. All scripts used for objective-2 were built by Lucas Snyder / GMAO and manually adjusted per architecture and system specification.

# Software Used
OSU Micro-benchmarks: https://github.com/forresti/osu-micro-benchmarks

MAPL: https://github.com/GEOS-ESM/MAPL/wiki/Building-and-Testing-MAPL-as-a-standalone

# Reports
The `/reports/` directory contains summaries and detailed reports.

# Documentation
The `/docs-objective-1/` and `/docs-objective-2/` directories hold build instructions and documentation.

This repository serves as a comprehensive record of my internship experience, providing insights into the tasks I completed and the knowledge I gained. I hope it can be a useful resource for anyone interested in similar work or future interns.
Feel free to explore the repository, and don't hesitate to reach out if you have any questions!
morganoliviaevans@gmail.com 
