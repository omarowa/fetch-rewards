/*
 * Created by: Omar Abouel Maaty
 * Created on: 11/09/2024
 * Description: Query to identify the 2 bullet points below:
 * 		1. Which brand has the most spend among users who were created within the past 6 months?
		2. Which brand has the most transactions among users who were created within the past 6 months?
* Results of the query is pasted below for reference.
 */
WITH MaxDate AS (
    SELECT MAX(createdDate) AS MaxUserCreatedDate FROM fetch.users
),
RecentUsers AS (
    SELECT 
        distinct id AS userId -- using distinct because there are duplicates in this table
    FROM 
        fetch.users, MaxDate
    WHERE 
        createdDate >= DATE_SUB(MaxDate.MaxUserCreatedDate, INTERVAL 6 MONTH)
),
BrandSummary AS (
    SELECT 
        b.name AS BrandName,
        ROUND(SUM(r.totalSpent), 2) AS TotalSpend,  -- Round to 2 decimal places
        COUNT(DISTINCT r.id) AS TotalTransactions
    FROM 
        fetch.receipts r
    JOIN 
        RecentUsers u ON r.userId = u.userId
    JOIN 
        fetch.rewardsReceiptItems ri ON r.id = ri.receiptId
    JOIN 
        fetch.brands b ON ri.barcode = b.barcode
    GROUP BY 
        b.name
)
SELECT 
    BrandName,
    TotalSpend,
    TotalTransactions,
    CASE 
        WHEN TotalSpend = (SELECT MAX(TotalSpend) FROM BrandSummary) 
        THEN 'Most Spend'
        ELSE 'Not Most Spend'
    END AS SpendComparison,
    CASE 
        WHEN TotalTransactions = (SELECT MAX(TotalTransactions) FROM BrandSummary) 
        THEN 'Most Transactions'
        ELSE 'Not Most Transactions'
    END AS TransactionComparison
FROM 
    BrandSummary
ORDER BY 
    TotalSpend DESC, TotalTransactions DESC;
/*
 *  ________________________________________________________________________________________________________________
 * SUMMARY
 * * The most spent brand among users is Tostitos
 * * The most transaction brand among users is tied between Tostitos and Swanson
 ________________________________________________________________________________________________________________
 * RESULTS 12 row(s) fetched on 2024-11-09 at 22:55:17
 
#	BrandName				TotalSpend		TotalTransactions		SpendComparison		TransactionComparison
1	Tostitos				15,799.37		11						Most Spend			Most Transactions
2	Pepperidge Farm			14,165.85		1						Not Most Spend		Not Most Transactions
3	Prego					9,443.9			1						Not Most Spend		Not Most Transactions
4	V8						9,443.9			1						Not Most Spend		Not Most Transactions
5	Diet Chris Cola			9,443.9			1						Not Most Spend		Not Most Transactions
6	Swanson					7,187.14		11						Not Most Spend		Most Transactions
7	Cracker Barrel Cheese	4,885.89		2						Not Most Spend		Not Most Transactions
8	Jell-O					4,754.37		2						Not Most Spend		Not Most Transactions
9	Cheetos					4,721.95		1						Not Most Spend		Not Most Transactions
10	Kettle Brand			2,400.91		3						Not Most Spend		Not Most Transactions
11	Grey Poupon				743.79			1						Not Most Spend		Not Most Transactions
12	Quaker					32.42			1						Not Most Spend		Not Most Transactions
 ________________________________________________________________________________________________________________
 * 
*/
