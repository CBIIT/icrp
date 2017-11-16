--1348  => 1269
select Name AS Institution, City, ISNULL(State, '') AS State, Country, ISNULL(grid, '') AS GRID, '' AS Latitude, '' AS Longitude from Institution where ISNULL(Latitude, 0) = 0  and name <> 'Missing' ORDER BY Name

 begin transaction
 update ProjectFundingInvestigator set institutionid = 39 where institutionid = 38
 update institution set longitude=-88.252999, latitude=40.07366 where institutionid = 39
 delete institution where institutionid = 38

 update ProjectFundingInvestigator set institutionid = 78 where institutionid = 77
 update institution set longitude=-74.594507, latitude=40.358001 where institutionid = 78
 delete institution where institutionid = 77

 update institution set longitude=-122.263066, latitude=37.821545 where institutionid = 135

 update ProjectFundingInvestigator set institutionid = 310 where institutionid = 311
 update institution set longitude=145.059249, latitude=-37.756676 where institutionid = 310
 delete institution where institutionid = 311

 update institution set longitude=-76.650373, latitude=39.377113 where institutionid = 341
 update institution set longitude=-119.27923, latitude=46.345195 where institutionid = 342  -- -119.27923	46.345195

 update ProjectFundingInvestigator set institutionid = 367 where institutionid = 368
 update institution set longitude=-77.224077, latitude=39.135967, city = 'Gaithersburg' where institutionid = 367  -- -77.224077	39.135967
 delete institution where institutionid = 368

 update ProjectFundingInvestigator set institutionid = 375 where institutionid = 374 
 delete institution where institutionid = 374
 
 update ProjectFundingInvestigator set institutionid = 428 where institutionid = 427
 update institution set longitude=-73.113152, latitude=40.912295 where institutionid = 428  -- -73.113152	40.912295
 delete institution where institutionid = 427

 update ProjectFundingInvestigator set institutionid = 636 where institutionid = 637
 update institution set longitude=-122.141199, latitude=37.65491 where institutionid = 636  -- -122.141199	37.65491
 delete institution where institutionid = 637
   
 update ProjectFundingInvestigator set institutionid = 775 where institutionid = 776
 update institution set longitude=-78.899436, latitude=35.910018 where institutionid = 775  -- -78.899436	35.910018
 delete institution where institutionid = 776

 update ProjectFundingInvestigator set institutionid = 846 where institutionid = 847
 update institution set longitude=-122.100927, latitude=-37.417399 where institutionid = 846  -- -122.100927	37.417399
 delete institution where institutionid = 847

 update ProjectFundingInvestigator set institutionid = 863 where institutionid = 862
 update institution set longitude=-90.464032, latitude=38.756659, city = 'Maryland Heights' where institutionid = 863  -- -90.464032	38.756659
 delete institution where institutionid = 862

 update ProjectFundingInvestigator set institutionid = 979 where institutionid = 4298
 update institution set longitude=-122.109582, latitude=37.432391 where institutionid = 979  -- -122.109582	37.432391
 delete institution where institutionid = 4298

 update institution set longitude=9.882658, latitude=53.57807 where institutionid = 4336  -- 9.882658	53.57807

 update ProjectFundingInvestigator set institutionid = 1148 where institutionid = 1147
 update institution set longitude=-71.200563, latitude=42.343862 where institutionid = 1148  -- -71.200563	42.343862
 delete institution where institutionid = 1147

 update institution set Name ='French Institute of Health and Medical Research (INSERM) U1100', longitude=7.739241, latitude=48.575361 where institutionid = 1196  -- 7.739241	48.575361
 update institution set longitude=2.365553, latitude=48.826524 where institutionid = 4338  -- 2.365553	48.826524
 update institution set Name='French Institute of Health and Medical Research (INSERM) U1034', longitude=-0.660595, latitude=44.785518 where institutionid = 4339  -- -0.660595	44.785518

 update ProjectFundingInvestigator set institutionid = 1232 where institutionid = 1233
 update institution set longitude=-71.215041, latitude=42.309969 where institutionid = 1232  -- -71.215041	42.309969
 delete institution where institutionid = 1233

 update ProjectFundingInvestigator set institutionid = 1255 where institutionid = 1254
 update institution set longitude=-74.764594, latitude=40.22162 where institutionid = 1255  -- -74.764594	40.22162
 delete institution where institutionid = 1254

 delete institution where institutionid in (1310, 1311)

 update ProjectFundingInvestigator set institutionid = 1380 where institutionid = 1381
 update institution set longitude=5.204101, latitude=52.1569 where institutionid = 1380  -- 5.204101	52.1569
 delete institution where institutionid = 1381

 update ProjectFundingInvestigator set institutionid = 1500 where institutionid = 1501
 update institution set longitude=-89.477626, latitude=43.057592 where institutionid = 1500  --   -89.477626	43.057592
 delete institution where institutionid = 1501

 update ProjectFundingInvestigator set institutionid = 1640 where institutionid = 1641
 update institution set longitude=-122.531739, latitude=38.070258 where institutionid = 1640  --   -122.531739	38.070258
 delete institution where institutionid = 1641
  
 update institution set longitude=-104.869909, latitude=39.673271 where institutionid = 1756  --   -104.869909	39.673271
 update institution set longitude=-118.140966, latitude=34.143832 where institutionid = 1757  --   -118.140966	34.143832
 
 update ProjectFundingInvestigator set institutionid = 1792 where institutionid = 1793
 update institution set longitude=-151.191836, latitude=-33.820856 where institutionid = 1792  --   -151.191836	-33.820856
 delete institution where institutionid = 1793

  update ProjectFundingInvestigator set institutionid = 1858 where institutionid = 1859
 update institution set City = 'Walton', longitude=-71.280874, latitude=42.406661 where institutionid = 1858  --   -71.280874	42.406661
 delete institution where institutionid = 1859

 update ProjectFundingInvestigator set institutionid = 1862 where institutionid = 1863
 update institution set longitude=-78.861677, latitude=35.875971 where institutionid = 1862  --   -78.861677	35.875971
 delete institution where institutionid = 1863

 update institution set GRID='grid.482098.f', longitude=-1.2138965, latitude=51.751852 where institutionid = 1904  --   -1.2138965	51.751852
 update institution set GRID='grid.482095.2', longitude=-145.0595289, latitude=-37.7579498 where institutionid = 1905  --   145.0595289	-37.7579498

 update ProjectFundingInvestigator set institutionid = 1961 where institutionid = 1960
 update institution set longitude=0.045998, latitude=51.243917 where institutionid = 1961  --   0.045998	51.243917
 delete institution where institutionid = 1960

 update ProjectFundingInvestigator set institutionid = 2061 where institutionid = 2060
 update institution set longitude=-83.654065, latitude=33.873793 where institutionid = 2061  --   -83.654065	33.873793
 delete institution where institutionid = 2060

 update ProjectFundingInvestigator set institutionid = 4072 where institutionid = 4073
 update institution set longitude=-89.325835, latitude=43.119537 where institutionid = 4072  --   -89.325835	43.119537
 delete institution where institutionid = 4073

 update ProjectFundingInvestigator set institutionid = 2129 where institutionid = 2128
 update institution set longitude=-118.216447, latitude=33.868038 where institutionid = 2129  --   -118.216447	33.868038
 delete institution where institutionid = 2128
  
 update ProjectFundingInvestigator set institutionid = 2188 where institutionid = 2189
 update institution set longitude=-1.319735, latitude=51.575333 where institutionid = 2188  --   -1.319735	51.575333
 delete institution where institutionid = 2189

 update ProjectFundingInvestigator set institutionid = 2229 where institutionid = 2228
 update institution set longitude=-122.094307, latitude=37.424874 where institutionid = 2229  --   -122.094307	37.424874
 delete institution where institutionid = 2228

 update ProjectFundingInvestigator set institutionid = 2245 where institutionid = 2244
 update institution set longitude=151.214082, latitude=-33.884043 where institutionid = 2245  --   151.214082	-33.884043
 delete institution where institutionid = 2244

 update institution set longitude=-84.420824, latitude=-39.117 where institutionid = 2272  --   -84.420824	39.117
 update institution set grid='grid.416809.2', longitude=-79.954494, latitude=39.655256 where institutionid = 2273  --   -79.954494	39.655256
 
 update ProjectFundingInvestigator set institutionid = 2316 where institutionid = 2317
 update institution set longitude=4.826473, latitude=52.350572 where institutionid = 2316  --   4.826473	52.350572
 delete institution where institutionid = 2317

 update institution set grid='grid.266842.c', longitude=151.704444, latitude=-32.892778 where institutionid = 4188  --   151.704444	-32.892778

 update ProjectFundingInvestigator set institutionid = 2418 where institutionid = 2417 
 delete institution where institutionid = 2417

 update ProjectFundingInvestigator set institutionid = 2452 where institutionid = 4299
 update institution set longitude=-117.147525, latitude=32.894908 where institutionid = 2452  --   -117.147525	32.894908
 delete institution where institutionid = 4299

 update ProjectFundingInvestigator set institutionid = 2480 where institutionid = 2481
 update institution set longitude=-0.261731, latitude=51.658371 where institutionid = 2480  --   -0.261731	51.658371
 delete institution where institutionid = 2481
  
 update ProjectFundingInvestigator set institutionid = 2546 where institutionid = 2547
 update institution set longitude=37.439986, latitude=37.439986 where institutionid = 2546  --   -37.439986	37.439986
 delete institution where institutionid = 2547

 update ProjectFundingInvestigator set institutionid = 2576 where institutionid = 2575
 update institution set longitude=-84.393687, latitude=39.403617 where institutionid = 2576  --   -84.393687	39.403617
 delete institution where institutionid = 2575

 update ProjectFundingInvestigator set institutionid = 2659 where institutionid = 2658
 update institution set longitude= -71.130784, latitude=42.500167 where institutionid = 2659  --   -71.130784	42.500167
 delete institution where institutionid = 2658

 update ProjectFundingInvestigator set institutionid = 2731 where institutionid = 2732
 update institution set City='Georgetown', longitude= -97.679808, latitude=30.611418 where institutionid = 2731  --   -97.679808	30.611418
 delete institution where institutionid = 2732

 update ProjectFundingInvestigator set institutionid = 2765 where institutionid in(2766,2767) 
 delete institution where institutionid in(2766,2767)

  update ProjectFundingInvestigator set institutionid = 4106 where institutionid = 4107
 update institution set longitude= -122.393819, latitude=37.581169 where institutionid = 4106  --   -122.393819	37.581169
 delete institution where institutionid = 4107

  update ProjectFundingInvestigator set institutionid = 4109 where institutionid = 4110
 update institution set longitude= -77.434498, latitude=39.43659 where institutionid = 4109  --   -77.434498	39.43659
 delete institution where institutionid = 4110

  update ProjectFundingInvestigator set institutionid = 2901 where institutionid = 2902
 update institution set longitude= -1.788, latitude=51.045 where institutionid = 2901  --   -1.788	51.045
 delete institution where institutionid = 2902

  update institution set longitude= -117.241966, latitude=32.900123 where institutionid = 2920  --   -117.241966	32.900123
  update institution set longitude= 81.28826, latitude=28.365935 where institutionid = 2921  --   -81.28826	28.365935
  update institution set longitude= -86.797469, latitude=33.503084 where institutionid = 3066  --   -86.797469	33.503084
  update institution set longitude= -78.845074, latitude=38.468982 where institutionid = 3092  --   -78.845074	38.468982
  update institution set longitude= -82.49161, latitude=27.982008 where institutionid = 3119  --   -82.49161	27.982008
  update institution set City='Franklin', State='TN',longitude= -86.820777, latitude=35.9545 where institutionid = 3147  --   -86.820777	35.9545
  update institution set longitude= -80.206339, latitude=25.794624 where institutionid = 3148  --   -80.206339	25.794624

 update ProjectFundingInvestigator set institutionid = 3182 where institutionid = 3181
 update institution set longitude= -122.047548, latitude=37.401884 where institutionid = 3182  --   -122.047548	37.401884
 delete institution where institutionid = 3181

 update ProjectFundingInvestigator set institutionid = 4300 where institutionid = 3211
 update institution set longitude= -117.235945, latitude=32.89382 where institutionid = 4300  --   -117.235945	32.89382
 delete institution where institutionid = 3211

 update institution set longitude= -99.73215, latitude=32.467856 where institutionid = 3260  --   -99.73215	32.467856
 update institution set longitude=  -96.841214, latitude=32.820997 where institutionid = 3262  --   -96.841214	32.820997
 update institution set longitude= -106.434542, latitude=31.772298 where institutionid = 3263  --   -106.434542	31.772298
update institution set longitude= -101.923949, latitude=	33.521661 where institutionid = 3264  --    -101.923949	33.521661
 update institution set longitude= -75.11962, latitude=39.925946 where institutionid = 3560  --   -75.11962	39.925946
 update institution set longitude= -74.451819, latitude=40.486216 where institutionid = 3561  --   -74.451819	40.486216
 update institution set longitude= -74.191798, latitude=40.743447 where institutionid = 3562  --   -74.191798	40.743447

 update ProjectFundingInvestigator set institutionid = 3270 where institutionid = 3269
 update institution set longitude= -71.079083, latitude=42.363582 where institutionid = 3270  --   -71.079083	42.363582
 delete institution where institutionid = 3269

 commit
 --rollback

select * from institution where institutionid in (3242,3243,3244,3260,3261,3262,3263,3264,3560,3561,3562)


select * from institution where institutionid in (3269,3270)
select * from ProjectFundingInvestigator where institutionid in (3269,3270)


