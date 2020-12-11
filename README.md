# About Gorani Reader

It tries to trace vocabulary of students by utilizing dictionary look-up logs. With traced vocabulary, Gorani Reader improves the book recommendation and word quizzes (short text reading). 

## Components

### Machine Learning model

More detailed description on [here](/backend/dataserver/notebooks/2020_final.ipynb)

### Frontend

Ebook reader with dicitonary look-up function implemented from scratch using web technologies. It contains react implementation of ebook page splitting, rendering, and swiping. 

### ETL pipeline

ETL pipeline that preprocesses the event logs sent from frontend into tabular data that can be used directly in machine learing model.
