/*
 * Created by: Omar Abouel Maaty
 * Created on: 11/10/2024
 * Description: Queries to identify any data issues observed in the fetch.users table
 */

-- -------------------------------------------------- QUERY 1 -------------------------------------------------- --
/*	
 * The below first query identifies duplicate records in the users table.
 * The issue is not just duplicate primary keys, it's complete duplicate of records, which
 * had to be worked around in the analysis queries by using the DISTINCT keyword.
 *  ________________________________________________________________________________________________________________
*/
SELECT 
    COUNT(*) AS GrandTotalRowCount,
    (SELECT COUNT(*) 
     FROM (
         SELECT DISTINCT id, state, createdDate, lastLogin, role, active
         FROM fetch.users
     ) AS distinct_rows
    ) AS DistinctRowCount
FROM 
    fetch.users;
/*
 *  ________________________________________________________________________________________________________________
 * SUMMARY
 * The grand total row count in the table is 495, however only 212 of the rows are DISTINCT
 * meaning we have around 283 rows that are duplicated. This indicates that some users could be
 * duplicated more than once, which could indicate an issue in the ETL process that loads the users table.
 ________________________________________________________________________________________________________________
 * RESULTS 1 row(s) fetched - 0.003s, on 2024-11-10 at 08:50:24
 
#	GrandTotalRowCount	DistinctRowCount
1	495					212
 ________________________________________________________________________________________________________________ 
*/

-- -------------------------------------------------- QUERY 2 -------------------------------------------------- -- 
/*	
 * The below second query identifies the problamatic users and counts how many occurrences there exists
 * for every row.
 *  ________________________________________________________________________________________________________________
*/
SELECT 
    id, state, createdDate, lastLogin, role, active,
    COUNT(*) AS OccurrenceCount
FROM 
    fetch.users
GROUP BY 
    id, state, createdDate, lastLogin, role, active
HAVING 
    COUNT(*) > 1
ORDER BY 
    OccurrenceCount DESC;
/*
 *  ________________________________________________________________________________________________________________
 * SUMMARY
 * Around 70 users in the table are duplicated, which is a major concern for data integrity.
 * Some users have 20 - 7 duplicate records, while the majority have 6 - 2 duplicated records.
 ________________________________________________________________________________________________________________
 * RESULTS 70 row(s) fetched - 0.005s (0.001s fetch), on 2024-11-10 at 09:49:34
 * 
#	id							state	createdDate			lastLogin			role		active	OccurrenceCount
1	54943462e4b07e684157a532			2014-12-19 08:21:22	2021-03-05 10:52:23	fetch-staff	1		20
2	5fc961c3b8cfca11a077dd33	NH		2020-12-03 16:08:03	2021-02-26 16:39:16	fetch-staff	1		20
3	59c124bae4b0299e55b0f330	WI		2017-09-19 09:07:54	2021-02-08 10:42:58	fetch-staff	1		18
4	5ff5d15aeb7c7d12096d91a2	WI		2021-01-06 09:03:54	2021-01-06 09:08:10	consumer	1		18
5	5fa41775898c7a11a6bcef3e			2020-11-05 09:17:09	2021-03-04 10:02:02	fetch-staff	1		18
6	600fb1ac73c60b12049027bb	WI		2021-01-26 00:07:40	2021-01-26 00:11:23	consumer	1		16
7	5ff1e194b6a9d73a3a9f1052	WI		2021-01-03 09:24:04	2021-01-03 09:25:37	consumer	1		11
8	600987d77d983a11f63cfa92	WI		2021-01-21 07:55:35	2021-01-21 07:59:21	consumer	1		9
9	600056a3f7e5b011fce897b0	WI		2021-01-14 08:35:15	2021-01-14 08:37:10	consumer	1		8
10	5a43c08fe4b014fd6b6a0612			2017-12-27 09:47:27	2021-02-12 10:22:37	consumer	1		8
11	60189c74c8b50e11d8454eff	WI		2021-02-01 18:27:32	2021-02-01 18:29:09	consumer	1		7
12	5ff4ce33c3d63511e2a484b6	WI		2021-01-05 14:38:11	2021-01-05 14:39:55	consumer	1		7
13	5fff55dabd4dff11dda8f5f1	WI		2021-01-13 14:19:38	2021-01-13 14:23:26	consumer	1		7
14	600f008f4329897eac237bd8	WI		2021-01-25 11:31:59	2021-01-25 11:35:51	consumer	1		7
15	6000b75bbe5fc96dfee1d4d3	AL		2021-01-14 15:27:55	[NULL]				consumer	1		6
16	5ffc8f9704929111f6e922bf	WI		2021-01-11 11:49:11	2021-01-11 11:50:56	consumer	1		6
17	600741d06e6469120a787853	WI		2021-01-19 14:32:17	2021-01-19 14:39:03	consumer	1		6
18	5ff873d1b3348b11c9337716	WI		2021-01-08 09:01:37	2021-01-08 09:03:21	consumer	1		5
19	6008893b633aab121bb8e0a9	WI		2021-01-20 13:49:15	2021-01-20 13:50:33	consumer	1		5
20	5ff47392c3d63511e2a47881	WI		2021-01-05 08:11:30	2021-01-05 08:15:33	consumer	1		5
21	5ff370c562fde912123a5e0e	WI		2021-01-04 13:47:17	2021-01-04 13:50:50	consumer	1		5
22	60186237c8b50e11d8454d5f			2021-02-01 14:19:03	[NULL]				consumer	1		5
23	5ff36a3862fde912123a4460	WI		2021-01-04 13:19:20	2021-01-04 13:23:05	consumer	1		5
24	60147d2ac8b50e11d8453f53	OH		2021-01-29 15:24:58	[NULL]				consumer	1		5
25	5ff7264e8f142f11dd189504	WI		2021-01-07 09:18:38	2021-01-07 09:20:26	consumer	1		4
26	600ed42e43298911ce45d1fa	WI		2021-01-25 08:22:39	2021-01-25 08:29:24	consumer	1		4
27	5ff4ce3dc3d63511e2a484dc	WI		2021-01-05 14:38:21	2021-01-05 14:38:21	consumer	1		4
28	5ffc8ff9b3348b11c9338896	WI		2021-01-11 11:50:49	2021-01-11 11:50:49	consumer	1		4
29	600748196e64691717e8d4f0	WI		2021-01-19 14:59:05	2021-01-19 15:02:42	consumer	1		4
30	5ff1e1eacfcf6c399c274ae6	WI		2021-01-03 09:25:30	2021-01-03 09:25:30	consumer	1		4
31	60189c94c8b50e11d8454f6b	WI		2021-02-01 18:28:04	2021-02-01 18:28:04	consumer	1		4
32	6011f31ea4b74c18d3a8c476	WI		2021-01-27 17:11:26	2021-01-27 17:16:11	consumer	1		4
33	5fff0f4fb3348b03eb45abb0	WI		2021-01-13 09:18:39	2021-01-13 09:22:02	consumer	1		4
34	6011f33173c60b1804ce1102	WI		2021-01-27 17:11:45	2021-01-27 17:11:46	consumer	1		4
35	5ff36d0362fde912123a5535	WI		2021-01-04 13:31:15	2021-01-04 13:34:42	consumer	1		3
36	5ffc9d87b3348b11c9338920	WI		2021-01-11 12:48:39	2021-01-11 12:50:13	consumer	1		3
37	6000b7aefb296c121a8198b1	WI		2021-01-14 15:29:18	2021-01-14 15:33:22	consumer	1		3
38	5ff7930fb3348b11c93372a6	WI		2021-01-07 17:02:39	2021-01-07 17:09:54	consumer	1		3
39	6007464b6e64691717e8c1f0	WI		2021-01-19 14:51:23	2021-01-19 14:55:08	consumer	1		3
40	5ff36be7135e7011bcb856d3	WI		2021-01-04 13:26:31	2021-01-04 13:29:52	consumer	1		3
41	6009e60450b3311194385009	WI		2021-01-21 14:37:25	[NULL]				consumer	1		3
42	5ff8ce8504929111f6e913cb	WI		2021-01-08 15:28:37	2021-01-08 15:29:59	consumer	1		3
43	60132acb73c60b3ca7f3ba32	WI		2021-01-28 15:21:15	2021-01-28 15:25:01	consumer	1		3
44	600f47f06fd0dc1768a34a12	WI		2021-01-25 16:36:32	2021-01-25 16:40:13	consumer	1		3
45	60025c65fb296c4ef805d9e6	WI		2021-01-15 21:24:21	[NULL]				consumer	1		3
46	6010bddaa4b74c120bd19dfb	WI		2021-01-26 19:11:54	2021-01-26 19:14:25	consumer	1		3
47	60118bcfa4b74c18d3a8c0d7	WI		2021-01-27 09:50:39	2021-01-27 09:52:41	consumer	1		3
48	5fbc35711d967d1222cbfefc			2020-11-23 16:19:29	2021-02-25 22:25:51	fetch-staff	1		3
49	6014558767804a1228b20d00	WI		2021-01-29 12:35:51	2021-01-29 12:35:51	consumer	1		2
50	600f00d05edb787dce05fb84	WI		2021-01-25 11:33:04	[NULL]				consumer	1		2
51	60074b49325c8a1794623876	WI		2021-01-19 15:12:41	2021-01-19 15:16:09	consumer	1		2
52	5ff873ddb3348b11c9337733	WI		2021-01-08 09:01:49	2021-01-08 09:01:49	consumer	1		2
53	5fff4beedf9ace121f0c17ea	WI		2021-01-13 13:37:18	2021-01-13 13:41:12	consumer	1		2
54	5ff8da28b3348b11c9337ac6	WI		2021-01-08 16:18:16	2021-01-08 16:19:49	consumer	1		2
55	601c2c05969c0b11f7d0b097	WI		2021-02-04 11:16:53	2021-02-04 11:20:30	consumer	1		2
56	60005709bd4dff11dda90ac1	WI		2021-01-14 08:36:57	2021-01-14 08:36:58	consumer	1		2
57	5ffcb4bc04929111f6e92608	WI		2021-01-11 14:27:40	2021-01-11 14:27:40	consumer	1		2
58	60145ff384231211ce796d51			2021-01-29 13:20:19	[NULL]				consumer	1		2
59	6000d46cfb296c121a81b20c	WI		2021-01-14 17:31:56	2021-01-14 17:33:52	consumer	1		2
60	60088d55633aab121bb8e41a	WI		2021-01-20 14:06:45	2021-01-20 14:07:54	consumer	1		2
61	5ffcb47d04929111f6e9256c	WI		2021-01-11 14:26:37	2021-01-11 14:28:21	consumer	1		2
62	60229990b57b8a12187fe9e0	WI		2021-02-09 08:17:52	2021-02-09 08:17:52	consumer	1		2
63	600f41b2bd196811e68ea219	WI		2021-01-25 16:09:55	2021-01-25 16:16:29	consumer	1		2
64	6002541ae257124ec6b99a3a	WI		2021-01-15 20:48:58	[NULL]				consumer	1		2
65	5ff7268eeb7c7d12096da2a9	WI		2021-01-07 09:19:42	2021-01-07 09:19:42	consumer	1		2
66	5ff73b90eb7c7d31ca8a452b	WI		2021-01-07 10:49:20	2021-01-07 10:51:07	consumer	1		2
67	5ffe115404929101d0aaebb2	AL		2021-01-12 15:15:00	[NULL]				consumer	1		2
68	60183090c8b50e11d84549c0	WI		2021-02-01 10:47:12	2021-02-01 10:48:32	consumer	1		2
69	60145a3c84231211ce796c5d	WI		2021-01-29 12:55:56	2021-01-29 12:58:36	consumer	1		2
70	5fb0a078be5fc9775c1f3945	AL		2020-11-14 21:28:56	[NULL]				consumer	1		2
 ________________________________________________________________________________________________________________ 
*/

-- -------------------------------------------------- QUERY 3 -------------------------------------------------- --
/*	
 * The below third query highlights 6 distinct users with problamtic values in the state column.
 *  ________________________________________________________________________________________________________________
*/
SELECT DISTINCT 
	id, state, createdDate , lastLogin, role , active
FROM 
	FETCH.users
WHERE 
	state IS NULL
OR 
	state = '';
/*
 *  ________________________________________________________________________________________________________________
 * SUMMARY
 * There exists 6 distinct rows in the fetch.users table where the state column is an empty string.
 * This can cause data discrepancy and outliers when analyzing customer behaviors based on US states.
 ________________________________________________________________________________________________________________
 * RESULTS 6 row(s) fetched - 0.002s, on 2024-11-10 at 10:01:00
 
#	id						state	createdDate			lastLogin				role		active
1	60145ff384231211ce796d51		2021-01-29 13:20:19	[NULL]					consumer		1
2	60186237c8b50e11d8454d5f		2021-02-01 14:19:03	[NULL]					consumer		1
3	5a43c08fe4b014fd6b6a0612		2017-12-27 09:47:27	2021-02-12 10:22:37		consumer		1
4	5fbc35711d967d1222cbfefc		2020-11-23 16:19:29	2021-02-25 22:25:51		fetch-staff		1
5	5fa41775898c7a11a6bcef3e		2020-11-05 09:17:09	2021-03-04 10:02:02		fetch-staff		1
6	54943462e4b07e684157a532		2014-12-19 08:21:22	2021-03-05 10:52:23		fetch-staff		1
 ________________________________________________________________________________________________________________ 
*/
