# Database systems project for AUA

## Dependencies
mysql>8.0.0

## How to run
From mysql shell change the path and run:

`source <path to project>/create_tables.sql`
`source <path to project>/create_indexes.sql`
`source <path to project>/source_all.sql`
`source <path to project>/views.sql`
`source <path to project>/functions_and_triggers.sql`


if you want to regenerate the data with different quantity, open `Mock data.ipynb`, change the counts_per_table and click run all.
(it will regenerate all the sql files in data folder)

### Note 
Sometimes it can generate conflicting ids, especially in case of large amounts of data.


