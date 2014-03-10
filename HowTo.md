HOW TO RUN THE RAILS PROJECT
============================
cd into the data engineering folder

Use the command  

```
rake db:migrate
```

Then start the server with

```
rails server
```

In your web browser, go to 

```
localhost:3000/
```

To upload a .csv file, either click on the "Upload another file" 
button on the index page, or go to the following path:

```
itemlists/new
```

After uploading your file you should see the total of the items
in the uploaded file.  

The index will always show the running total for all files uploaded.
