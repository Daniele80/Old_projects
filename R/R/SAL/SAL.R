install.packages("readxl");

require(readxl);

PATH_XLS <-"C:/Users/daniele.rocco/OneDrive - Rock/myproj/R/R/SAL/";
PI_XLS <- "u_production_issue.xlsx";
#PI_INT_XLS <- "Dashboard_PI.xlsx";
PI_INT_XLS <- "Applicativo_Elenco_PI.xlsx";

df_snow <- read_excel(paste(PATH_XLS,PI_XLS,sep=""));
df_int <- read_excel(paste(PATH_XLS,PI_INT_XLS,sep=""),sheet="Dashboard PI");
#df_int <- read_excel(paste(PATH_XLS,PI_INT_XLS,sep=""));

#df_merged <- merge(df_snow, df_int, by.df_snow = "Number", by.df_int="PI" ) ;
#df_merged <- merge(df_snow, df_int) ;
df_merged <- merge(df_snow, df_int, by ="Number", ALL=TRUE ) ;



a_n       <- nrow(subset(df_merged, state == 'Analysis'));
# in analisi ACN
a_acn_n   <- nrow(subset(df_merged, state == 'Analysis'& u_analyst == 'user_reporter'));
# in analisi ING
a_ing_n   <- nrow(subset(df_merged, state == 'Analysis'& u_analyst != 'user_reporter'& u_type != 'S/R'));
# Aperte
o_n         <- nrow(subset(df_merged, state == 'Open' & u_type != 'S/R'));
# Aperte
o_acn_n     <- nrow(subset(df_merged, state == 'Open'&& u_analyst == 'user_reporter'));
# In Lavorazione --> FIX assegnazione ACN
nd_n        <- nrow(subset(df_merged, state == 'Next Development'& u_supplier_group == 'Rock'));
# Ready for UAT senza rd
rfu_n       <- nrow(subset(df_merged, state == 'Ready for UAT'));
# Ready for UAT senza rd
rfu_nord_n  <- nrow(subset(df_merged, state == 'Ready for UAT' & (is.na(u_change_release_date))));
# Ready for Prod
rfp_n       <- nrow(subset(df_merged, state == 'Ready for Prod'));
# On hold
o_h_n       <- nrow(subset(df_merged, state == 'On Hold'));
# Chiuse
c_n         <- nrow(subset(df_merged, state == 'Closed'));



#nf <-paste(PATH_XLS,PI_INT_XLS,sep="");