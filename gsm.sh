#!/bin/bash

# define log file name
logFile='./gsm.log';

printf "Sitemap generation process started...\n\n" | tee "$logFile";

##################################################################################################

# step 1
printf "STEP 1: Parse Site Domain. Define Required Variables...\n" | tee -a "$logFile";

# parse siteDomain
defaultSiteDomain="imageaccess.com";
if [ -z "$1" ]; then
    siteDomain="$defaultSiteDomain";
else
    siteDomain="$1";
fi

parentFolder='.';
outputFile="${parentFolder}/sitemap.xml";
tempDir="${parentFolder}/temp/";

unsortedLinks="${tempDir}/unsorted-links";
sortedLinks="${tempDir}/sorted-links";

# link parameters
changeDate=$(date +"%Y-%m-%d");
changeFrequency="monthly";

printf "Done! [1/8]\n" | tee -a "$logFile";

##################################################################################################

# step 2
printf "Clearing data from previous script run...\n\n" | tee -a "$logFile";

# temp dir
if [ -d "$tempDir" ]; then
    rm -r "$tempDir";
fi

# sitemap.xml
if [ -f "$outputFile" ]; then
    rm "$outputFile";
fi

printf "Done! [2/8]\n" | tee -a "$logFile";

##################################################################################################

# step 3
printf "Creating the temporary folder...\n\n" | tee -a "$logFile";
mkdir "$tempDir";

printf "Done! [3/8]\n" | tee -a "$logFile";

##################################################################################################

# step 4
printf "Started crawling through website pages...\n\n";

# download website pages
wget "$siteDomain" --spider --recursive --level=inf --output-file="$unsortedLinks" --directory-prefix="$tempDir" --header="Accept: text/html" --header="User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:23.0) Gecko/20100101 Firefox/23.0" -e robots=off;

# sort links
grep -i URL "$unsortedLinks" | awk -F 'URL:' '{print $2}' | awk '{$1=$1};1' | awk '{print $1}' | sort -u | sed '/^$/d' > "$sortedLinks";

printf "Done! [4/8]\n" | tee -a "$logFile";
 
##################################################################################################

# step 5
printf "Creating and writing XML header to output file...\n\n" | tee -a "$logFile";

# write XML header to sitemap.xml
printf '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' > "$outputFile";

printf "Done! [5/8]\n" | tee -a "$logFile";

##################################################################################################

# step 6
printf "Filtering all found links and storing them to output file...\n\n" | tee -a "$logFile";

while read p; do
    t=$(printf "$p" | tr '[A-Z]' '[a-z]');
        case "$t" in
            */ |*.css|*.asp|*.xml|*.js|*.jpg|*.jpeg|*.png|*.pdf|*.gif|*.svg|*.swf|*.woff|*.ttf|*.webm|*.ogv|*.mp4|*.woff2|*.xlsx|*.txt|*.ico|*.zip|*.json)
                continue;
            ;;

            *)
                printf '\n\t<url>\n\t\t<loc>'$p'</loc>\n\t\t<lastmod>'$changeDate'</lastmod>\n\t\t<changefreq>'$changeFrequency'</changefreq>\n\t</url>\n' >> "$outputFile";
            ;;
        esac
done < "$sortedLinks";

printf "Done! [6/8]\n" | tee -a "$logFile";

##################################################################################################

# step 7
printf "Writing final urlset closing header...\n\n" | tee -a "$logFile";

printf "</urlset>" >> "$outputFile";

printf "Done! [7/8]\n" | tee -a "$logFile";

##################################################################################################

# remove temporary folder
printf "Clearing temporary script data...\n\n" | tee -a "$logFile";

# website folder
# if [ -d $siteDomain ]; then
#    rm -r $siteDomain;
# fi

# temp dir
# if [ -d $tempDir ]; then
#    rm -r $tempDir;
# fi

printf "Done! [8/8]\n" | tee -a "$logFile";

##################################################################################################

printf "Sitemap generation completed!\n" | tee -a "$logFile";
