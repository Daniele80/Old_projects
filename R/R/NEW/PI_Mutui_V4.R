#install.packages("readr", repos=c("http://rstudio.org/_packages",   "http://cran.rstudio.com"));
#install.packages("vctrs", repos=c("http://rstudio.org/_packages",   "http://cran.rstudio.com"));

PATH_CSV <-"C:/Users/daniele.rocco/OneDrive - Rock/myproj/R/R/NEW/";
PI_MUTUI_CSV <- "PI_Mutui.csv";
PI_MUTUI_CSV_OLD <- "PI_Mutui_OLD.csv";
BACKLOG_MUTUI_HST <- "bkl_mutui.csv";
OUTPUT <- "Output_test.csv";

library(readr);

PI_MUTUI <- read_csv(paste(PATH_CSV,PI_MUTUI_CSV,sep=""));
PI_MUTUI$Report_Date      <- Sys.Date();

# estrazione dataframe
# in analisi
a_n       <- nrow(subset(PI_MUTUI, state == 'Analysis'));
# in analisi ACN
a_acn_n   <- nrow(subset(PI_MUTUI, state == 'Analysis'& u_analyst == 'user_reporter'));
# in analisi ING
a_ing_n   <- nrow(subset(PI_MUTUI, state == 'Analysis'& u_analyst != 'user_reporter'& u_type != 'S/R'));
# Aperte
o_n         <- nrow(subset(PI_MUTUI, state == 'Open' & u_type != 'S/R'));
# Aperte
o_acn_n     <- nrow(subset(PI_MUTUI, state == 'Open'&& u_analyst == 'user_reporter'));
# In Lavorazione --> FIX assegnazione ACN
nd_n        <- nrow(subset(PI_MUTUI, state == 'Next Development'& u_supplier_group == 'Rock'));
# Ready for UAT senza rd
rfu_n       <- nrow(subset(PI_MUTUI, state == 'Ready for UAT'));
# Ready for UAT senza rd
rfu_nord_n  <- nrow(subset(PI_MUTUI, state == 'Ready for UAT' & (is.na(u_change_release_date))));
# Ready for Prod
rfp_n       <- nrow(subset(PI_MUTUI, state == 'Ready for Prod'));
# On hold
o_h_n       <- nrow(subset(PI_MUTUI, state == 'On Hold'));
# Chiuse
c_n         <- nrow(subset(PI_MUTUI, state == 'Closed'));


# inserire file t-1
PI_MUTUI_OLD <- read_csv(paste(PATH_CSV,PI_MUTUI_CSV_OLD,sep=""));
PI_MUTUI_OLD$Report_Date      <- Sys.Date()-1;

PI_MUTUI_NEW_VS_OLD <- merge(PI_MUTUI_OLD, PI_MUTUI, by="number", all = TRUE) ;

REPORT <- subset(PI_MUTUI_NEW_VS_OLD, 
          select = c("number","Report_Date.x","state.x","Report_Date.y", "state.y", "u_analyst.x","u_assigned_to_user.x"));

# Assegnate
assegnate   <- nrow(subset(REPORT, state.x != 'Next Development'& state.y == 'Next Development'));
# Lavorate
lavorate   <- nrow(subset(REPORT, state.x != 'Ready for UAT' & state.y == 'Ready for UAT'));


# storico 
bkl_mutui <- read_csv(paste(PATH_CSV,OUTPUT,sep=""));
dim<-nrow(bkl_mutui);
old_lavorate<-bkl_mutui[dim,8];

date_now <- format(Sys.Date(),"%d/%m/20%y");
de<-data.frame(date_now,o_acn_n,a_acn_n,nd_n,lavorate,assegnate,a_ing_n+o_n,old_lavorate+lavorate,rfu_nord_n,rfp_n,o_h_n);
det~Totali_Lavorate;  

names(de)<-names(bkl_mutui);
newdf <- rbind(bkl_mutui,de);

write.csv(newdf, file = paste(PATH_CSV,OUTPUT,sep=""),row.names=FALSE);
OUT_DF <- read_csv(paste(PATH_CSV,OUTPUT,sep=""));

##
##