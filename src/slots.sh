#!/bin/bash
# building customized slots using lambda functions

# read in test data required for a food validation request
echo 'begin building entree food customized slot'
cd data
request=$(<foods.json)
cd ..
#echo $request
echo 'read foods.json data object'

# invoke the lambda function and pass the foods data object
aws lambda invoke --function-name convertFoodsObjForSlot --payload "$request" output.json

# copy the array to an s3 bucket if needed for reference
aws s3 cp output.json s3://fastfoodchatbot/data/

# read response file into local variable then print on the console
response=$(<output.json)
#echo $response

# read the data object returned from the function call and use it to load the custom slot
data=$(<output.json)
aws lex-models put-slot-type --name FoodEntreeNames --checksum 9c093bf7-71f5-466a-8412-448631dbfeff --enumeration-values "$data"
echo 'complete building slot'
