# Structure of the Demo

This demo shows how to combine distinct IRIS services to build a mobile banking application with intelligent interoperability:

* banking_core - Is a service that reproduces the basic functionality of a core checking account banking system. It is based on IRIS Database and exposes SOAP services to be consumed by the banking_trn_srv service.
* banking_trn_srv - Is a service that will receive REST requests from the mobile application and filter them to avoid frauds. If a request is genuine, it will be passsed to the banking_core service to be processed. This is based on IRIS Interoperability. Successful transactions will also be sent to the normalized_datalake service.
* normalized_datalake - This is where data from several applications on the organization is stored in a normalized, SQL accessible, way. This is based on IRIS Database. We would use sharding for this, but this is a demo so we have restricted it to a single instance.
* advanced_analytics - This service includes a Zeppelin notebook with a spark cluster, all in a single image. The correct thing to do would be to have an instance/image for Zeppelin and a set of instances/images for the Spark cluster. But as this is a demo, we have combined both on a single image so it won't require a lot of resources. This will be used to explore the data on the normalized data lake using Spark and/or JDBC using Zeppelin.

# Baking Core (banking_core)

This service is based on irisdemodb image.

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

I have removed PaySim_TransFraud.csv from the Git repository because it was too big. But you can download it again [here](KagglePaySim).

The atelier project "bankingcore-atelier-project" in *banking_core* instance has several classes including:
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

## Exposing the SOAP Service

As this is suposedly a legacy system inside the organization, this service exposes its functionality through SOAP.

The service WSDL is available on:

http://localhost:9090/csp/app/soap//IRISDemo.SOAP.TransactionServices.cls?wsdl=1

The class IRISDemo.SOAP.TransactionServices tries to suggest good practices on handling and reporting errors to the caller.

This service will be callled by the banking_trn_srv service.

We are using the default CSP application for SOAP services created by the base image irisdemoint. It will require basic authentication and the SuperUser/sys password should be used. On real world scenarios, each SOAP service should have its own CSP application, with Permitted Classes configured to limit the application to the class of the service. Also, it should either require SSL or be configured with a SOAP Security Config to require other mechanisms of security such as encryption/signing of the body, header, etc.

# Baking Transactional Services (banking_trn_srv)

This service is based on irisdemoint image. It will expose a REST service on /csp/appint/rest/ CSP application so that a mobile APP can send transactions. These transactions will be evaluated in real time and, if valid, the service will call the SOAP service on the core banking system to process them.

You can look at the production here:

http://localhost:9092/csp/appint/EnsPortal.ProductionConfig.zen?$NAMESPACE=APPINT

## Creating the Banking Core Transaction Operation

This Business Operation was created by using IRIS Interoperability SOAP assistant add-on. It is completely generated based on the WSDL of the service.

I have added it to the production and configured it with the BankingCore credential. This credential is automatically created by our IRISConfig.Installer manifest. After configuring these settings, I went back to Atelier and did a dummy change on my production class just for it to show me a conflict when trying to save my production class. I then chose to keep the *server* version of it so it could be saved outsife of the container and on GitHub.

## Creating the Banking Transaction Service

As this production is based on irisdemoint image, there is a CSP application named /csp/appint/rest that is already configured with the EnsLib.REST.Dispatcher REST dispatcher. Our new BankingSrv.Transaction.Service REST service class will inherit from this class.

This CSP application requires authentication too. So, when calling this REST service, you should use Basic HTTP authentication.

I installed on my Eclipse a Plugin called [http4e](http://www.nextinterfaces.com/http4e-eclipse/eclipse-restful-http-client-plugin-install/). This plugin allows me to send quick test REST calls to my new service. I had to add the following HTTP headers on my REST calls to be correctly authenticated:

``` YAML
Content-Type=application/json; charset=utf-8
Authorization=Basic U3VwZXJVc2VyOnN5cw==
```

The Base64 code above was generated as follows:

```
USER>Write $System.Encryption.Base64Encode("SuperUser:sys")
U3VwZXJVc2VyOnN5cw==
```

