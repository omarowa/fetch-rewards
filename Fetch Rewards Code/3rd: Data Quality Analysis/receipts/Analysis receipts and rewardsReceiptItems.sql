/*
 * Created by: Omar Abouel Maaty
 * Created on: 11/10/2024
 * Description: Queries to identify any data issues observed in the fetch.receipts and fetch.rewardsreceiptitems 
 * 				and their relation to one another
 */

-- -------------------------------------------------- QUERY 1 -------------------------------------------------- --
/*	
 * The below first query identifies missing rewardreceiptitem records.
 *  ________________________________________________________________________________________________________________
*/
SELECT 
	COUNT(r.id) AS ReceiptsMissingRewardItems
FROM 
	fetch.receipts r 
LEFT JOIN
	fetch.rewardsreceiptitems r2 
ON 
	r.id = r2.receiptId
WHERE
	r2.receiptId IS NULL; 
/*
 *  ________________________________________________________________________________________________________________
 * SUMMARY
 * There exists around 440 receipt ids that do not have corresponding rewardsreceiptitems. Some of the receipts are in a
 * FINISHED status as well. This is a major concern for data corruption, and it prevents us from being able to analyze
 * the receipt contents, and determine the brands that rewarded the customer points.
 ________________________________________________________________________________________________________________
 * RESULTS 1 row(s) fetched - 0.006s, on 2024-11-10 at 10:35:15
 
#	ReceiptsMissingRewardItems
1	440
 ________________________________________________________________________________________________________________ 
*/

-- -------------------------------------------------- QUERY 2 -------------------------------------------------- --
/*	
 * The below second query identifies any mismatching results within a single record in fetch.receipts
 *  ________________________________________________________________________________________________________________
*/

SELECT 
	 id 
	,finishedDate
	,rewardsReceiptStatus
FROM 
	fetch.receipts r 
WHERE 
	finishedDate IS NOT NULL
AND 
	rewardsReceiptStatus <> 'FINISHED';
	
/*
 *  ________________________________________________________________________________________________________________
 * SUMMARY
 * There exists around 50 receipts that have a discrepancy between their rewardsReceiptStatus and the finishedDate timestamp.
 * Normally, we should expect only rows in a FINISHED state to contain a finishedDate timestamp. However finding records
 * with a finishedDate, but not an updated rewardsReceiptStatus suggests that there may be an issue with the ETL process.
 * This issue is commonly caused if a loading procedure has what is called a "bad join"
 ________________________________________________________________________________________________________________
 * RESULTS 50 row(s) fetched - 0.002s, on 2024-11-10 at 10:53:37
 
#	id							finishedDate		rewardsReceiptStatus
1	5ffce76e0a720f0515000b48	2021-01-11 18:04:00	PENDING
2	5ffce7db0a720f051500236e	2021-01-11 18:05:49	PENDING
3	5ffce8310a7214ad4e003797	2021-01-11 18:07:14	PENDING
4	5ffcef570a720f0515004e91	2021-01-11 18:37:43	PENDING
5	5ffcef5a0a720f0515004f1a	2021-01-11 18:37:46	PENDING
6	5ffcef630a720f05150050ae	2021-01-11 18:37:55	PENDING
7	5ffe18b10a7214ad280003d1	2021-01-12 15:46:25	PENDING
8	5ffe19d90a7214ad28000e62	2021-01-12 15:51:21	PENDING
9	5ffe1aa90a7214ad280015e8	2021-01-12 15:54:49	PENDING
10	5ffe1b630a7214ad28001c79	2021-01-12 15:57:55	PENDING
11	5ffe1c520a7214ad2800245c	2021-01-12 16:01:54	PENDING
12	5ffe1cbe0a7214ad28002843	2021-01-12 16:03:42	PENDING
13	5ffe1d030a720f05ac002c9e	2021-01-12 16:04:51	PENDING
14	5ffe1dc20a7214ad28003180	2021-01-12 16:08:03	PENDING
15	5ffe1fa40a7214ad2800427f	2021-01-12 16:16:04	PENDING
16	5ffe20290a720f05ac004a84	2021-01-12 16:18:17	PENDING
17	5ffe22a20a720f05ac0061d7	2021-01-12 16:28:50	PENDING
18	5ffe23560a720f05ac006874	2021-01-12 16:31:50	PENDING
19	5ffe23cf0a720f05ac006cc2	2021-01-12 16:33:51	PENDING
20	5ffe23d70a7214ad280068f6	2021-01-12 16:33:59	PENDING
21	601431e40a7214ad50000041	2021-01-29 10:03:48	PENDING
22	601d75dd0a720f05a9000004	2021-02-05 10:44:13	PENDING
23	601d77170a720f053c00000a	2021-02-05 10:49:27	PENDING
24	601d77180a720f053c00000f	2021-02-05 10:49:29	PENDING
25	601d7b730a720f0554000006	2021-02-05 11:08:03	PENDING
26	601d7b770a720f0554000016	2021-02-05 11:08:07	PENDING
27	601d7b840a720f055400004e	2021-02-05 11:08:20	PENDING
28	601d7b8e0a720f0554000079	2021-02-05 11:08:30	PENDING
29	601d7ba00a720f05540000d2	2021-02-05 11:08:48	PENDING
30	601d7bb60a720f055400013a	2021-02-05 11:09:10	PENDING
31	601d7bb60a7214ad59000141	2021-02-05 11:09:10	PENDING
32	601d7c000a7214ad590002a1	2021-02-05 11:10:24	PENDING
33	601d7c180a720f05540002fd	2021-02-05 11:10:48	PENDING
34	601d7c1e0a720f055400031a	2021-02-05 11:10:54	PENDING
35	601d7c280a7214ad5900035c	2021-02-05 11:11:04	PENDING
36	601d7c300a7214ad59000384	2021-02-05 11:11:12	PENDING
37	601d7c480a720f05540003e0	2021-02-05 11:11:36	PENDING
38	601d7c500a720f0554000409	2021-02-05 11:11:44	PENDING
39	601d7c7f0a7214ad590004f2	2021-02-05 11:12:31	PENDING
40	601d7c960a7214ad59000564	2021-02-05 11:12:54	PENDING
41	601d7ca40a720f055400058b	2021-02-05 11:13:08	PENDING
42	601d7cd30a720f0554000663	2021-02-05 11:13:55	PENDING
43	601d7cd50a7214ad5900069f	2021-02-05 11:13:57	PENDING
44	601d7cf90a720f055400070e	2021-02-05 11:14:33	PENDING
45	601d7d230a720f05540007ce	2021-02-05 11:15:15	PENDING
46	601d7d2c0a720f05540007fa	2021-02-05 11:15:24	PENDING
47	601d7d340a7214ad5900086c	2021-02-05 11:15:32	PENDING
48	601d7d540a720f05540008a6	2021-02-05 11:16:04	PENDING
49	601d7d580a7214ad59000928	2021-02-05 11:16:08	PENDING
50	602160a30a720f05c0000001	2021-02-08 10:02:51	PENDING
 ________________________________________________________________________________________________________________ 
*/

-- -------------------------------------------------- QUERY 3 -------------------------------------------------- --
/*	
 * The below third query identifies multiple issues with the rewardsReceiptItems based on my own interpretation of
 * the data fields.
 *  ________________________________________________________________________________________________________________
*/

SELECT 
    a.MissingBarcodeCount,
    b.MissingUserFlaggedBarcodeCount,
    c.BothBarcodesMissingCount,
    d.ZeroFinalPriceWithQuantityCount,
    e.PriceMismatchWithoutReviewCount
FROM 
    (SELECT COUNT(*) AS MissingBarcodeCount FROM fetch.rewardsReceiptItems WHERE barcode IS NULL OR barcode = '') a
CROSS JOIN
    (SELECT COUNT(*) AS MissingUserFlaggedBarcodeCount FROM fetch.rewardsReceiptItems WHERE userFlaggedBarcode IS NULL OR userFlaggedBarcode = '') b
CROSS JOIN
    (SELECT COUNT(*) AS BothBarcodesMissingCount FROM fetch.rewardsReceiptItems WHERE (barcode IS NULL OR barcode = '') AND (userFlaggedBarcode IS NULL OR userFlaggedBarcode = '')) c
CROSS JOIN
    (SELECT COUNT(*) AS ZeroFinalPriceWithQuantityCount FROM fetch.rewardsReceiptItems WHERE finalPrice = 0 AND quantityPurchased > 0) d
CROSS JOIN
    (SELECT COUNT(*) AS PriceMismatchWithoutReviewCount FROM fetch.rewardsReceiptItems WHERE itemPrice != finalPrice AND needsFetchReview = 0) e;

/*
 *  ________________________________________________________________________________________________________________
 * SUMMARY
 * MissingBarcodeCount:This subquery counts the number of records where the barcode field is either NULL or an empty string.
  					   This highlights potential data quality issues where the primary product identifier is missing.
  
 * MissingUserFlaggedBarcodeCount:This subquery counts the number of records where the userFlaggedBarcode field is either NULL or an empty string. 
								  This doesn't necessarily mean anything concerning, because if the barcode of the item is operational, then it is
								  not needed.

* BothBarcodesMissingCount:This subquery counts the number of records where both barcode and userFlaggedBarcode are either NULL or empty strings. 
 						   This represents a more critical data quality issue,since both primary identifiers for the item are unavailable, 
 						   potentially affecting our ability to relate the receipts with what was actually purchased.
 						   
* ZeroFinalPriceWithQuantityCount:This subquery counts the number of records where finalPrice is zero but quantityPurchased is greater than zero. 
								  This is an indicator that there may be some data corruption, since it should not be logically possible that no final
								  price was accounted for, but some items were purchased. Maybe it's possible that the customer used coupons.
								  
PriceMismatchWithoutReviewCount: This subquery counts the number of records where itemPrice differs from finalPrice but needsFetchReview is false. 
								 This could mean potential discrepancies in the pricing data that were not flagged for review, 
								 which could lead to inaccurate data being used without appropriate verification.
 ________________________________________________________________________________________________________________
 * RESULTS 1 row(s) fetched - 0.010s, on 2024-11-10 at 11:32:00
 
#	MissingBarcodeCount		MissingUserFlaggedBarcodeCount	BothBarcodesMissingCount	ZeroFinalPriceWithQuantityCount	 PriceMismatchWithoutReviewCount
1	3,851					6,604							3,701						4								 4
 ________________________________________________________________________________________________________________ 
*/


