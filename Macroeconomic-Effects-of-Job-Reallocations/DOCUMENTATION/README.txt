NOTES ABOUT VACANCY INDEX AND OTHER DATA IN THE PAPER.

As pointed out by Barnichon (Building a composite Help-Wanted Index, Economics Letters, December 2010) the HWI index does not accurately reflect the amount of open vacancies in certain years because it only considers newspaper advertising and excludes online ads. The HWI index was published in print by the Conference Board between  1951m1–2008m5. The Conference Board online HWI has been available since 2005m5. Barnichon's methodology to obtain a long and consistent time series for vacancies is the following:
1. Prior to 1995, assume that there were no online ads. Thus, for the period 1951-1995, take the HWI index as a good proxy of vacancies.
2. For the period between January 1995 and May 2005, the print HWI is observable but the online HWI is not. However, Barnichon estimates the share of online advertisement and, in this way, he approximates the total amount of online ads. This allows one to make an adjustment to the HWI index for that period.
3. For the period between June 2005 and May 2008, both the print and online HWI are available. Therefore it is not difficult to construct the index.
4. After June 2008, only the online HWI is published. Barnichon estimates the share of print ads and adds this information to the index.

Details on page 2 of the paper: Building a composite Help-Wanted Index, Economics Letters, Dec 2010. Barnichon's composite HWI goes form 1995M1 to 2012M2 and is available from his website at https://sites.google.com/site/regisbarnichon/data.

We use the adjusted (composite) HWI to approximate the number of vacancies per period. The Excel file for our paper includes the quarterly average of the following series (in thousands):
1) Employment (N) (source: FRED)
2) Unemployment (U) (source: FRED)
3) Vacancies (V) (source: HWI through Barnichon)

We use the log for V,N an U, then we apply to each series the HP filter. We present graphs for both the raw and smoothed data. For the V/N ratio we just divide the total amount of vacancies by the total employment headcount and then apply the HP filter.

