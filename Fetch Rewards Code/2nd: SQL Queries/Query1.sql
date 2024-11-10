/*
 * Created by: Omar Abouel Maaty
 * Created on: 11/09/2024
 * Description: Query to identify the 2 bullet points below:
 * 		1. When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
		2. When considering total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater?
* Results of the query is pasted below for reference.
 */
WITH Summary AS (
    SELECT 
        r.rewardsReceiptStatus,
        AVG(r.totalSpent) AS AverageSpend,
        SUM(r.purchasedItemCount) AS TotalItemsPurchased
    FROM 
        fetch.receipts r
    WHERE 
        r.rewardsReceiptStatus IN ('FINISHED', 'REJECTED')  -- Assuming 'FINISHED' is treated as 'Accepted'
    GROUP BY 
        r.rewardsReceiptStatus
)
SELECT 
    s.rewardsReceiptStatus,
    s.AverageSpend,
    s.TotalItemsPurchased,
    CASE 
        WHEN s.AverageSpend = (SELECT MAX(AverageSpend) FROM Summary) 
        THEN 'Highest Average Spend'
        ELSE 'Not Highest Average Spend'
    END AS SpendComparison,
    CASE 
        WHEN s.TotalItemsPurchased = (SELECT MAX(TotalItemsPurchased) FROM Summary) 
        THEN 'Highest Total Items Purchased'
        ELSE 'Not Highest Total Items Purchased'
    END AS ItemComparison
FROM 
    Summary s
ORDER BY 
    s.rewardsReceiptStatus;
/*
 *  _________________________________________________________________________________________________________________
 * SUMMARY
 * * The highest average spend rewardsReceiptStatus between FINISHED and REJECTED is FINISHED
 * * The highest total number of items purchased rewardsReceiptStatus between FINISHED and REJECTED is FINISHED
 _____________________________________________________________________________________________________________________
 * RESULTS 12 row(s) fetched on 2024-11-09 at 22:55:17
 
#	rewardsReceiptStatus	AverageSpend	TotalItemsPurchased		SpendComparison				ItemComparison
1	FINISHED				80.8543052494	8,184					Highest Average Spend		Highest Total Items Purchased
2	REJECTED				23.3260557819	173						Not Highest Average Spend	Not Highest Total Items Purchased
 _____________________________________________________________________________________________________________________
 * 
*/
