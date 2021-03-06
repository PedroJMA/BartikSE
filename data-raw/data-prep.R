## Use Matlab Code/Code Construction and Test/DataReplication_v2.xlsx Jul 24 12:45
## Use Simulatuions with US CZs/DataADH_check.xlsx from June 1, 2018 for additional outcomes

## 1444 observations (722 regions in 1990-2000 and 2000-2007), and 770 sectors
## (a sector emp share interacted with the period)
d <- readxl::read_excel("DataReplication_v2.xlsx", sheet=2)
ctrls <- readxl::read_excel("DataReplication_v2.xlsx", sheet=3)

## weight matrix and SIC codes
sic <- readxl::read_excel("DataReplication_v2.xlsx", sheet=5)$sec_vec
ADH_W <- unname(as.matrix(readxl::read_excel("DataReplication_v2.xlsx",
                                             sheet=4, col_names=TRUE))[, -1])

## Add some other outcomes
d1 <- readxl::read_excel("DataADH_check.xlsx", sheet=1)
ADH <- cbind(d, d1[, c("d_sh_empl", "d_sh_empl_nmfg")], ctrls[, -c(1, 2, 3)])

ADH$division <-  2*ADH$reg_midatl + 3*ADH$reg_encen + 4*ADH$reg_wncen +
    5*ADH$reg_satl+ 6*ADH$reg_escen + 7*ADH$reg_wscen + 8*ADH$reg_mount +
    9*ADH$reg_pacif
ADH$division[ADH$division==0] <-  1     # New England
ADH$division <- as.factor(ADH$division)
ADH$t2 <- ADH$t2==1

ADH1 <- ADH[, c("d_sh_empl", "d_sh_empl_mfg", "d_sh_empl_nmfg",
                "d_tradeusch_pw", "d_tradeotch_pw_lag", "timepwt48", "statefip",
                "czone", "t2", "l_shind_manuf_cbp", "l_sh_popedu_c",
                "l_sh_popfborn", "l_sh_empl_f", "l_sh_routine33",
                "l_task_outsource", "division")]

names(ADH1)[4:7] <- c("shock", "IV", "weights", "statefip")

## Combine all into one object
ADH <- list(reg=ADH1, sic=sic, W=ADH_W)

devtools::use_data(ADH, overwrite=TRUE, internal=FALSE)
