## Preparing the Transactional Data

The file PaySim_TransFraud.csv was dowloaded from [Kaggle][KagglePaySim]

It has 6.362.621 records (including the header) and weights 471Mb. I split it into two files:
* training_set.csv (500K records with 37Mb) - this will be pre-loaded into the IRIS DB instance and will be used to train the model. We will consider it as past data. 
* testing_set.csv (10K records with 751Kb) - this will be available on the disk of IRIS INT instance and will be used run the demo.

Here are the commands I used to do this on the shell:

``` shel 
head -n 500001 ./PaySim_TransFraud.csv >> training_set.csv
head -n 1 ./PaySim_TransFraud.csv >> testing_set.csv
tail -n +500002 ./PaySim_TransFraud.csv | head -n 10000 >> testing_set.csv
wc -l training_set.csv
  500001 training_set.csv
wc -l testing_set.csv
   10001 testing_set.csv
head -n 2 ./training_set.csv
step,type,amount,nameOrig,oldbalanceOrg,newbalanceOrig,nameDest,oldbalanceDest,newbalanceDest,isFraud,isFlaggedFraud
1,PAYMENT,9839.64,C1231006815,170136.0,160296.36,M1979787155,0.0,0.0,0,0

head -n 2 ./testing_set.csv
step,type,amount,nameOrig,oldbalanceOrg,newbalanceOrig,nameDest,oldbalanceDest,newbalanceDest,isFraud,isFlaggedFraud
20,TRANSFER,115755.54,C2082926317,0.0,0.0,C1974060990,1919834.28,2035589.82,0,0
```

The atelier project "fin-fraud-irisdb-atelier-project" in IRIS DB instance has several classes including:
* IRISConfig.Installer - This class is run when the image is built. It will call method *LoadTransactionalData* to load training_set.csv into table IRISDemo.MobileTransaction
* IRISDemo.MobileTransaction - This is the table that will hold the transactional data. It points to an Account table as well.

## Creating the IRISDemo.MobileTransaction class

I used "x. PayTrans - Data Load" Spark notebook on Zeppelin to load the data to a temporary table called "TempPackage.Trans". 
I did't want to loose time trying to figure out the data types. This notebook is from our Financial Services Spark Experience
and I wanted to reuse as much as possible of their work (thank you!).

I then created the class IRISDemo.MobileTransaction using Atelier connected to my local running fin-fraud-irisdb_1 container. As the source
code is outside of the container, that is on github for you to [see](). I brought all properties, excpet step. I will transform
step into a real date and time. Accordingly to [field descriptions on kaggle][KagglePaySim], one step is 1 hour in time.

I have discarded column IsFlaggedFraud because there were just a few (6) records on the entire dataset with this flag on. 
I have also renamed some columns (ToAccount, FromAccount, etc) and created a more normalized data model with an Account 
table that holds the current Balance of that account given all the transactions made so far.

This class has a class method called CreateTransaction. It is used on two situations:

* It is exposed as a stored procedure to be called by IRIS Interoperability when new transactions are coming in.
* It is called by another method on the same class, called LoadDataFromCSVFile() to load the training_set.csv file


[KagglePaySim]: https://www.kaggle.com/ntnu-testimon/paysim1