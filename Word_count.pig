/*****Pig Script to count occurences of particular words*****/
/*load the input data*/
lines = LOAD '/user/cloudera/Ritvika/input_file.txt' AS (line:chararray);     
/*Convert the input data to lower case*/                  
lines_new = FOREACH lines GENERATE FLATTEN(LOWER(line)) AS line_new;
/*For every line of input, if the pattern exists pass 1 else pass 0 to the variables created for each word which is being matched*/
cnt = FOREACH lines_new GENERATE (line_new matches '.*chicago.*' ? 1:0) as chicago_cnt, (line_new matches '.*dec.*'  ? 1:0) as dec_cnt, (line_new matches '.*java.*' ? 1:0) as java_cnt, (line_new matches '.*hackathon.*' ? 1:0) as hackathon_cnt;
/*Group the variables*/
grouped = GROUP cnt ALL;
/*Calculate the total value of each of the variables calculated above for every line of input*/
total = FOREACH grouped GENERATE (chararray)SUM(cnt.chicago_cnt) AS chicago_tot, (chararray)SUM(cnt.dec_cnt) AS dec_tot, (chararray)SUM(cnt.java_cnt) AS java_tot, (chararray)SUM(cnt.hackathon_cnt) AS hackathon_tot;
/*Display Output in proper format -> (Word count)*/
outputs = FOREACH total GENERATE TOTUPLE(CONCAT('Chicago',' ',total.chicago_tot,'\n'),CONCAT('Dec',' ',total.dec_tot,'\n'),CONCAT('Java',' ',total.java_tot,'\n'),CONCAT('hackathon',' ',total.hackathon_tot)) AS out;
/*Remove extra symbols like brackets, commas, etc.*/
result = FOREACH outputs GENERATE FLATTEN(out);
/*Store the result in Output folder. A new file will be created inside this folder.*/
STORE result INTO '/user/cloudera/Word_count_output';

