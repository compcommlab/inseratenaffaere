# 1a_paragraphs_politicians.R

```R
R version 4.3.1 (2023-06-16)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 20.04.6 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0 
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
 [3] LC_TIME=de_AT.UTF-8        LC_COLLATE=en_US.UTF-8    
 [5] LC_MONETARY=de_AT.UTF-8    LC_MESSAGES=en_US.UTF-8   
 [7] LC_PAPER=de_AT.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=de_AT.UTF-8 LC_IDENTIFICATION=C       

time zone: Europe/Vienna
tzcode source: system (glibc)

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] did_2.1.2   DRDID_1.0.6 dplyr_1.1.2

loaded via a namespace (and not attached):
 [1] Matrix_1.5-4      trust_0.1-8       gtable_0.3.3      jsonlite_1.8.7   
 [5] compiler_4.3.1    ggsignif_0.6.4    tidyselect_1.2.0  Rcpp_1.0.10      
 [9] parallel_4.3.1    tidyr_1.3.0       scales_1.2.1      lattice_0.21-8   
[13] ggplot2_3.4.2     R6_2.5.1          ggpubr_0.6.0      generics_0.1.3   
[17] backports_1.4.1   tibble_3.2.1      car_3.1-2         munsell_0.5.0    
[21] lubridate_1.9.2   pillar_1.9.0      rlang_1.1.1       utf8_1.2.3       
[25] broom_1.0.5       timechange_0.2.0  cli_3.6.1         withr_2.5.0      
[29] magrittr_2.0.3    grid_4.3.1        BMisc_1.4.5       lifecycle_1.0.3  
[33] vctrs_0.6.3       rstatix_0.7.2     glue_1.6.2        data.table_1.14.9
[37] abind_1.4-5       carData_3.0-5     fansi_1.0.4       colorspace_2.1-0 
[41] purrr_1.0.1       pkgconfig_2.0.3  
```

# 1b_paragraphs_parties.R

```r
R version 4.3.1 (2023-06-16)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 20.04.6 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0 
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
 [3] LC_TIME=de_AT.UTF-8        LC_COLLATE=en_US.UTF-8    
 [5] LC_MONETARY=de_AT.UTF-8    LC_MESSAGES=en_US.UTF-8   
 [7] LC_PAPER=de_AT.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=de_AT.UTF-8 LC_IDENTIFICATION=C       

time zone: Europe/Vienna
tzcode source: system (glibc)

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] did_2.1.2   DRDID_1.0.6 dplyr_1.1.2

loaded via a namespace (and not attached):
 [1] Matrix_1.5-4      trust_0.1-8       gtable_0.3.3      jsonlite_1.8.7   
 [5] compiler_4.3.1    ggsignif_0.6.4    tidyselect_1.2.0  Rcpp_1.0.10      
 [9] parallel_4.3.1    tidyr_1.3.0       scales_1.2.1      lattice_0.21-8   
[13] ggplot2_3.4.2     R6_2.5.1          ggpubr_0.6.0      generics_0.1.3   
[17] backports_1.4.1   tibble_3.2.1      car_3.1-2         munsell_0.5.0    
[21] lubridate_1.9.2   pillar_1.9.0      rlang_1.1.1       utf8_1.2.3       
[25] broom_1.0.5       timechange_0.2.0  cli_3.6.1         withr_2.5.0      
[29] magrittr_2.0.3    grid_4.3.1        BMisc_1.4.5       lifecycle_1.0.3  
[33] vctrs_0.6.3       rstatix_0.7.2     glue_1.6.2        data.table_1.14.9
[37] abind_1.4-5       carData_3.0-5     fansi_1.0.4       colorspace_2.1-0 
[41] purrr_1.0.1       pkgconfig_2.0.3  
```

# 2a_sentiment_politicians.R

```R
R version 4.3.1 (2023-06-16)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 20.04.6 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0 
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
 [3] LC_TIME=de_AT.UTF-8        LC_COLLATE=en_US.UTF-8    
 [5] LC_MONETARY=de_AT.UTF-8    LC_MESSAGES=en_US.UTF-8   
 [7] LC_PAPER=de_AT.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=de_AT.UTF-8 LC_IDENTIFICATION=C       

time zone: Europe/Vienna
tzcode source: system (glibc)

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] did_2.1.2   DRDID_1.0.6 dplyr_1.1.2

loaded via a namespace (and not attached):
 [1] Matrix_1.5-4      trust_0.1-8       gtable_0.3.3      jsonlite_1.8.7   
 [5] compiler_4.3.1    ggsignif_0.6.4    tidyselect_1.2.0  Rcpp_1.0.10      
 [9] parallel_4.3.1    tidyr_1.3.0       scales_1.2.1      lattice_0.21-8   
[13] ggplot2_3.4.2     R6_2.5.1          ggpubr_0.6.0      generics_0.1.3   
[17] backports_1.4.1   tibble_3.2.1      car_3.1-2         munsell_0.5.0    
[21] lubridate_1.9.2   pillar_1.9.0      rlang_1.1.1       utf8_1.2.3       
[25] broom_1.0.5       timechange_0.2.0  cli_3.6.1         magrittr_2.0.3   
[29] grid_4.3.1        BMisc_1.4.5       lifecycle_1.0.3   vctrs_0.6.3      
[33] rstatix_0.7.2     glue_1.6.2        data.table_1.14.9 abind_1.4-5      
[37] carData_3.0-5     fansi_1.0.4       colorspace_2.1-0  purrr_1.0.1      
[41] pkgconfig_2.0.3  
```

# 2b_sentiment_parties.R

```R
R version 4.3.1 (2023-06-16)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 20.04.6 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.9.0 
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.9.0

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
 [3] LC_TIME=de_AT.UTF-8        LC_COLLATE=en_US.UTF-8    
 [5] LC_MONETARY=de_AT.UTF-8    LC_MESSAGES=en_US.UTF-8   
 [7] LC_PAPER=de_AT.UTF-8       LC_NAME=C                 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C            
[11] LC_MEASUREMENT=de_AT.UTF-8 LC_IDENTIFICATION=C       

time zone: Europe/Vienna
tzcode source: system (glibc)

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] did_2.1.2   DRDID_1.0.6 dplyr_1.1.2

loaded via a namespace (and not attached):
 [1] Matrix_1.5-4      trust_0.1-8       gtable_0.3.3      jsonlite_1.8.7   
 [5] compiler_4.3.1    ggsignif_0.6.4    tidyselect_1.2.0  Rcpp_1.0.10      
 [9] parallel_4.3.1    tidyr_1.3.0       scales_1.2.1      lattice_0.21-8   
[13] ggplot2_3.4.2     R6_2.5.1          ggpubr_0.6.0      generics_0.1.3   
[17] backports_1.4.1   tibble_3.2.1      car_3.1-2         munsell_0.5.0    
[21] lubridate_1.9.2   pillar_1.9.0      rlang_1.1.1       utf8_1.2.3       
[25] broom_1.0.5       timechange_0.2.0  cli_3.6.1         magrittr_2.0.3   
[29] grid_4.3.1        BMisc_1.4.5       lifecycle_1.0.3   vctrs_0.6.3      
[33] rstatix_0.7.2     glue_1.6.2        data.table_1.14.9 abind_1.4-5      
[37] carData_3.0-5     fansi_1.0.4       colorspace_2.1-0  purrr_1.0.1      
[41] pkgconfig_2.0.3 
```