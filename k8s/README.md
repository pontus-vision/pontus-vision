
# Kubernetes Instructions

To run the Pontus Vision LGPD / GDPR platform from kubernetes, please follow the instructions below:
1) go to the k8s folder (the same directory as this README.md file)
2) Create the secrets file structure (see Secret Files) below
3) run the start-env script:
```
 ./start-env.sh
```
4) to reduce the memory footprint, after about 30 seconds, run the following command:
```
./stop-discovery.sh
```
5) to see the logs, run the tail-logs.sh command:
```
./tail-logs.sh
```
6) to login, go to the following URL  (note: DO NOT FORGET the / at the end):
```
http://localhost:18443/grafana/  
```
7) Use the user name lmartins@pontusnetworks.com and the default password pa55word

## Secret Files
Please create a directory structure similar to the following:
```
secrets/
├── env
│   ├── pontus-grafana
│   │   └── GF_PATHS_CONFIG
│   ├── pontus-graphdb
│   │   ├── AWS_ACCESS_KEY_ID
│   │   ├── AWS_SECRET_ACCESS_KEY
│   │   └── ORIENTDB_ROOT_PASSWORD
│   ├── pontus-postgrest
│   │   ├── PGRST_DB_ANON_ROLE
│   │   └── PGRST_DB_URI
│   └── pontus-timescaledb
│       ├── POSTGRES_PASSWORD
│       └── POSTGRES_USER
├── google-creds-json
├── mapping-salesforce-graph
├── office-365-auth-client-id
├── office-365-auth-client-secret
├── office-365-auth-tenant-id
├── s3-creds
├── salesforce-client-id
├── salesforce-client-secret
├── salesforce-password
├── salesforce-username
├── watson-password
└── watson-user-name
```
### env/pontus-grafana/GF_PATHS_CONFIG
Path to the grafana configuration file
```
/etc/grafana/grafana-pontus.ini
```


### env/pontus-graphdb/AWS_ACCESS_KEY_ID
AWS ACCESS KEY Used to pull graphdb information from S3 buckets from the graph database
 
### env/pontus-graphdb/AWS_SECRET_ACCESS_KEY
AWS SECRET KEY Used to pull graphdb information from S3 buckets from the graph database

### env/pontus-graphdb/ORIENTDB_ROOT_PASSWORD
Master password file for orient db
```
admin
```

### env/pontus-postgrest/PGRST_DB_ANON_ROLE
Role used to connect from postgrest to postgres (used to store time series data)
```
postgres
```

### env/pontus-postgrest/PGRST_DB_URI
```
postgres://postgres:mysecretpassword@pontus-timescaledb:5432/dtm
```

### env/pontus-timescaledb/POSTGRES_PASSWORD
```
mysecretpassword
```

### env/pontus-timescaledb/POSTGRES_USER
```
postgres
```

### google-creds-json
This file has the credentials required for Google's NLP Engine

Here is a sample content:
```json
{ "type": "service_account", "project_id": "<PROJID_GOES_HERE>", "private_key_id": "<PRIV_KEY_ID_GOES_HERE>", "private_key": "-----BEGIN PRIVATE KEY-----\nPLEASE_ADD_YOUR_PRIVATE_KEY_HERE\n-----END PRIVATE KEY-----\n", "client_email": "<some.email.com>", "client_id": "<CLIENT_ID_GOES_HERE>", "auth_uri": "https://accounts.google.com/o/oauth2/auth", "token_uri": "https://accounts.google.com/o/oauth2/token", "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs", "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/<ADD_YOUR_DETAILS_HERE>" }
```

### mapping-salesforce-graph
This file has the POLE mappings for Salesforce; note that this may also be added in-situ in the NiFi workflow, or stored in S3.
Here is a sample content:
```json
{ "updatereq": { "vertices": [ { "label": "Person.Natural", "props": [ { "name": "Person.Natural.Full_Name", "val": "${pg_FirstName?.toUpperCase()?.trim()} ${pg_LastName?.toUpperCase()?.trim()}", "predicate": "eq", "mandatoryInSearch": true }, { "name": "Person.Natural.Full_Name_fuzzy", "val": "${pg_FirstName?.toUpperCase()?.trim()} ${pg_LastName?.toUpperCase()?.trim()}", "excludeFromSearch": true }, { "name": "Person.Natural.Last_Name", "val": "${pg_LastName?.toUpperCase()?.trim()}", "excludeFromSubsequenceSearch": true }, { "name": "Person.Natural.Date_Of_Birth", "val": "${pg_Birthdate?:'1666-01-01'}", "type": "java.util.Date", "mandatoryInSearch": false, "excludeFromSubsequenceSearch": true }, { "name": "Person.Natural.Title", "val": "${pg_Salutation?:''}", "excludeFromSearch": true }, { "name": "Person.Natural.Nationality", "val": "${pg_MailingCountry?:'Unknown'}", "excludeFromSearch": true }, { "name": "Person.Natural.Customer_ID", "val": "${pg_Id}", "mandatoryInSearch": true }, { "name": "Person.Natural.Gender", "val": "Unknown", "mandatoryInSearch": false, "excludeFromSubsequenceSearch": true } ] }, { "label": "Location.Address", "props": [ { "name": "Location.Address.Full_Address", "val": "${ ( (pg_MailingStreet?:'')+ '\\\\n' + (pg_MailingCity?:'') + '\\\\n' + (pg_MailingState?:'') + '\\\\n' + (pg_MailingCountry?:'')).replaceAll('\\\\n', ' ') }", "mandatoryInSearch": true }, { "name": "Location.Address.parser", "val": "${ ( (pg_MailingStreet?:'')+ '\\\\n' + (pg_MailingCity?:'') + '\\\\n' + (pg_MailingState?:'') + '\\\\n' + (pg_MailingCountry?:'')).replaceAll('\\\\n', ' ') }", "excludeFromSearch": true, "type": "com.pontusvision.utils.LocationAddress" }, { "name": "Location.Address.Post_Code", "val": "${com.pontusvision.utils.PostCode.format(pg_MailingPostalCode)}", "excludeFromSearch": true } ] }, { "label": "Object.Email_Address", "props": [ { "name": "Object.Email_Address.Email", "val": "${pg_Email}", "mandatoryInSearch": true } ] }, { "label": "Object.Phone_Number", "props": [ { "name": "Object.Phone_Number.Raw", "val": "${pg_Phone}", "mandatoryInSearch": false }, { "name": "Object.Phone_Number.Type", "val": "Work", "excludeFromSubsequenceSearch": true }, { "name": "Object.Phone_Number.Numbers_Only", "val": "${(pg_Phone?.replaceAll('[^0-9]', '')?:'00000000')}", "excludeFromSearch": true, "type":"[Ljava.lang.String;" }, { "name": "Object.Phone_Number.Last_7_Digits", "val": "${(((pg_Phone?.replaceAll('[^0-9]', ''))?:'0000000')[-7..-1])}", "mandatoryInSearch": true, "type":"[Ljava.lang.String;" } ] }, { "label": "Object.Data_Source", "props": [ { "name": "Object.Data_Source.Name", "val": "salesforce.com", "mandatoryInSearch": true, "excludeFromUpdate": true } ] }, { "label": "Event.Group_Ingestion", "props": [ { "name": "Event.Group_Ingestion.Metadata_Start_Date", "val": "${pg_currDate}", "mandatoryInSearch": true, "excludeFromSearch": false, "type": "java.util.Date" }, { "name": "Event.Group_Ingestion.Metadata_End_Date", "val": "${new Date()}", "excludeFromSearch": true, "type": "java.util.Date" }, { "name": "Event.Group_Ingestion.Type", "val": "Marketing Email System", "excludeFromSearch": true }, { "name": "Event.Group_Ingestion.Operation", "val": "Structured Data Insertion", "excludeFromSearch": true } ] }, { "label": "Event.Ingestion", "props": [ { "name": "Event.Ingestion.Type", "val": "Marketing Email System", "excludeFromSearch": true }, { "name": "Event.Ingestion.Operation", "val": "Structured Data Insertion", "excludeFromSearch": true }, { "name": "Event.Ingestion.Domain_b64", "val": "${original_request?.bytes?.encodeBase64()?.toString()}", "excludeFromSearch": true }, { "name": "Event.Ingestion.Metadata_Create_Date", "val": "${new Date()}", "excludeFromSearch": true, "type": "java.util.Date" } ] } ], "edges": [ { "label": "Uses_Email", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Object.Email_Address" }, { "label": "Has_Phone", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Object.Home_Phone_Number" }, { "label": "Has_Phone", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Object.Phone_Number" }, { "label": "Lives", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Location.Address" }, { "label": "Has_Policy", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Object.Phone_Number" }, { "label": "Has_Ingestion_Event", "fromVertexLabel": "Person.Natural", "toVertexLabel": "Event.Ingestion" }, { "label": "Has_Ingestion_Event", "fromVertexLabel": "Event.Group_Ingestion", "toVertexLabel": "Event.Ingestion" }, { "label": "Has_Ingestion_Event", "toVertexLabel": "Event.Group_Ingestion", "fromVertexLabel": "Object.Data_Source" } ] } }
```
### office-365-auth-client-id
This file has the Office 365 auth client id; the format is typically just a GUID.
Here is a sample content:
```
12345678-90ab-cdef-0123-456789abcdef
```

### office-365-auth-client-secret
This file has the Office 365 auth client secret; the format has randomly generated strings
Here is a sample content:
```
Aasdf888^%8>73321;;123k4k123k415k123
```
### office-365-auth-tenant-id
This file has the Office 365 auth tenant id; the format is typically just a GUID.
Here is a sample content:
```
87654321-90ab-cdef-0123-456789abcdef
```
### s3-creds
This file has the credentials to connect to AWS S3 Buckets
Here is a sample content:
```
aws_access_key = AKIAQQQQQQQQQQQQQQQQ
aws_secret_key = cccccccccccccccccccccccccccccccccccccccc
#assumed_role = True
#assumed_role_arn = arn:aws:iam::012345678901:role/orientdb-role
aws_access_key_id = AKIAQQQQQQQQQQQQQQQQ
aws_secret_access_key = cccccccccccccccccccccccccccccccccccccccc
accessKey=AKIAQQQQQQQQQQQQQQQQ
secretKey=cccccccccccccccccccccccccccccccccccccccc
```
### salesforce-client-id
This file has the Salesforce alphanumeric API client id
Here is a sample content:
```
00000000000000000000000000000000000.abcdefghijklmnopqrstuvwzyzABCDEFGHIJKLMNOPQRSTUVW
```
### salesforce-client-secret
This file has the Salesforce HEX API client secret
Here is a sample content:
```
01234567890DEADBEE01234567890DEADBEE01234567890DEADBEEFFF0123456
```
### salesforce-password
This file has the Salesforce API's alphanumeric password
Here is a sample content:
```
passwordpasswordpassword123456789
```
### salesforce-username
This file has the Salesforce API's user name (typically an e-mail address)
Here is a sample content:
```
my@email.com
```
### watson-password
This file has the IBM Watson API Password (typically an alpha-numeric random string)
Here is a sample content:
```
dfghjkl32j3
```

### watson-user-name
This file has the IBM Watson API User Name (typically a GUID)
Here is a sample content:
```
87654321-90ab-cdef-0123-456789abcdef
```

