import pandas as pd


##### Metadata fields #################################################################

gisaid_flu_meta_fields = "Isolate_Id,Segment_Ids,Isolate_Name,Subtype,"\
    "Lineage,Passage_History,Location,province,sub_province,Location_Additional_info,"\
    "Host,Host_Additional_info,Seq_Id (HA),Seq_Id (NA),Seq_Id (PB1),Seq_Id (PB2),"\
    "Seq_Id (PA),Seq_Id (MP),Seq_Id (NS),Seq_Id (NP),Seq_Id (HE),Seq_Id (P3),"\
    "Submitting_Sample_Id,Authors,Originating_Lab_Id,Originating_Sample_Id,"\
    "Collection_Month,Collection_Year,Collection_Date,Antigen_Character,"\
    "Adamantanes_Resistance_geno,Oseltamivir_Resistance_geno,Zanamivir_Resistance_geno,"\
    "Peramivir_Resistance_geno,Other_Resistance_geno,Adamantanes_Resistance_pheno,"\
    "Oseltamivir_Resistance_pheno,Zanamivir_Resistance_pheno,Peramivir_Resistance_pheno,"\
    "Other_Resistance_pheno,Host_Age,Host_Age_Unit,Host_Gender,Health_Status,Note,PMID"
gisaid_flu_meta_fields = gisaid_flu_meta_headers.split(',')

submitter_fields = "Authors,"

gisaid_flu_df = pd.DataFrame(columns=gisaid_flu_meta_fields)


def lab_info_template():

