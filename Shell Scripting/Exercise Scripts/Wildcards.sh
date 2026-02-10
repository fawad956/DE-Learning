--Wildcards

#! /bin/bash
cd /var/www
cp *.html /var/www-just-html

**for loop
#! /bin/bash
cd /var/www
for FILE in *.html
do
    echo "Copying $FILE"
    cp $FILE /var/www-just-html
done

