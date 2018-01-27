# Discussion

<!-- database modelling -->
- advantages of normalized 
- disadvantages of normalized
- advantages of packed tables
- disadvantages of packed tables
- need to propose an optimized version of OMOP -> ==XT: is that the idea of flattenning the tables to improve query-ability? OMOP Analytics? technical performances == -> ==NP: indeed, precalcul most of joins so that queries are focused on one or two table instead of 5 and more ; in this case, replicating information is not a problem because it is a frozen dataset and replicated field all come from one unique field and this is then no error prone by design ==

<!-- terminology mapping-->
- athena existing standard mapping
- athena missing concepts

What else could have been done instead?
- use of automatic concept mapping processes: but their performances are not yet as good as human manual mapping.
- large community mapping: this was too early to open the work to public so that effort and direction could be kept
