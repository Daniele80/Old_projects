#install.packages("readr", repos=c("http://rstudio.org/_packages",   "http://cran.rstudio.com"));
#install.packages("vctrs", repos=c("http://rstudio.org/_packages",   "http://cran.rstudio.com"));

PATH_CSV <-"C:/Users/daniele.rocco/OneDrive - Rock/myproj/R/R/PI/";
PI_CSV <- "PI.csv";
PI_CSV_OLD <- "PI_OLD.csv";
BACKLOG_MUTUI_HST <- "bkl.csv";
OUTPUT <- "Output_test.csv";

library(readr);

PI<- read_csv(paste(PATH_CSV,PI_CSV,sep=""));
PI$Report_Date      <- Sys.Date();

no_tribe <- nrow(subset(PI, state == 'Next Development' & u_supplier_group == 'Rock' & (is.na(u_assign_to_tribe))));
customer_interactions <- nrow(subset(PI, state == 'Next Development' & u_supplier_group == 'Rock'& u_assign_to_tribe == 'Customer Interactions'));
daily_banking <- nrow(subset(PI, state == 'Next Development' & u_supplier_group == 'Rock'& u_assign_to_tribe == 'Daily Banking'));
data_management <- nrow(subset(PI, state == 'Next Development' & u_supplier_group == 'Rock'& u_assign_to_tribe == 'Data Management'));
digital <- nrow(subset(PI, state == 'Next Development' & u_supplier_group == 'Rock' & u_assign_to_tribe == 'Digital'));
investment_and_savings <- nrow(subset(PI, state == 'Next Development' & u_supplier_group == 'Rock'& u_assign_to_tribe == 'Investment & Savings'));
lending_and_protection <- nrow(subset(PI, state == 'Next Development' & u_supplier_group == 'Rock' & u_product != 'Mutuo Verde'
                                      & u_assign_to_tribe == 'Lending & Protection' & u_assign_to_squad != 'Protection'));
acn_tot <- no_tribe + customer_interactions + daily_banking + data_management + digital+ investment_and_savings + lending_and_protection;


# Ready for UAT senza rd
rfu_nord_n  <- nrow(subset(PI, state == 'Ready for UAT'  & u_product != 'Mutuo Verde'  & u_product != 'mutuo_Verde' 
                           & (u_assign_to_squad != 'Protection' | is.na(u_assign_to_squad) )
                           & u_supplier_group == 'Rock' &  (is.na(u_change_release_date))));
# Ready for Prod OK
rfp_n       <- nrow(subset(PI, state == 'Ready for Prod' & u_product != 'Mutuo Verde'  & u_product != 'mutuo_Verde' 
                           & u_assign_to_squad != 'Protection' & u_supplier_group == 'Rock'));
# On hold
o_h_n<- nrow(subset(PI, state == 'On Hold' & u_product != 'Mutuo Verde'  
                    & u_assign_to_squad != 'Protection' & u_supplier_group == 'Rock'));

# inserire file t-1
PI_OLD <- read_csv(paste(PATH_CSV,PI_CSV_OLD,sep=""));
PI_OLD$Report_Date      <- Sys.Date()-1;

PI_NEW_VS_OLD <- merge(PI_OLD, PI, by="number", all = TRUE) ;

REPORT <- subset(PI_NEW_VS_OLD, 
          select = c("number","Report_Date.x","state.x","Report_Date.y", "state.y", "u_analyst.x","u_assigned_to_user.x"));

# Assegnate
assegnate   <- nrow(subset(REPORT, state.x != 'Next Development'& state.y == 'Next Development'));
# Lavorate
lavorate   <- nrow(subset(REPORT, state.x != 'Ready for UAT' & state.y == 'Ready for UAT'));


# storico 
bkl_mutui <- read_csv(paste(PATH_CSV,OUTPUT,sep=""));
dim<-nrow(bkl_mutui);
old_lavorate<-bkl_mutui[dim,13];

date_now <- format(Sys.Date(),"%d/%m/20%y");
de<-data.frame(date_now,no_tribe,customer_interactions,daily_banking,data_management,digital,investment_and_savings,
               lending_and_protection,acn_tot,acn_tot, lavorate,assegnate,lavorate+old_lavorate,rfu_nord_n,rfp_n,o_h_n);
det~Totali_Lavorate;  

names(de)<-names(bkl_mutui);
newdf <- rbind(bkl_mutui,de);

write.csv(newdf, file = paste(PATH_CSV,OUTPUT,sep=""),row.names=FALSE);
OUT_DF <- read_csv(paste(PATH_CSV,OUTPUT,sep=""));

##
##